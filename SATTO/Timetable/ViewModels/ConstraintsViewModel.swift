//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Combine
import Foundation

class ConstraintsViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
    @Published var credit: Int = 18        //GPA
    @Published var majorNum: Int = 3       //majorcount
    @Published var ELearnNum: Int = 0      //cybercount
    @Published private var _selectedLectures: [LectureModel] = [] //requiredLect
    var selectedLectures: [LectureModel] {
        get { _selectedLectures }
        set { services.constraintService.setSelectedLectures(newValue) }
    }
    
    ///`TimetableSelector`설정
    @Published private var _selectedBlocks: Set<String> = []
    var selectedBlocks: Set<String> {
        get { _selectedBlocks }
        set { services.constraintService.setSelectedBlocks(newValue) }
    }
    var sortedSelectedBlocks: String {
        return services.constraintService.convertSetToString(_selectedBlocks)
            .replacingOccurrences(of: " ", with: ", ")
    }
    @Published private var _preSelectedBlocks: Set<String> = []
    var preSelectedBlocks: Set<String> {
        get { _preSelectedBlocks }
        set { services.constraintService.setPreSelectedBlocks(newValue)}
    }
    var tempDragBlocks: Set<String> = []
    
    //request할 때 보낼 과목 조합 리스트
    @Published var selectedMajorCombs: [MajorComb] = []      //majorList
    
    //서버에서 준 과목 조합 리스트
    @Published private var _majorCombinations: [MajorComb]? = []
    var majorCombinations: [MajorComb] {
        get { _majorCombinations ?? [] }
    }
    
    @Published private var _timetableList: [[LectureModel]]? = []
    var timetableList: [[LectureModel]] {
        get { _timetableList ?? []}
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override init (container: DIContainer) {
        super.init(container: container)
        
        appState.constraint.$credit
            .assign(to: \.credit, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$majorNum
            .assign(to: \.majorNum, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$eLearnNum
            .assign(to: \.ELearnNum, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$selectedLectures
            .assign(to: \._selectedLectures, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$selectedBlocks
            .assign(to: \._selectedBlocks, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$preSelectedBlocks
            .assign(to: \._preSelectedBlocks, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$selectedMajorCombs
            .assign(to: \.selectedMajorCombs, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$majorCombs
            .assign(to: \._majorCombinations, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$finalTimetableList
            .assign(to: \._timetableList, on: self)
            .store(in: &cancellables)
    }
    
    private var constraintService: ConstraintServiceProtocol {
        services.constraintService
    }
    
    private var constraintState: ConstraintState {
        appState.constraint
    }
    
    func isSelectedLecturesEmpty() -> Bool {
        return selectedLectures.isEmpty
    }

    func removeLecture(_ Lecture: LectureModel) {
        if let index = selectedLectures.firstIndex(where: { $0.sbjDivcls == Lecture.sbjDivcls }) {
            selectedLectures.remove(at: index)
        }
    }
    
    func toggleSelection(Lecture: LectureModel) -> Bool {
        if let index = selectedLectures.firstIndex(where: { $0.sbjDivcls == Lecture.sbjDivcls }) {
            selectedLectures.remove(at: index)
            let timesToRemove = parseTimes(for: Lecture)
            _preSelectedBlocks.subtract(timesToRemove)
            return true
        } else if !selectedLectures.contains(where: { $0.sbjNo == Lecture.sbjNo }) && !isTimeOverlapping(for: Lecture) {
            selectedLectures.append(Lecture)
            let newTimes = parseTimes(for: Lecture)
            _preSelectedBlocks.formUnion(newTimes)
            return true
        }
        return false
    }
    
    func isSelected(Lecture: LectureModel) -> Bool {
        return selectedLectures.contains(where: { $0.sbjDivcls == Lecture.sbjDivcls })
    }
    
    func isTimeOverlapping(for Lecture: LectureModel) -> Bool {
        let newLectureTimes = parseTimes(for: Lecture)
        for existingLecture in selectedLectures {
            let existingLectureTimes = parseTimes(for: existingLecture)
            if newLectureTimes.contains(where: { newTime in
                existingLectureTimes.contains(where: { $0 == newTime })
            }) {
                return true
            }
        }
        return false
    }
    
    func parsePreselectedSlots() -> [String] {
        return selectedLectures.flatMap { parseTimes(for: $0) }
    }
    
    func clear() {
        selectedLectures.removeAll()
    }
    
    private func parseTimes(for Lecture: LectureModel) -> [String] {
        return Lecture.time.components(separatedBy: " ")
    }
    
    func toggleSelection(_ combination: MajorComb) {
        constraintState.toggleSelection(combination)
    }

    func isSelected(_ combination: MajorComb) -> Bool {
        return selectedMajorCombs.contains(where: { $0.combination == combination.combination })
    }

    func fetchMajorCombinations() async {
        do {
            try await constraintService.getMajorComb()
        } catch {
            print("전공조합을 가져오는데 실패했어요.")
        }
    }
    
    func fetchFinalTimetableList(isRaw: Bool) async {
        do {
            try await constraintService.getFinalTimetableList(isRaw: isRaw)
        } catch {
            print("최종 시간표 목록을 가져오는데 실패했어요.")
        }
    }
    
    func saveTimetable(timetableIndex: Int, timetableName: String) async {
        do {
            try await constraintService.saveTimetable(timetableIndex: timetableIndex, timetableName: timetableName)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
    
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async {
        do {
            try await constraintService.saveCustomTimetable(codeSectionList: codeSectionList, timeTableName: timeTableName)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
}

