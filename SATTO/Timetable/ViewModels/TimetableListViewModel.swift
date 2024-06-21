//
//  TimetableListViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 6/22/24.
//

import Foundation

final class TimetableListViewModel: ObservableObject {
    @Published var timetables: [String: [(id: Int, name: String)]] = [:]
    
    func fetchTimetableList() {
        SATTONetworking.shared.getTimetableList() { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    var groupedTimetables: [String: [(id: Int, name: String)]] = [:]
                    
                    for timetable in response.result {
                        groupedTimetables[timetable.semesterYear, default: []].append((id: timetable.id, name: timetable.timetableName))
                    }
                    self?.timetables = groupedTimetables
                }
            case .failure(let error):
                print("Error fetching timetable list: \(error)")
            }
        }
    }
    
    //MARK: - Dummy
    func fetchTimetableListDummy() {
        let dummyData = TimetableListResponseDto.dummyData
        
        var groupedTimetables: [String: [(id: Int, name: String)]] = [:]
        for timetable in dummyData.result {
            groupedTimetables[timetable.semesterYear, default: []].append((id: timetable.id, name: timetable.timetableName))
        }
        
        self.timetables = groupedTimetables
    }
}
