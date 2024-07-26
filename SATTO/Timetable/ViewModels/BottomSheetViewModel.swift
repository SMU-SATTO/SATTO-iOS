//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/29/24.
//

import Foundation

final class BottomSheetViewModel: TimeSelectorViewModelProtocol {
    let repository = TimetableRepository()
    
    @Published var searchText: String = ""
    ///["전체", "1학년", "2학년", "3학년", "4학년"]
    @Published var selectedGrades: [String] = ["전체"]
    ///["전체", "일반교양", "균형교양", "교양필수"]
    @Published var selectedGE: [String] = ["전체"]
    ///["전체", "인문", "사회", "자연", "공학", "예술"]
    @Published var selectedBGE: [String] = ["전체"]
    ///["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    @Published var selectedELOption: [String] = ["전체"]
    @Published var selectedTimes: String = ""
    
    @Published var subjectDetailDataList: [SubjectDetailModel] = []
    
    @Published var currentPage: Int = 0
    @Published var totalPage: Int? = 0
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    
    func isGradeSelected() -> Bool {
        if selectedGrades.isEmpty || selectedGrades.contains("전체") {
            return false
        }
        return true
    }
    
    func isGESelected() -> Bool {
        if selectedGE.isEmpty || selectedGE.contains("전체") {
            return false
        }
        return true
    }
    
    func isBGESelected() -> Bool {
        if selectedBGE.isEmpty {
            return false
        }
        return true
    }
    
    func isELOptionSelected() -> Bool {
        if selectedELOption.isEmpty || selectedELOption.contains("전체") {
            return false
        }
        return true
    }
    
    func isTimeSelected() -> Bool {
        if selectedTimes == "" {
            return false
        }
        return true
    }
    
    func fetchCurrentLectureList(page: Int, completion: @escaping (Bool) -> Void = { _ in }) {
        guard !isLoading else { return }
        isLoading = true
        
        let grades: [Int] = selectedGrades.contains("전체") ? [] : selectedGrades.compactMap { grade in
            switch grade {
            case "1학년":
                return 1
            case "2학년":
                return 2
            case "3학년":
                return 3
            case "4학년":
                return 4
            default:
                return nil
            }
        }
        
        let elective = selectedGE.contains("균형교양") ? 1 : 0
        let normal = selectedGE.contains("일반교양") ? 1 : 0
        let essential = selectedGE.contains("교양필수") ? 1 : 0
        
        let humanity = selectedBGE.contains("인문") ? 1 : 0
        let society = selectedBGE.contains("사회") ? 1 : 0
        let nature = selectedBGE.contains("자연") ? 1 : 0
        let engineering = selectedBGE.contains("공학") ? 1 : 0
        let art = selectedBGE.contains("예술") ? 1 : 0
        
        var isCyber: Int {
            if selectedELOption.contains("전체") {
                return 0
            } else if selectedELOption.contains("E러닝만 보기") {
                return 1
            } else if selectedELOption.contains("E러닝 빼고 보기") {
                return 2
            } else {
                return 0
            }
        }
        
        repository.postCurrentLectureList(request: CurrentLectureListRequest(searchText: searchText, grade: grades, elective: elective, normal: normal, essential: essential, humanity: humanity, society: society, nature: nature, engineering: engineering, art: art, isCyber: isCyber, timeZone: selectedTimes), page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let subjectDetailModels):
                    if page == 0 {
                        self?.subjectDetailDataList = subjectDetailModels.0
                    } else {
                        self?.subjectDetailDataList.append(contentsOf: subjectDetailModels.0)
                    }
                    self?.totalPage = subjectDetailModels.1
                    self?.hasMorePages = self?.currentPage ?? 0 < (self?.totalPage ?? 0) - 1
                    completion(true)
                case .failure(let error):
                    print("Error fetching currentLectureList: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func loadMoreSubjects() {
        guard hasMorePages && !isLoading else { return }
        currentPage += 1
        fetchCurrentLectureList(page: currentPage)
    }
    
    func resetCurrPage() {
        currentPage = 0
    }
}

