//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
protocol ConstraintServiceProtocol: Sendable {
    func set<Value>(_ keyPath: WritableKeyPath<ConstraintState, Value>, to value: Value)
    func convertSetToString(_ set: Set<String>) -> String
    func getMajorComb() async throws
    func getFinalTimetableList(isRaw: Bool) async throws
    func saveTimetable(timetableIndex: Int, timetableName: String) async throws
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async throws
}

struct ConstraintService: ConstraintServiceProtocol {
    var appState: AppState
    var webRepositories: AppEnvironment.WebRepositories
    
    var constraintRepository: ConstraintRepositoryProtocol {
        webRepositories.constraintRepository
    }
    
    func set<Value>(_ keyPath: WritableKeyPath<ConstraintState, Value>, to value: Value) {
        appState.constraint[keyPath: keyPath] = value
    }
    
    func convertSetToString(_ set: Set<String>) -> String {
        let weekdaysOrder = ["월", "화", "수", "목", "금", "토", "일"]
        
        let sortedSet = set.sorted {
            let firstDay = String($0.prefix(1))
            let secondDay = String($1.prefix(1))
            
            // 요일 순서에 맞춰 정렬
            if let firstIndex = weekdaysOrder.firstIndex(of: firstDay),
               let secondIndex = weekdaysOrder.firstIndex(of: secondDay) {
                if firstIndex == secondIndex {
                    // 같은 요일일 경우 시간 순서로 정렬
                    return $0.compare($1, options: .numeric) == .orderedAscending
                }
                return firstIndex < secondIndex
            }
            return false
        }
        
        return sortedSet.joined(separator: " ")
    }

    func getMajorComb() async throws {
        let credit = appState.constraint.constraints.credit
        let requiredLectStrings = appState.constraint.constraints.requiredLectures.map { $0.sbjDivcls }
        let requiredLectures = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        let majorCount = appState.constraint.constraints.majorCount
        let eLearnCount = appState.constraint.constraints.eLearnCount
        let invalidTimes = convertSetToString(appState.constraint.constraints.invalidTimes)
        
        let dto = try await constraintRepository.getMajorComb(GPA: credit, requiredLect: requiredLectures, majorCount: majorCount, cyberCount: eLearnCount, impossibleTimeZone: invalidTimes)
        
        guard let majorCombDtos = dto.result else { return }
        
        let majorComb = majorCombDtos.map { dto in
            MajorComb(combination: dto.combination.map { combinationDto in
                Combination(lectName: combinationDto.lectName, code: combinationDto.code)
            })
        }
        appState.constraint.majorCombs = majorComb
    }
    
    func getFinalTimetableList(isRaw: Bool) async throws {
        let credit = appState.constraint.constraints.credit
        let requiredLectures = appState.constraint.constraints.requiredLectures.isEmpty ? [""] : appState.constraint.constraints.requiredLectures.map { $0.sbjDivcls }
        let majorCount = appState.constraint.constraints.majorCount
        let eLearnCount = appState.constraint.constraints.eLearnCount
        let invalidTimes = convertSetToString(appState.constraint.constraints.invalidTimes)
        
        let adjustedMajorList = appState.constraint.selectedMajorCombs.map { $0.combination.map { $0.code } }
        
        let dto = try await constraintRepository.getFinalTimetableList(isRaw: isRaw, GPA: credit, requiredLect: requiredLectures, majorCount: majorCount, cyberCount: eLearnCount, impossibleTimeZone: invalidTimes, majorList: adjustedMajorList)
        
        guard let finalTimetableListsDto = dto.result else { return }
        
        let finalTimetableLists: [[LectureModel]] = finalTimetableListsDto.map { dto in
            dto.timeTable.map { finalTimetableDto in
                LectureModel(sbjDivcls: finalTimetableDto.codeSection, sbjNo: finalTimetableDto.code, sbjName: finalTimetableDto.lectName, time: finalTimetableDto.lectTime, prof: finalTimetableDto.professor, major: finalTimetableDto.cmpDiv, credit: finalTimetableDto.credit)
            }
        }
        appState.constraint.finalTimetableList = finalTimetableLists
    }
    
    func saveTimetable(timetableIndex: Int, timetableName: String) async throws {
        guard let timetableList = appState.constraint.finalTimetableList else { return }
        let codeSectionList = timetableList[timetableIndex].map { $0.sbjDivcls }
        
        try await constraintRepository.saveTimetable(codeSectionList: codeSectionList, semesterYear: appState.constraint.semesterYear, timeTableName: timetableName, isPublic: true, isRepresented: false)
    }
    
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async throws {
        try await constraintRepository.saveTimetable(codeSectionList: codeSectionList, semesterYear: appState.constraint.semesterYear, timeTableName: timeTableName, isPublic: true, isRepresented: false)
    }
}

struct FakeConstraintService: ConstraintServiceProtocol {
    func set<Value>(_ keyPath: WritableKeyPath<ConstraintState, Value>, to value: Value) { }
    func convertSetToString(_ set: Set<String>) -> String { "" }
    func getMajorComb() async throws { }
    func getFinalTimetableList(isRaw: Bool) async throws { }
    func saveTimetable(timetableIndex: Int, timetableName: String) async throws { }
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async throws { }
}
