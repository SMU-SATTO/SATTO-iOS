//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Combine
import Foundation

protocol TimeSelectorViewModelProtocol: ObservableObject {
    var selectedTimes: String { get set }
}

class ConstraintsViewModel: BaseViewModel, TimeSelectorViewModelProtocol {
    @Published var credit: Int = 18                          //GPA
    @Published var majorNum: Int = 3                         //majorcount
    @Published var ELearnNum: Int = 0                        //cybercount
    @Published var selectedSubjects: [SubjectModelBase] = [] //requiredLect
    @Published var selectedTimes: String = ""                //impossibleTimeZone
    
    //request할 때 보낼 과목 조합 리스트
    @Published var selectedMajorCombs: [MajorComb] = []      //majorList
    
    //서버에서 준 과목 조합 리스트
    @Published private var _majorCombinations: [MajorComb]? = []
    var majorCombinations: [MajorComb] {
        get { _majorCombinations ?? [] }
    }
    
    @Published private var _timetableList: [[SubjectModelBase]]? = []
    var timetableList: [[SubjectModelBase]] {
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
        
        appState.constraint.$ELearnNum
            .assign(to: \.ELearnNum, on: self)
            .store(in: &cancellables)
        
        appState.constraint.$selectedSubjects
            .assign(to: \.selectedSubjects, on: self)
            .store(in: &cancellables)
        appState.constraint.$selectedTimes
            .assign(to: \.selectedTimes, on: self)
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
    
    func isSelectedSubjectsEmpty() -> Bool {
        return selectedSubjects.isEmpty
    }

    func removeSubject(_ subject: SubjectModelBase) {
        if let index = selectedSubjects.firstIndex(where: { $0.sbjDivcls == subject.sbjDivcls }) {
            selectedSubjects.remove(at: index)
        }
    }
    
    func toggleSelection(subject: SubjectModelBase) -> Bool {
        if let index = selectedSubjects.firstIndex(where: { $0.sbjDivcls == subject.sbjDivcls }) {
            selectedSubjects.remove(at: index)
            return true
        } else if !selectedSubjects.contains(where: { $0.sbjNo == subject.sbjNo }) && !isTimeOverlapping(for: subject) {
            selectedSubjects.append(subject)
            return true
        }
        return false
    }
    
    func isSelected(subject: SubjectModelBase) -> Bool {
        return selectedSubjects.contains(where: { $0.sbjDivcls == subject.sbjDivcls })
    }
    
    func isTimeOverlapping(for subject: SubjectModelBase) -> Bool {
        let newSubjectTimes = parseTimes(for: subject)
        for existingSubject in selectedSubjects {
            let existingSubjectTimes = parseTimes(for: existingSubject)
            if newSubjectTimes.contains(where: { newTime in
                existingSubjectTimes.contains(where: { $0 == newTime })
            }) {
                return true
            }
        }
        return false
    }
    
    func parsePreselectedSlots() -> [String] {
        return selectedSubjects.flatMap { parseTimes(for: $0) }
    }
    
    func clear() {
        selectedSubjects.removeAll()
    }
    
    private func parseTimes(for subject: SubjectModelBase) -> [String] {
        return subject.time.components(separatedBy: " ")
    }
    
    func toggleSelection(_ combination: MajorComb) {
        constraintState.toggleSelection(combination)
    }

    func isSelected(_ combination: MajorComb) -> Bool {
        return selectedMajorCombs.contains(where: { $0.combination == combination.combination })
    }

    func fetchMajorCombinations(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async {
        do {
            try await constraintService.getMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone)
        } catch {
            print("전공조합을 가져오는데 실패했어요.")
        }
    }
    
    func fetchFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb]) async {
        do {
            try await constraintService.getFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList)
        } catch {
            print("최종 시간표 목록을 가져오는데 실패했어요.")
        }
    }
    
    func saveTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async {
        do {
            try await constraintService.saveTimetable(timetableIndex: timetableIndex, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
    
    func saveCustomTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async {
        do {
            try await constraintService.saveCustomTimetable(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
}

