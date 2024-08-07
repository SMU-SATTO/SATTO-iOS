//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import Foundation

final class TimetableMainViewModel: ObservableObject {
    let repository = TimetableRepository()
    
    @Published var timetableId: Int = 0 //MainView에 띄워지는 시간표의 id
    @Published var semesterYear: String = "2024년 2학기"
    @Published var timetalbeName: String = "시간표"
    @Published var timetableInfo: [SubjectModelBase] = []
    
    func fetchUserTimetable(id: Int?) {
        repository.getUserTimetable(id: id) { [weak self] result in
            switch result {
            case .success(let timetableInfoModel):
                DispatchQueue.main.async {
                    self?.semesterYear = timetableInfoModel.semesterYear ?? "2024년 2학기"
                    self?.timetalbeName = timetableInfoModel.timeTableName ?? "시간표"
                    self?.timetableInfo = timetableInfoModel.subjectModels
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.semesterYear = "2024년 2학기"
                    self?.timetalbeName = "시간표"
                    self?.timetableInfo = []
                }
                print("Error fetching UserTimetable!: \(error)")
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
            case .failure(let error):
                print("Error patching timetablePrivate: \(error)")
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
            case .failure(let error):
                print("Error patching timetablePrivate: \(error)")
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
            case .failure(let error):
                print("Error patching timetableName: \(error)")
            }
        }
    }
    
    func deleteTimetable(timetableID: Int) {
        SATTONetworking.shared.deleteTimetable(timetableId: timetableId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    
                }
            case .failure(let error):
                print("Error patching deleteTimetable: \(error)")
            }
        }
    }
}
