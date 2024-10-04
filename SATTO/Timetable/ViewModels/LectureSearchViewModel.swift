//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/29/24.
//

import Combine
import Foundation

class LectureSearchViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
    @Published private var _lectureFilter: LectureFilterModel = LectureFilterModel()
    var lectureFilter: LectureFilterModel {
        get { _lectureFilter }
        set { lectureService.set(\.lectureFilter, to: newValue) }
    }
    let categories = ["학년", "교양", "e-러닝", "시간"]
    let gradeSubCategories = ["1학년", "2학년", "3학년", "4학년"]
    let electiveSubCategories = ["일반교양", "균형교양", "교양필수"]
    let balanceSubCategories = ["인문", "사회", "자연", "공학", "예술"]
    let eLearnSubCategories = ["E러닝만 보기", "E러닝 빼고 보기"]
    
    @Published private var _selectedGradeCategories: [Bool] = [false, false, false, false]
    var selectedGradeCategories: [Bool] {
        get { _selectedGradeCategories }
        set { lectureService.set(\.selectedGradeCategories, to: newValue)}
    }
    @Published private var _selectedElectiveCategories: [Bool] = [false, false, false]
    var selectedElectiveCategories: [Bool] {
        get { _selectedElectiveCategories }
        set { lectureService.set(\.selectedElectiveCategories, to: newValue) }
    }
    @Published private var _selectedBalanceCategories: [Bool] = [false, false, false, false, false]
    var selectedBalanceCategories: [Bool] {
        get { _selectedBalanceCategories }
        set { lectureService.set(\.selectedBalanceCategories, to: newValue) }
    }
    @Published private var _selectedELearnCategories: [Bool] = [false, false]
    var selectedELearnCategories: [Bool] {
        get { _selectedELearnCategories }
        set { lectureService.set(\.selectedELearnCategories, to: newValue) }
    }
    
    @Published private var _lectureList: [LectureModel]?
    var lectureList: [LectureModel] {
        get { _lectureList ?? [] }
    }
    
    @Published private var _selectedLectures: [LectureModel] = []
    var selectedLectures: [LectureModel] {
        get { _selectedLectures }
        set { lectureService.set(\.selectedLectures, to: newValue) }
    }

    @Published var currentPage: Int?
    @Published var totalPage: Int? = 0
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool?
    
    @Published private var _selectedBlocks: Set<String> = []
    var selectedBlocks: Set<String> {
        get { _selectedBlocks }
        set { lectureService.set(\.lectureFilter.category.time, to: newValue) }
    }
    @Published private var _preSelectedBlocks: Set<String> = []
    var preSelectedBlocks: Set<String> {
        get { _preSelectedBlocks }
        set { services.lectureSearchService.set(\.preSelectedBlocks, to: newValue)}
    }
    var tempDragBlocks: Set<String> = []
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(container: DIContainer) {
        super.init(container: container)
        
        appState.lectureSearch.$lectureFilter
            .assign(to: \._lectureFilter, on: self)
            .store(in: &cancellables)
        
        lectureSearchState.$selectedGradeCategories
            .assign(to: \._selectedGradeCategories, on: self)
            .store(in: &cancellables)
        
        lectureSearchState.$selectedElectiveCategories
            .assign(to: \._selectedElectiveCategories, on: self)
            .store(in: &cancellables)
        
        lectureSearchState.$selectedBalanceCategories
            .assign(to: \._selectedBalanceCategories, on: self)
            .store(in: &cancellables)
        
        lectureSearchState.$selectedELearnCategories
            .assign(to: \._selectedELearnCategories, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$lectureFilter
            .map { $0.category.time }
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

    func resetSearchText() {
        lectureFilter.searchText = ""
    }
    
    func updateGrade(_ selection: [Bool]?) {
        guard let selection = selection else {
            lectureFilter.category.grade = []
            return
        }

        let gradeStrings = ["1학년", "2학년", "3학년", "4학년"]

        let selectedGrades = selection.enumerated().compactMap { index, isSelected in
            isSelected ? gradeStrings[index] : nil
        }

        lectureFilter.category.grade = selectedGrades
    }
    
    func updateElective(_ selection: [Bool]?) {
        guard let selection = selection else {
            lectureFilter.category.elective = ElectiveModel(
                normal: false,
                balance: BalanceElectiveModel(),
                essential: false
            )
            return
        }
        
        let previousBalance = lectureFilter.category.elective.balance
        
        lectureFilter.category.elective = ElectiveModel(
            normal: selection[0],
            balance: selection[1] ? previousBalance : BalanceElectiveModel(),
            essential: selection[2]
        )
    }
    
    func updateBalanceElective(_ selection: [Bool]?) {
        guard let selection = selection else {
            lectureFilter.category.elective.balance = BalanceElectiveModel()
            return
        }
        
        let selectedBalances = selection.enumerated().compactMap { index, isSelected in
            isSelected ? index : nil
        }
        
        lectureFilter.category.elective.balance = BalanceElectiveModel(
            humanity: selectedBalances.contains(0),
            society: selectedBalances.contains(1),
            nature: selectedBalances.contains(2),
            engineering: selectedBalances.contains(3),
            art: selectedBalances.contains(4)
        )
    }
    
    func updateELearn(_ selection: [Bool]?) {
        guard let selection = selection else {
            lectureFilter.category.eLearn = "전체"
            return
        }

        lectureFilter.category.eLearn = selection[0] 
        ? "E러닝만 보기"
        : selection[1]
        ? "E러닝 빼고 보기"
        : "전체"
    }
    
    func isSubCategorySelected(for category: String) -> Bool {
        switch category {
        case "학년":
            return selectedGradeCategories.contains(true)
        case "교양":
            return selectedElectiveCategories.contains(true)
        case "e-러닝":
            return selectedELearnCategories.contains(true)
        case "시간":
            return !selectedBlocks.isEmpty
        default:
            return false
        }
    }
    
    // 서브 카테고리 선택 로직 처리
    func toggleSubCategorySelection(for category: String, at index: Int, allowDuplicates: Bool) {
        switch category {
        case "학년":
            handleSelection(for: &selectedGradeCategories, at: index, allowDuplicates: allowDuplicates)
        case "교양":
            handleSelection(for: &selectedElectiveCategories, at: index, allowDuplicates: allowDuplicates)
        case "균형교양":
            handleSelection(for: &selectedBalanceCategories, at: index, allowDuplicates: allowDuplicates)
        case "e-러닝":
            handleSelection(for: &selectedELearnCategories, at: index, allowDuplicates: allowDuplicates)
        default:
            break
        }
    }

        // 서브 카테고리 선택 처리 함수
    private func handleSelection(for categories: inout [Bool], at index: Int, allowDuplicates: Bool) {
        if allowDuplicates {
            categories[index].toggle()
        } else {
            for i in categories.indices {
                categories[i] = (i == index)
            }
        }
    }
    
    func resetSubCategory(for category: String) {
        switch category {
        case "학년":
            selectedGradeCategories = Array(repeating: false, count: selectedGradeCategories.count)
            updateGrade(selectedGradeCategories)
        case "교양":
            selectedElectiveCategories = Array(repeating: false, count: selectedElectiveCategories.count)
            selectedBalanceCategories = Array(repeating: false, count: selectedBalanceCategories.count)
            updateElective(selectedElectiveCategories)
        case "균형교양":
            selectedBalanceCategories = Array(repeating: false, count: selectedBalanceCategories.count)
            updateBalanceElective(selectedBalanceCategories)
        case "e-러닝":
            selectedELearnCategories = Array(repeating: false, count: selectedELearnCategories.count)
            updateELearn(selectedELearnCategories)
        default:
            break
        }
    }
    
    func isSelectedLecturesEmpty() -> Bool {
        return selectedLectures.isEmpty
    }
    
    func isSelected(Lecture: LectureModel) -> Bool {
        return selectedLectures.contains(where: { $0.sbjDivcls == Lecture.sbjDivcls })
    }
    
    func clearSelectedLectures() {
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
    
    func searchLecture() async {
        do {
            try await lectureService.searchLecture()
        } catch {
            print("현재 강의 목록 불러오기에 실패했어요.")
        }
    }
    
    func loadMoreLectures() async {
        guard let hasMorePages = hasMorePages, hasMorePages && isLoading != true else { return }
        appState.lectureSearch.addCurrentPage()
        do {
            try await lectureService.searchLecture(page: currentPage ?? 0)
        } catch {
            print("강의 더 불러오기에 실패했어요")
        }
    }
    
    func resetCurrPage() {
        appState.lectureSearch.resetCurrPage()
    }
}

