//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
protocol ConstraintServiceProtocol: Sendable {
    func setSelectedSubjects(_ value: [SubjectModelBase])
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
    
    func setSelectedSubjects(_ value: [SubjectModelBase]) {
        appState.constraint.selectedSubjects = value
    }

    func getMajorComb() async throws {
        let requiredLectStrings = appState.constraint.selectedSubjects.map { $0.sbjDivcls }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        
        let dto = try await constraintRepository.getMajorComb(GPA: appState.constraint.credit, requiredLect: adjustedRequiredLect, majorCount: appState.constraint.majorNum, cyberCount: appState.constraint.eLearnNum, impossibleTimeZone: appState.constraint.selectedTimes)
        
        guard let majorCombDtos = dto.result else { return }
        
        let majorComb = majorCombDtos.map { dto in
            MajorComb(combination: dto.combination.map { combinationDto in
                Combination(lectName: combinationDto.lectName, code: combinationDto.code)
            })
        }
        appState.constraint.fetchMajorCombs(majorComb)
    }
    
    func getFinalTimetableList(isRaw: Bool) async throws {
        let adjustedRequiredLect = appState.constraint.selectedSubjects.isEmpty ? [""] : appState.constraint.selectedSubjects.map { $0.sbjDivcls }
        let adjustedMajorList = appState.constraint.selectedTimes.isEmpty ? [[""]] : appState.constraint.selectedMajorCombs.map { $0.combination.map { $0.code } }
        
        let dto = try await constraintRepository.getFinalTimetableList(isRaw: isRaw, GPA: appState.constraint.credit, requiredLect: adjustedRequiredLect, majorCount: appState.constraint.majorNum, cyberCount: appState.constraint.eLearnNum, impossibleTimeZone: appState.constraint.selectedTimes, majorList: adjustedMajorList)
        
        guard let finalTimetableListsDto = dto.result else { return }
        
        let subjectModels: [[SubjectModel]] = finalTimetableListsDto.map { dto in
            dto.timeTable.map { finalTimetableDto in
                SubjectModel(sbjDivcls: finalTimetableDto.codeSection, sbjNo: finalTimetableDto.code, sbjName: finalTimetableDto.lectName, time: finalTimetableDto.lectTime)
            }
        }
        
        appState.constraint.fetchFinalTimetableList(subjectModels)
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
    func setSelectedSubjects(_ value: [SubjectModelBase]) { }
    func getMajorComb() async throws { }
    func getFinalTimetableList(isRaw: Bool) async throws { }
    func saveTimetable(timetableIndex: Int, timetableName: String) async throws { }
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async throws { }
}
