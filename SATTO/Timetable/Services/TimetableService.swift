//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/12/24.
//

import Foundation

///비즈니스 로직 처리. repository에서 DTO를 받아 사용할 수 있는 도메인 모델로 변환과 같은 작업을 한다.
@MainActor
protocol TimetableServiceProtocol: Sendable {
    func fetchUserTimetable(id: Int?) async throws -> TimetableMainInfoModel
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws
    func patchTimetableName(timetableId: Int, timetableName: String) async throws
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws
    func deleteTimetable(timetableId: Int) async throws -> TimetableMainInfoModel
    
    func fetchTimetableList() async throws -> [TimetableListModel]
}

struct TimetableService: TimetableServiceProtocol {
    let timetableRepository: TimetableRepositoryProtocol
    
    func fetchUserTimetable(id: Int?) async throws -> TimetableMainInfoModel {
        let userTimetableDto = try await timetableRepository.getUserTimetable(id: id)
        
        guard let lects = userTimetableDto.result?.lects else {
            return TimetableMainInfoModel(
                timetableId: nil,
                subjectModels: [],
                semesterYear: nil,
                timeTableName: nil
            )
        }
        
        let subjectModels = lects.compactMap { lect -> SubjectModel? in
            guard let sbjDivcls = lect.codeSection,
                  let sbjNo = lect.code,
                  let sbjName = lect.lectName,
                  let time = lect.lectTime else {
                return nil
            }
            return SubjectModel(sbjDivcls: sbjDivcls, sbjNo: sbjNo, sbjName: sbjName, time: time)
        }
        
        return TimetableMainInfoModel(
            timetableId: userTimetableDto.result?.timeTableId,
            subjectModels: subjectModels,
            semesterYear: userTimetableDto.result?.semesterYear,
            timeTableName: userTimetableDto.result?.timeTableName
        )
    }
    
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws {
        try await timetableRepository.patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic)
    }
    
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws {
        try await timetableRepository.patchTimetableRepresent(timetableId: timetableId, isRepresent: isRepresent)
    }
    
    func patchTimetableName(timetableId: Int, timetableName: String) async throws {
        try await timetableRepository.patchTimetableName(timetableId: timetableId, timetableName: timetableName)
    }
    
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws {
        try await timetableRepository.patchTimetableInfo(timetableId: timetableId, codeSectionList: codeSectionList)
    }
    
    func deleteTimetable(timetableId: Int) async throws -> TimetableMainInfoModel {
        try await timetableRepository.deleteTimetable(timetableId: timetableId)
        let timetable = try await fetchUserTimetable(id: nil)
        return timetable
    }
    
    func fetchTimetableList() async throws -> [TimetableListModel] {
        // Repository에서 DTO를 받아옴
        let dto = try await timetableRepository.getTimetableList()
        
        // DTO를 Domain Model로 변환
        let timetableLists: [TimetableListModel] = dto.result.map { timetableDto in
            return TimetableListModel(
                id: timetableDto.timeTableId,
                timetableName: timetableDto.timeTableName,
                semesterYear: timetableDto.semesterYear,
                isPublic: timetableDto.isPublic,
                isRepresent: timetableDto.isRepresent
            )
        }
        
        return timetableLists
    }
}
