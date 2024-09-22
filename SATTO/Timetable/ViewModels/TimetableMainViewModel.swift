//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import Foundation

final class TimetableMainViewModel: ObservableObject {
    private let timetableService = TimetableService(
        timetableRepository: TimetableRepository()
    )
    
    /// -1: 맵핑 실패         -2: fetch실패
    /// 0보다 작으면 대표시간표가 없는 것으로 간주
    @Published var timetableId: Int = -1 //MainView에 띄워지는 시간표의 id
    @Published var semesterYear: String = "2024학년도 2학기"
    @Published var timetableName: String = "시간표"
    @Published var timetableInfo: [SubjectModel] = []
    
    func fetchUserTimetable(id: Int?) async {
        do {
            let result = try await timetableService.fetchUserTimetable(id: id)
            
            await MainActor.run {
                self.timetableId = result.timetableId ?? -1
                self.semesterYear = result.semesterYear ?? "2024학년도 2학기"
                self.timetableName = result.timeTableName ?? "시간표"
                self.timetableInfo = result.subjectModels
            }
        } catch {
            await MainActor.run {
                self.timetableId = -2
                self.semesterYear = "2024학년도 2학기"
                self.timetableName = "시간표"
                self.timetableInfo = []
            }
            print("시간표 불러오기에 실패했습니다. 대표시간표가 있는지 확인해주세요!")
        }
    }
    
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async {
        do {
            try await timetableService
                .patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic)
        } catch {
            print("공개 여부 변경에 실패했어요.")
        }
    }
    
    func patchTimetableRepresent(timeTableId: Int, isRepresent: Bool) async {
        do {
            try await timetableService
                .patchTimetableRepresent(timetableId: timetableId, isRepresent: isRepresent)
        } catch {
            print("대표시간표 변경에 실패했어요.")
        }
    }
    
    func patchTimetableName(timetableId: Int, timetableName: String) async {
        do {
            try await timetableService
                .patchTimetableName(timetableId: timetableId, timetableName: timetableName)
        } catch {
            print("시간표 이름 바꾸기에 실패했어요.")
        }
    }
    
    func patchTimetableInfo(timetableId: Int, codeSectionList: [SubjectModelBase]) async {
        let adjustedCodeSectionList = codeSectionList.map { $0.sbjDivcls }
        do {
            try await timetableService
                .patchTimetableInfo(timetableId: timetableId, codeSectionList: adjustedCodeSectionList)
        } catch {
            print("시간표 수정에 실패했어요.")
        }
    }
    
    func deleteTimetable(timetableID: Int) async {
        do {
            let timetable = try await timetableService
                .deleteTimetable(timetableId: timetableId)
            await MainActor.run {
                self.timetableId = timetable.timetableId ?? -1
                self.semesterYear = timetable.semesterYear ?? "2024학년도 2학기"
                self.timetableName = timetable.timeTableName ?? "시간표"
                self.timetableInfo = timetable.subjectModels
            }
        } catch {
            print("시간표 삭제에 실패했어요")
        }
    }
}
