//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Foundation

protocol TimeSelectorViewModelProtocol: ObservableObject {
    var selectedTimes: String { get set }
}

class SelectedValues: TimeSelectorViewModelProtocol {
    let repository = TimetableRepository()
    
    @Published var credit: Int = 18                          //GPA
    @Published var majorNum: Int = 3                         //majorcount
    @Published var ELearnNum: Int = 0                        //cybercount
    @Published var selectedSubjects: [SubjectModelBase] = [] //requiredLect
    @Published var selectedTimes: String = ""                //impossibleTimeZone
    
    //request할 때 보낼 과목 조합 리스트
    @Published var selectedMajorCombs: [MajorComb] = []      //majorList
    
    //서버에서 준 과목 조합 리스트
    @Published var majorCombinations: [MajorComb] = []
    
    @Published var timetableList: [[SubjectModelBase]] = []
    
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
        if selectedMajorCombs.contains(where: { $0.combination == combination.combination }) {
            selectedMajorCombs.removeAll(where: { $0.combination == combination.combination })
        } else {
            selectedMajorCombs.append(combination)
        }
    }

    func isSelected(_ combination: MajorComb) -> Bool {
        return selectedMajorCombs.contains(where: { $0.combination == combination.combination })
    }

    
    func fetchMajorCombinations(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) {
        let requiredLectStrings = requiredLect.map { $0.sbjDivcls }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        repository.postMajorComb(GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { [weak self] result in
            switch result {
            case .success(let majorCombModels):
                DispatchQueue.main.async {
                    self?.majorCombinations = majorCombModels
                }
            case .failure:
                print("전공조합을 가져오는데 실패했어요.")
            }
        }
    }
    
    func fetchFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb], completion: @escaping (Result<Void, Error>) -> Void) {
        let requiredLectStrings = requiredLect.map { $0.sbjDivcls }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        let adjustedImpossibleTimeZone = impossibleTimeZone.isEmpty ? "" : impossibleTimeZone
        let adjustedMajorList = majorList.map { majorComb in
            majorComb.combination.map { combination in
                combination.code
            }
        }
        repository.postFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: adjustedImpossibleTimeZone, majorList: adjustedMajorList) { [weak self] result in
            switch result {
            case .success(let finalTimetableList):
                DispatchQueue.main.async {
                    self?.timetableList = finalTimetableList
                    completion(.success(()))
                }
            case .failure(let error):
                print("최종 시간표 목록을 가져오는데 실패했어요.")
                completion(.failure(error))
            }
        }
    }
    
    func postSelectedTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool, completion: @escaping (Bool) -> Void) {
        let codeSectionList = timetableList[timetableIndex].map { $0.sbjDivcls }
        SATTONetworking.shared.postTimetableSelect(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("시간표 저장 성공!")
                    completion(true)
                }
            case .failure(let error):
                print("시간표 저장에 실패했어요.")
                completion(false)
            }
        }
    }
    
    func postCustomTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool, completion: @escaping (Bool) -> Void) {
        
        SATTONetworking.shared.postTimetableSelect(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("시간표 저장 성공!")
                    completion(true)
                }
            case .failure(let error):
                print("시간표 저장에 실패했어요.")
                completion(false)
            }
        }
    }
}

