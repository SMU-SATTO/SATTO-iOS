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
    func fetchUserTimetable(id: Int?) async throws -> TimetableModel
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws
    func patchTimetableName(timetableId: Int, timetableName: String) async throws
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws
    func deleteTimetable(timetableId: Int) async throws -> TimetableModel
    
    func fetchTimetableList() async throws -> [TimetableListModel]
}

struct TimetableService: TimetableServiceProtocol {
    let timetableRepository: TimetableRepositoryProtocol
    
    func fetchUserTimetable(id: Int?) async throws -> TimetableModel {
        let userTimetableDto = try await timetableRepository.getUserTimetable(id: id)
        
        guard let lects = userTimetableDto.result?.lects else {
            return TimetableModel(
                id: -1,
                semester: "",
                name: "",
                lectures: [],
                isPublic: false,
                isRepresented: false)
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
        
        return TimetableModel(
            id: userTimetableDto.result?.timeTableId ?? 0,
            semester: userTimetableDto.result?.semesterYear ?? "2024학년도 2학기",
            name: userTimetableDto.result?.timeTableName ?? "시간표",
            lectures: subjectModels,
            isPublic: userTimetableDto.result?.isPublic ?? false,
            isRepresented: userTimetableDto.result?.isRepresented ?? false
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
    
    func deleteTimetable(timetableId: Int) async throws -> TimetableModel {
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

struct FakeTimetableService: TimetableServiceProtocol {
    func fetchUserTimetable(id: Int?) async throws -> TimetableModel {
        return TimetableModel(
            id: id ?? 1,
            semester: "2024학년도 2학기",
            name: "가짜 시간표",
            lectures: [
                SubjectModel(sbjDivcls: "001", sbjNo: "CS101", sbjName: "컴퓨터공학개론", time: "월요일 9:00 - 10:30"),
                SubjectModel(sbjDivcls: "002", sbjNo: "CS102", sbjName: "자료구조", time: "화요일 11:00 - 12:30")
            ],
            isPublic: true,
            isRepresented: false
        ) }
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws { }
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws { }
    func patchTimetableName(timetableId: Int, timetableName: String) async throws { }
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws { }
    func deleteTimetable(timetableId: Int) async throws -> TimetableModel {
        return TimetableModel(
            id: 1,
            semester: "2024학년도 2학기",
            name: "기본 시간표",
            lectures: [],
            isPublic: true,
            isRepresented: false
        ) }
    func fetchTimetableList() async throws -> [TimetableListModel] {
        return [
            TimetableListModel(id: 1, timetableName: "시간표 1", semesterYear: "2024학년도 2학기", isPublic: true, isRepresent: true),
            TimetableListModel(id: 2, timetableName: "시간표 2", semesterYear: "2024학년도 2학기", isPublic: false, isRepresent: false)
        ]
    }
}
