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
    @Published var timetableInfo: [SubjectModelBase] = [
        SubjectModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "컴퓨터네트워크", time: "목4 금5 금6"),
        SubjectModel(sbjDivcls: "HAEA0008-2", sbjNo: "HAEA0008", sbjName: "운영체제", time: "월1 월2 월3"),
        SubjectModel(sbjDivcls: "HAEA0008-3", sbjNo: "HAEA0008", sbjName: "소프트웨어공학", time: "월4 목3 금4"),
        SubjectModel(sbjDivcls: "ABC-03", sbjNo: "ABC", sbjName: "과목명", time: "화2 화3 화4")
    ]
    
    func fetchUserTimetable(id: Int) {
        repository.getUserTimetable(id: id) { [weak self] result in
            switch result {
            case .success(let userTimetable):
                DispatchQueue.main.async {
                    self?.timetableInfo = userTimetable
                }
            case .failure(let error):
                print("Error fetching UserTimetable!: \(error)")
            }
        }
    }
    
    func patchTimetablePrivate(timeTableId: Int, state: Bool) {
        SATTONetworking.shared.patchTimetablePrivate(timetableId: timetableId, state: state) { result in
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
