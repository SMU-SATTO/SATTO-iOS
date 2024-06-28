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
    
    @Published var credit: Int = 18                           //GPA
    @Published var majorNum: Int = 3                         //majorcount
    @Published var ELearnNum: Int = 0                        //cybercount
    @Published var selectedSubjects: [SubjectModelBase] = [] //requiredLect
    @Published var selectedTimes: String = ""                //impossibleTimeZone
    
    @Published var selectedMajorCombs: [[String]] = []       //majorList
    
    @Published var majorCombinations: [MajorCombModel] =
        [
//            MajorCombModel(combinations: [
//                ("Computer Science", "CS101"),
//                ("Mathematics", "MATH201"),
//                ("Physics", "PHYS101")
//            ]),
//            MajorCombModel(combinations: [
//                ("Business Administrationddddddddddddddddddddddddddddd", "BA101"),
//                ("Economics", "ECON201"),
//                ("Statistics", "STAT301")
//            ]),
//            MajorCombModel(combinations: [
//                ("Biology", "BIO101"),
//                ("Chemistry", "CHEM201"),
//                ("Psychology", "PSYC301")
//            ])
        ]
     //서버에서 준 과목 조합 이중 배열 리스트
    
    @Published var timetableList: [[SubjectModelBase]] = [
        [
            SubjectModel(sbjDivcls: "CS", sbjNo: "CS101", sbjName: "Introduction to Computer Science", time: "월1 월2 월3"),
            SubjectModel(sbjDivcls: "MATH", sbjNo: "MATH201", sbjName: "Calculus I", time: "화1 화2 화3"),
            SubjectModel(sbjDivcls: "PHYS", sbjNo: "PHYS101", sbjName: "General Physics I", time: "수1 수2 수3")
        ],
        [
            SubjectModel(sbjDivcls: "BA", sbjNo: "BA101", sbjName: "Principles of Management", time: "월4 월5 월6"),
            SubjectModel(sbjDivcls: "ECON", sbjNo: "ECON201", sbjName: "Microeconomics", time: "화4 화5 화6"),
            SubjectModel(sbjDivcls: "STAT", sbjNo: "STAT301", sbjName: "Statistics for Business", time: "수4 수5 수6")
        ],
        [
            SubjectModel(sbjDivcls: "BIO", sbjNo: "BIO101", sbjName: "General Biology I", time: "월2 월3 월4"),
            SubjectModel(sbjDivcls: "CHEM", sbjNo: "CHEM201", sbjName: "General Chemistry I", time: "화2 화4 화5"),
            SubjectModel(sbjDivcls: "PSYC", sbjNo: "PSYC301", sbjName: "Introductory Psychology", time: "금1 토2 일3")
        ]
    ]
    
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
    
    func fetchMajorCombinations(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) {
        let requiredLectStrings = requiredLect.map { $0.sbjNo }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        repository.postMajorComb(GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { [weak self] result in
            switch result {
            case .success(let majorCombModels):
                DispatchQueue.main.async {
                    self?.majorCombinations = majorCombModels
                }
            case .failure(let error):
                print("Error fetching major combinations: \(error)")
            }
        }
    }
    
    func fetchFinalTimetableList(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping (Result<Void, Error>) -> Void) {
        let requiredLectStrings = requiredLect.map { $0.sbjDivcls }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        let adjustedImpossibleTimeZone = impossibleTimeZone.isEmpty ? "" : impossibleTimeZone
        
        repository.postFinalTimetableList(GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: adjustedImpossibleTimeZone, majorList: majorList) { [weak self] result in
            switch result {
            case .success(let finalTimetableList):
                DispatchQueue.main.async {
                    self?.timetableList = [finalTimetableList]
                    completion(.success(()))
                }
            case .failure(let error):
                print("Error fetching finalTimetableList: \(error)")
                completion(.failure(error))
            }
        }
    }
}

//TODO: - BottomSheetModel로 파싱 필요 및 파싱 과정에서 균형교양 미포함시 resetBGE()
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

