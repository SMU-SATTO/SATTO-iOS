//
//  TimetableState.swift
//  SATTO
//
//  Created by yeongjoon on 9/23/24.
//

import SwiftUI

@MainActor
class TimetableState: ObservableObject {
    @Published var currentTimetable: TimetableModel?
    @Published var timetableList: [TimetableListModel]?
    
    func updateCurrentTimetable(_ timetable: TimetableModel) {
        self.currentTimetable = timetable
    }
    
    func resetTimetableState() {
        self.currentTimetable = TimetableModel(id: -1, semester: "", name: "", lectures: [], isPublic: false, isRepresented: false)
    }
    
    func updateTimetableList(_ timetableList: [TimetableListModel]) {
        self.timetableList = timetableList
    }
}
