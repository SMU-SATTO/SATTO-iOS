//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
protocol ConstraintServiceProtocol: Sendable {
    func getMajorComb(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws
    func getFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb]) async throws
    func saveTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws
    func saveCustomTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws
}

struct ConstraintService: ConstraintServiceProtocol {
    var appState: AppState
    var webRepositories: AppEnvironment.WebRepositories
    
    var constraintRepository: ConstraintRepositoryProtocol {
        webRepositories.constraintRepository
    }

    func getMajorComb(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws {
        let requiredLectStrings = requiredLect.map { $0.sbjDivcls }
        let adjustedRequiredLect = requiredLectStrings.isEmpty ? [""] : requiredLectStrings
        
        let dto = try await constraintRepository.getMajorComb(GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone)
        
        guard let majorCombDtos = dto.result else { return }
        
        let majorComb = majorCombDtos.map { dto in
            MajorComb(combination: dto.combination.map { combinationDto in
                Combination(lectName: combinationDto.lectName, code: combinationDto.code)
            })
        }
        appState.constraint.fetchMajorCombs(majorComb)
    }
    
    func getFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb]) async throws {
        let adjustedRequiredLect = requiredLect.isEmpty ? [""] : requiredLect.map { $0.sbjDivcls }
        let adjustedMajorList = impossibleTimeZone.isEmpty ? [[""]] : majorList.map { $0.combination.map { $0.code } }
        
        let dto = try await constraintRepository.getFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: adjustedRequiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: adjustedMajorList)
        
        guard let finalTimetableListsDto = dto.result else { return }
        
        let subjectModels: [[SubjectModel]] = finalTimetableListsDto.map { dto in
            dto.timeTable.map { finalTimetableDto in
                SubjectModel(sbjDivcls: finalTimetableDto.codeSection, sbjNo: finalTimetableDto.code, sbjName: finalTimetableDto.lectName, time: finalTimetableDto.lectTime)
            }
        }
        
        appState.constraint.fetchFinalTimetableList(subjectModels)
    }
    
    func saveTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws {
        guard let timetableList = appState.constraint.finalTimetableList else { return }
        let codeSectionList = timetableList[timetableIndex].map { $0.sbjDivcls }
        
        try await constraintRepository.saveTimetable(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)
    }
    func saveCustomTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws {
        try await constraintRepository.saveTimetable(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)
    }
}

struct FakeConstraintService: ConstraintServiceProtocol {
    func getMajorComb(GPA: Int, requiredLect: [any SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws { }
    func getFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [any SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb]) async throws { }
    func saveTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws { }
    func saveCustomTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws { }
}
