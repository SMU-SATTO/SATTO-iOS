//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Combine
import Foundation

class ConstraintsViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
    @Published private var _credit: Int = 18        //GPA
    var credit: Int {
        get { _credit }
        set { constraintService.set(\.credit, to: newValue) }
    }
    @Published private var _majorNum: Int = 3       //majorcount
    var majorNum: Int {
        get { _majorNum }
        set { constraintService.set(\.majorNum, to: newValue) }
    }
    @Published private var _eLearnNum: Int = 0      //cybercount
    var eLearnNum: Int {
        get { _eLearnNum }
        set { constraintService.set(\.eLearnNum, to: newValue) }
    }
    @Published private var _selectedLectures: [LectureModel] = [] //requiredLect
    var selectedLectures: [LectureModel] {
        get { _selectedLectures }
        set { constraintService.set(\.selectedLectures, to: newValue) }
    }
    
    ///`TimetableSelector`설정
    @Published private var _selectedBlocks: Set<String> = []
    var selectedBlocks: Set<String> {
        get { _selectedBlocks }
        set { constraintService.set(\.selectedBlocks, to: newValue) }
    }
    var sortedSelectedBlocks: String {
        return constraintService.convertSetToString(_selectedBlocks)
            .replacingOccurrences(of: " ", with: ", ")
    }
    @Published private var _preSelectedBlocks: Set<String> = []
    var preSelectedBlocks: Set<String> {
        get { _preSelectedBlocks }
        set { constraintService.set(\.preSelectedBlocks, to: newValue) }
    }
    var tempDragBlocks: Set<String> = []
    
    //request할 때 보낼 과목 조합 리스트
    @Published private var _selectedMajorCombs: [MajorComb] = []      //majorList
    var selectedMajorCombs: [MajorComb] {
        get { _selectedMajorCombs }
        set {constraintService.set(\.selectedMajorCombs, to: newValue) }
    }
    
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
        
        constraintState.$credit
            .assign(to: \._credit, on: self)
            .store(in: &cancellables)
        
        constraintState.$majorNum
            .assign(to: \._majorNum, on: self)
            .store(in: &cancellables)
        
        constraintState.$eLearnNum
            .assign(to: \._eLearnNum, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedLectures
            .assign(to: \._selectedLectures, on: self)
            .store(in: &cancellables)
        
        constraintState.$selectedBlocks
            .assign(to: \._selectedBlocks, on: self)
            .store(in: &cancellables)
        
        appState.lectureSearch.$selectedLectures
            .map { [weak self] selectedLectures in
                guard let self = self else { return Set<String>() }
                let newPreSelectedBlocks = selectedLectures.flatMap { lecture in
                    self.parseTimes(for: lecture)
                }
                return Set(newPreSelectedBlocks)
            }
            .assign(to: \._preSelectedBlocks, on: self)
            .store(in: &cancellables)
        
        constraintState.$selectedMajorCombs
            .assign(to: \._selectedMajorCombs, on: self)
            .store(in: &cancellables)
        
        constraintState.$majorCombs
            .assign(to: \._majorCombinations, on: self)
            .store(in: &cancellables)
        
        constraintState.$finalTimetableList
            .assign(to: \._timetableList, on: self)
            .store(in: &cancellables)
    }
    
    private var constraintService: ConstraintServiceProtocol {
        services.constraintService
    }
    
    private var constraintState: ConstraintState {
        appState.constraint
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

