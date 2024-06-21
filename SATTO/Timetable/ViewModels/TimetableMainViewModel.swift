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
    //TODO: Dummy
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
                print("SATTO ERROR!: \(error)")
            }
        }
    }
}
