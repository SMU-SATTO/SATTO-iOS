//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import Foundation

final class TimetableMainViewModel: ObservableObject {
    let repository = TimetableRepository()
    
    /// -1: 맵핑 실패         -2: fetch실패
    /// 0보다 작으면 대표시간표가 없는 것으로 간주
    @Published var timetableId: Int = -1 //MainView에 띄워지는 시간표의 id
    @Published var semesterYear: String = "2024학년도 2학기"
    @Published var timetableName: String = "시간표"
    @Published var timetableInfo: [SubjectModel] = []
    
    func fetchUserTimetable(id: Int?) {
        repository.getUserTimetable(id: id) { [weak self] result in
            switch result {
            case .success(let timetableInfoModel):
                DispatchQueue.main.async {
                    self?.timetableId = timetableInfoModel.timetableId ?? -1
                    self?.semesterYear = timetableInfoModel.semesterYear ?? "2024학년도 2학기"
                    self?.timetableName = timetableInfoModel.timeTableName ?? "시간표"
                    self?.timetableInfo = timetableInfoModel.subjectModels
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.timetableId = -2
                    self?.semesterYear = "2024학년도 2학기"
                    self?.timetableName = "시간표"
                    self?.timetableInfo = []
                }
                print("시간표 불러오기에 실패했어요. 대표시간표가 있는지 확인해주세요!")
            }
        }
    }
    
    func patchTimetablePrivate(timeTableId: Int, isPublic: Bool) {
        SATTONetworking.shared.patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("공개 여부 변경 성공!")
                }
            case .failure:
                print("공개 여부 변경에 실패했어요.")
            }
        }
    }
    
    func patchTimetableRepresent(timeTableId: Int, isRepresent: Bool) {
        SATTONetworking.shared.patchTimetableRepresent(timetableId: timetableId, isRepresent: isRepresent) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("대표시간표 변경 성공!")
                }
            case .failure:
                print("대표시간표 변경에 실패했어요.")
            }
        }
    }
    
    func patchTimetableName(timetableId: Int, timetableName: String) {
        SATTONetworking.shared.patchTimetableName(timetableId: timetableId, timetableName: timetableName) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("이름 바꾸기 성공!")
                }
            case .failure:
                print("시간표 이름 바꾸기에 실패했어요.")
            }
        }
    }
    
    func patchTimetableInfo(timetableId: Int, codeSectionList: [SubjectModelBase]) {
        let adjustedCodeSectionList = codeSectionList.map { $0.sbjDivcls }
        SATTONetworking.shared.patchTimetableInfo(timetableId: timetableId, codeSectionList: adjustedCodeSectionList) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("시간표 수정 성공!")
                }
            case .failure:
                print("시간표 수정에 실패했어요.")
            }
        }
    }
    
    func deleteTimetable(timetableID: Int) {
        SATTONetworking.shared.deleteTimetable(timetableId: timetableId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("시간표 삭제 성공!")
                    self.fetchUserTimetable(id: nil)
                }
            case .failure:
                print("시간표 삭제에 실패했어요")
            }
        }
    }
}
