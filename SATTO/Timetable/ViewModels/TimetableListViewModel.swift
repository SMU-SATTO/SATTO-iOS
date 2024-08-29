//
//  TimetableListViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 6/22/24.
//

import Foundation

final class TimetableListViewModel: ObservableObject {
    let repository = TimetableRepository()
    
    @Published var timetables: [TimetableListModel] = []
    
    func fetchTimetableList() {
        repository.getTimetableList() { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.timetables = response
                }
            case .failure:
                print("시간표 목록을 불러오는데 실패했어요.")
            }
        }
    }
}
