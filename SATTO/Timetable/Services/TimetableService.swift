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
    func fetchCurrentTimetable(id: Int?) async throws
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws
    func patchTimetableName(timetableId: Int, timetableName: String) async throws
    func patchTimetableInfo() async throws
    func deleteTimetable(timetableId: Int) async throws
    func fetchTimetableList() async throws
}

struct TimetableService: TimetableServiceProtocol {
    var appState: AppState
    var webRepositories: AppEnvironment.WebRepositories

    var timetableRepository: TimetableRepositoryProtocol {
        webRepositories.timetableRepository
    }
    
    func fetchCurrentTimetable(id: Int?) async throws {
        do {
            let userTimetableDto = try await timetableRepository.getUserTimetable(id: id)
            
            guard let lects = userTimetableDto.result?.lects else {
                appState.timetable.fetchCurrentTimetable(
                    TimetableModel(id: -1, semester: "", name: "", lectures: [], isPublic: false, isRepresented: false)
                )
                return
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
            
            let timetableModel = TimetableModel(
                id: userTimetableDto.result?.timeTableId ?? 0,
                semester: userTimetableDto.result?.semesterYear ?? "2024학년도 2학기",
                name: userTimetableDto.result?.timeTableName ?? "시간표",
                lectures: subjectModels,
                isPublic: userTimetableDto.result?.isPublic ?? false,
                isRepresented: userTimetableDto.result?.isRepresented ?? false
            )
            
            appState.timetable.fetchCurrentTimetable(timetableModel)
        } catch {
            appState.timetable.resetTimetableState()
        }
    }
    
    func fetchTimetableList() async throws {
        let dto = try await timetableRepository.getTimetableList()
        
        let timetableLists: [TimetableListModel] = dto.result.map { timetableDto in
            return TimetableListModel(
                id: timetableDto.timeTableId,
                timetableName: timetableDto.timeTableName,
                semesterYear: timetableDto.semesterYear,
                isPublic: timetableDto.isPublic,
                isRepresent: timetableDto.isRepresent
            )
        }
        appState.timetable.fetchTimetableList(timetableLists)
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
    
    func patchTimetableInfo() async throws {
        guard let timetableId = appState.timetable.currentTimetable?.id else { return }
        let adjustedCodeSectionList = appState.constraint.selectedSubjects.map { $0.sbjDivcls }
        try await timetableRepository.patchTimetableInfo(timetableId: timetableId, codeSectionList: adjustedCodeSectionList)
    }
    
    func deleteTimetable(timetableId: Int) async throws {
        try await timetableRepository.deleteTimetable(timetableId: timetableId)
        try await fetchCurrentTimetable(id: nil)
    }
}

struct FakeTimetableService: TimetableServiceProtocol {
    func postMajorComb(GPA: Int, requiredLect: [any SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) async throws { }
    func fetchCurrentTimetable(id: Int?) async throws { }
    func deleteTimetable(timetableId: Int) async throws { }
    func fetchUserTimetable(id: Int?) async throws { }
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws { }
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws { }
    func patchTimetableName(timetableId: Int, timetableName: String) async throws { }
    func patchTimetableInfo() async throws { }
    func fetchTimetableList() async throws { }
    func fetchFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [MajorComb]) async throws { }
    func createTimetable(timetableIndex: Int, semesterYear: String, timeTableName: String, isPublic: Bool, isRepresented: Bool) async throws { }
}
