//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

/// 비즈니스 로직이 아닌 데이터 소스와의 상호작용을 담당. 네트워크에서 받은 DTO 반환
protocol TimetableRepositoryProtocol {
    func getUserTimetable(id: Int?) async throws -> UserTimetableResponseDto
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws
    func patchTimetableName(timetableId: Int, timetableName: String) async throws
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws
    func deleteTimetable(timetableId: Int) async throws
    func getTimetableList() async throws -> TimetableListResponseDto
}

class TimetableRepository: TimetableRepositoryProtocol {
    private let provider = MoyaProvider<TimetableRouter>()
    
    func getUserTimetable(id: Int?) async throws -> UserTimetableResponseDto {
        return try await provider
            .request(.getUserTimetable(id: id))
            .filterSuccessfulStatusCodes()
            .map(UserTimetableResponseDto.self)
    }
    
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws {
        let _ = try await provider
            .request(.patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws {
        let _ = try await provider
            .request(.patchTimetableRepresent(timetableId: timetableId, isRepresent: isRepresent))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableName(timetableId: Int, timetableName: String) async throws {
        let _ = try await provider
            .request(.patchTimetableName(timetableId: timetableId, timetableName: timetableName))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws {
        let _ = try await provider
            .request(.patchTimetableInfo(timetableId: timetableId, codeSectionList: codeSectionList))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func deleteTimetable(timetableId: Int) async throws {
        let _ = try await provider
            .request(.deleteTimetable(timetableId: timetableId))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func getTimetableList() async throws -> TimetableListResponseDto {
        return try await provider
            .request(.getTimetableList)
            .filterSuccessfulStatusCodes()
            .map(TimetableListResponseDto.self)
    }
}

private struct Empty: Decodable {}
