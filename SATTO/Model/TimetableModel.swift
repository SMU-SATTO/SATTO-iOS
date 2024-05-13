//
//  TimetableModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI
import JHTimeTable

//MARK: - Datum
struct Datum: Codable {
    let timetable: [TimetableModel]
    let totalTime: String
    let isPublic, isRepresent: Bool
    let createdAt: String
}

// MARK: - Timetable
struct Timetable: Codable {
    let sbjDivcls, sbjNo, name, time: String
}


// MARK: - TimetableModel
/// TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 목5 목6 ")
struct TimetableModel: Codable {
    let sbjDivcls, sbjNo, name, time: String
}

struct LectureModel: Identifiable {
    var id = UUID()
    var title: String
    var color: Color
    var week: LectureWeeks
    var startAt: LectureTableTime
    var endAt: LectureTableTime
}

extension LectureModel {
    static let examples: [LectureModel] = [
        LectureModel(title: "Lecture1", color: .red,
                     week: .mon,
                     startAt: .init(hour: 9, minute: 0),
                     endAt: .init(hour: 11, minute: 0)),
        LectureModel(title: "Lecture2", color: .blue,
                     week: .tue,
                     startAt: .init(hour: 15, minute: 0),
                     endAt: .init(hour: 17, minute: 0)),
        LectureModel(title: "Lecture3", color: .gray,
                     week: .thu,
                     startAt: .init(hour: 11, minute: 0),
                     endAt: .init(hour: 13, minute: 0))
    ]
}
