//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/29/24.
//

import Combine
import Foundation

class LectureSheetViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
    @Published var _searchText: String = ""
    var searchText: String {
        get { _searchText }
        set { services.lectureSearchService.setSearchText(newValue) }
    }
    ///["전체", "1학년", "2학년", "3학년", "4학년"]
    @Published var selectedGrades: [String] = ["전체"]
    ///["전체", "일반교양", "균형교양", "교양필수"]
    @Published var selectedGE: [String] = ["전체"]
    ///["전체", "인문", "사회", "자연", "공학", "예술"]
    @Published var selectedBGE: [String] = ["전체"]
    ///["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    @Published var selectedELOption: [String] = ["전체"]
    
    @Published private var _lectureList: [LectureModel]?
    var lectureList: [LectureModel] {
        get { _lectureList ?? [] }
    }
    
    @Published private var _selectedLectures: [LectureModel] = []
    var selectedLectures: [LectureModel] {
        get { _selectedLectures }
        set { services.lectureSearchService.setSelectedLectures(newValue) }
    }
    
    @Published var currentPage: Int?
    @Published var totalPage: Int? = 0
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool?
    
    @Published private var _selectedBlocks: Set<String> = []
    var selectedBlocks: Set<String> {
        get { _selectedBlocks }
        set { services.lectureSearchService.setSelectedBlocks(newValue) }
    }
    var sortedSelectedBlocks: String {
        return services.constraintService.convertSetToString(_selectedBlocks)
            .replacingOccurrences(of: " ", with: ", ")
    }
    @Published private var _preSelectedBlocks: Set<String> = []
    var preSelectedBlocks: Set<String> {
        get { _preSelectedBlocks }
        set { services.lectureSearchService.setPreSelectedBlocks(newValue)}
    }
    var tempDragBlocks: Set<String> = []
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(container: DIContainer) {
        super.init(container: container)
        
        appState.lectureSearch.$searchText
            .assign(to: \._searchText, on: self)
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
        
        appState.lectureSearch.$selectedBlocks
            .assign(to: \._selectedBlocks, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$preSelectedBlocks
            .assign(to: \._preSelectedBlocks, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$lectureList
            .assign(to: \._lectureList, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedLectures
            .assign(to: \._selectedLectures, on: self)
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
        return !selectedBlocks.isEmpty
    }
    
    func isSelectedLecturesEmpty() -> Bool {
        return selectedLectures.isEmpty
    }
    
    func isSelected(Lecture: LectureModel) -> Bool {
        return selectedLectures.contains(where: { $0.sbjDivcls == Lecture.sbjDivcls })
    }
    
    func clear() {
        selectedLectures.removeAll()
    }
    
    func removeLecture(_ Lecture: LectureModel) {
        if let index = selectedLectures.firstIndex(where: { $0.sbjDivcls == Lecture.sbjDivcls }) {
            selectedLectures.remove(at: index)
        }
    }
    
    func toggleSelection(lecture: LectureModel) -> Bool {
        if let index = selectedLectures.firstIndex(where: { $0.sbjDivcls == lecture.sbjDivcls }) {
            selectedLectures.remove(at: index)
            return true
        } else if !selectedLectures.contains(where: { $0.sbjNo == lecture.sbjNo }) && !isTimeOverlapping(lecture) {
            selectedLectures.append(lecture)
            return true
        }
        return false
    }
    
    func isTimeOverlapping(_ Lecture: LectureModel) -> Bool {
        let newLectureTimes = parseTimes(Lecture)
        for existingLecture in selectedLectures {
            let existingLectureTimes = parseTimes(existingLecture)
            if newLectureTimes.contains(where: { newTime in
                existingLectureTimes.contains(where: { $0 == newTime })
            }) {
                return true
            }
        }
        return false
    }
    
    private func parseTimes(_ Lecture: LectureModel) -> [String] {
        return Lecture.time.components(separatedBy: " ")
    }
    
    func fetchCurrentLectureList() async {
        do {
            try await lectureService.fetchCurrentLectureList()
        } catch {
            print("현재 강의 목록 불러오기에 실패했어요.")
        }
    }
    
    func loadMoreLectures() async {
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

