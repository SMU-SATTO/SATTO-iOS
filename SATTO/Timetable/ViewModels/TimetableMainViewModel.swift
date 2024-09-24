//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import Combine
import Foundation

class TimetableMainViewModel: BaseViewModel, ObservableObject {
    @Published var currentTimetable: TimetableModel?
    @Published var timetableList: [TimetableListModel]?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(container: DIContainer) {
        super.init(container: container)
        
        appState.timetable.$currentTimetable
            .assign(to: \.currentTimetable, on: self)
            .store(in: &cancellables)
        
        appState.timetable.$timetableList
                .assign(to: \.timetableList, on: self)
                .store(in: &cancellables)
    }

    private var timetableService: TimetableServiceProtocol {
        services.timetableService
    }
    
    private var timetableState: TimetableState {
        appState.timetable
    }
    
    func fetchUserTimetable(id: Int?) async {
        do {
            let timetableModel = try await timetableService.fetchUserTimetable(id: id)
            timetableState.updateCurrentTimetable(timetableModel)
        } catch {
            timetableState.resetTimetableState()
            print("시간표 불러오기에 실패했습니다.")
        }
    }
    
    func fetchTimetableList() async {
        do {
            let timetableList = try await timetableService.fetchTimetableList()
            timetableState.updateTimetableList(timetableList)
        } catch {
            print("시간표 목록을 불러오는데 실패했어요.")
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
    
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async {
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
    
    func deleteTimetable(timetableId: Int) async {
        do {
            let timetable = try await timetableService.deleteTimetable(timetableId: timetableId)
            timetableState.updateCurrentTimetable(timetable)
        } catch {
            print("시간표 삭제에 실패했어요.")
        }
    }
}
