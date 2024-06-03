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

class SelectedValues: TimeSelectorViewModelProtocol {
    @Published var credit: Int = 6
    @Published var majorNum: Int = 0
    @Published var ELearnNum: Int = 0
//    @Published var essentialSubjects: [SubjectModelBase] = []
    @Published var selectedSubjects: [SubjectModelBase] = []
    ///"월1 월2 월3"
    @Published var selectedTimes: String = ""
    
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

//MARK: - BottomSheetModel로 파싱 필요 및 파싱 과정에서 균형교양 미포함시 resetBGE()
final class BottomSheetViewModel: TimeSelectorViewModelProtocol {
    @Published var bottomSheetFilter: BottomSheetModel = BottomSheetModel(
        grade: [1, 2],
        GEOption: ["균형교양"],
        BGEOption: "인문영역",
        eLearn: 1,
        time: "월1 월2 월3"
    )
    
    @Published var selectedGrades: [String] = ["전체"]
    @Published var selectedGE: [String] = ["전체"]
    @Published var selectedBGE: [String] = []
    @Published var selectedELOption: [String] = ["전체"]
    @Published var selectedTimes: String = ""
    
    func resetBGE() {
        selectedBGE = []
    }
    
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
}

