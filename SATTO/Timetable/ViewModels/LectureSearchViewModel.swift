//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/29/24.
//

import Combine
import Foundation

class LectureSearchViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
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
    
    @Published private var _subjectDetailDataList: [SubjectDetailModel]?
    var lectureList: [SubjectDetailModel] {
        get { _subjectDetailDataList ?? [] }
    }
    
    @Published var currentPage: Int?
    @Published var totalPage: Int? = 0
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(container: DIContainer) {
        super.init(container: container)
        
        appState.lectureSearch.$searchText
            .assign(to: \.searchText, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedGrades
            .assign(to: \.selectedGrades, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedGE
            .assign(to: \.selectedGE, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedBGE
            .assign(to: \.selectedBGE, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedELOption
            .assign(to: \.selectedELOption, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedTimes
            .assign(to: \.selectedTimes, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$subjectDetailDataList
            .assign(to: \._subjectDetailDataList, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$currentPage
            .assign(to: \.currentPage, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$totalPage
            .assign(to: \.totalPage, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$hasMorePages
            .assign(to: \.hasMorePages, on: self)
            .store(in: &cancellables)
    }
    
    private var lectureService: LectureSearchServiceProtocol {
        services.lectureSearchService
    }
    
    private var lectureSearchState: LectureSearchState {
        appState.lectureSearch
    }
    
    // 선택된 학년이 있는지 확인
    func isGradeSelected() -> Bool {
        if selectedGrades.isEmpty || selectedGrades.contains("전체") {
            return false
        }
        return true
    }
    
    // 선택된 교양이 있는지 확인
    func isGESelected() -> Bool {
        if selectedGE.isEmpty || selectedGE.contains("전체") {
            return false
        }
        return true
    }
    
    // 선택된 균형교양이 있는지 확인
    func isBGESelected() -> Bool {
        if selectedBGE.isEmpty {
            return false
        }
        return true
    }
    
    // 선택된 E러닝 옵션이 있는지 확인
    func isELOptionSelected() -> Bool {
        if selectedELOption.isEmpty || selectedELOption.contains("전체") {
            return false
        }
        return true
    }
    
    // 시간 선택 여부 확인
    func isTimeSelected() -> Bool {
        return !selectedTimes.isEmpty
    }
    
    func fetchCurrentLectureList() async {
        do {
            try await lectureService.fetchCurrentLectureList()
        } catch {
            print("현재 강의 목록 불러오기에 실패했어요.")
        }
    }
    
    func loadMoreSubjects() async {
        guard let hasMorePages = hasMorePages, hasMorePages && isLoading != true else { return }
        appState.lectureSearch.addCurrentPage()
        do {
            try await lectureService.fetchCurrentLectureList(page: currentPage ?? 0)
        } catch {
            print("강의 더 불러오기에 실패했어요")
        }
    }
    
    func resetCurrPage() {
        appState.lectureSearch.resetCurrPage()
    }
}

