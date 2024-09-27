//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation
import Moya

protocol ConstraintRepositoryProtocol {
    func getMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws -> MajorCombResponseDto
    func getFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]]) async throws -> FinalTimetableListResponseDto
    func saveTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws
}

class ConstraintRepository: ConstraintRepositoryProtocol {
    private let provider = MoyaProvider<TimetableRouter>()
    
    func getMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws -> MajorCombResponseDto {
        return try await provider
            .request(.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone))
            .filterSuccessfulStatusCodes()
            .map(MajorCombResponseDto.self)
    }
    
    func getFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]]) async throws -> FinalTimetableListResponseDto {
        return try await provider
            .request(.postFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList))
            .filterSuccessfulStatusCodes()
            .map(FinalTimetableListResponseDto.self)
    }
    
    func saveTimetable(codeSectionList: [String], semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws {
        let _ = try await provider
            .request(.postTimetableSelect(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
}

private struct Empty: Decodable {}
