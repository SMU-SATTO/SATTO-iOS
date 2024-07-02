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
    
    //    @Published var subjectDetailDataList: [TimetableDetailModel] = []
    @Published var subjectDetailDataList: [SubjectDetailModel] = [
        SubjectDetailModel(major: "1전심", sbjDivcls: "HAEA9239-3", sbjNo: "HAEA9239", sbjName: "GPU프로그래밍", prof: "나재호", time: "화5 화3 수8", credit: 3, enrolledStudents: 115, yesterdayEnrolledData: 100, threeDaysAgoEnrolledData: 80),
        SubjectDetailModel(major: "1전심", sbjDivcls: "HAEA0005-1", sbjNo: "HAEA0005", sbjName: "디지털신호처리", prof: "강상욱", time: "수1 수2 수3", credit: 3, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
    ]
    
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
    
    func fetchCurrentLectureList() {
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
        
        let isCyber = selectedELOption.contains("E러닝 빼고 보기") ? 0 : 1
        
        repository.getCurrentLectureList(
            request:
                CurrentLectureListRequest(
                    searchText: searchText,
                    grade: grades,
                    elective: elective,
                    normal: normal,
                    essential: essential,
                    humanity: humanity,
                    society: society,
                    nature: nature,
                    engineering: engineering,
                    art: art,
                    isCyber: isCyber,
                    timeZone: selectedTimes
                )) { [weak self] result in
                    switch result {
                    case .success(let subjectDetailModels):
                        DispatchQueue.main.async {
                            self?.subjectDetailDataList = subjectDetailModels
                        }
                    case .failure(let error):
                        print("Error fetching currentLectureList: \(error)")
                    }
                }
    }
}

