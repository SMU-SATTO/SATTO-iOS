//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Foundation

class SelectedMajorCombination: ObservableObject {
    @Published var selectedMajorCombs: [[String]] = []
    
    func toggleSelection(_ combination: [String]) {
        if selectedMajorCombs.contains(combination) {
            selectedMajorCombs.removeAll(where: { $0 == combination })
        }
        else {
            selectedMajorCombs.append(combination)
        }
    }
        
    func isSelected(_ combination: [String]) -> Bool {
        return selectedMajorCombs.contains(combination)
    }
    
    //MARK: - POST 요청
}

class SelectedValues: ObservableObject {
    @Published var credit: Int = 6
    @Published var majorNum: Int = 0
    @Published var ELearnNum: Int = 0
//    @Published var essentialSubjects: [SubjectModelBase] = []
    @Published var selectedSubjects: [SubjectModelBase] = []
    ///"월1 월2 월3"
    @Published var invalidTimes: String = ""
    
    func isSelectedSubjectsEmpty() -> Bool {
        return selectedSubjects.isEmpty
    }
    
    func addSubject(_ subject: SubjectModelBase) {
        if !selectedSubjects.contains(where: { $0.sbjDivcls == subject.sbjDivcls }) && !isTimeOverlapping(for: subject) {
            selectedSubjects.append(subject)
        }
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
        } else if !isTimeOverlapping(for: subject) {
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
    //MARK: - Post 요청
}
