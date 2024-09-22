//
//  TimetableListViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 6/22/24.
//

import Foundation

final class TimetableListViewModel: ObservableObject {
    ///의존성 주입은 추후에
    private let timetableService = TimetableService(
        timetableRepository: TimetableRepository()
    )
    
    @Published var timetables: [TimetableListModel] = []
    
    func fetchTimetableList() async {
        do {
            let timetables = try await timetableService.fetchTimetableList()
            
            // MainActor에서 Published 변수를 업데이트
            await MainActor.run {
                self.timetables = timetables
            }
        } catch {
            print("시간표 목록을 불러오는데 실패했어요.")
        }
    }
}
