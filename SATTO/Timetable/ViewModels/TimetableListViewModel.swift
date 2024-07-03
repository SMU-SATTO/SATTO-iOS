//
//  TimetableListViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 6/22/24.
//

import Foundation

final class TimetableListViewModel: ObservableObject {
    @Published var timetables: [TimetableListModel] = []
    
    func fetchTimetableList() {
        SATTONetworking.shared.getTimetableList() { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    var timetableList: [TimetableListModel] = []
                    
                    for timetable in response.result {
                        let timetableItem = TimetableListModel(id: timetable.timeTableId,
                                                          timetableName: timetable.timeTableName,
                                                          semesterYear: timetable.semesterYear,
                                                          isPublic: timetable.isPublic,
                                                          isRepresent: timetable.isRepresent)
                        timetableList.append(timetableItem)
                    }
                    self?.timetables = timetableList
                    print("시간표 불러오기 성공!")
                }
            case .failure(let error):
                print("Error fetching timetable list: \(error)")
            }
        }
    }
}
