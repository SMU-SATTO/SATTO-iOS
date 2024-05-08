//
//  TimetableModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import Foundation
import JHTimeTable

// MARK: - TimetableModel
/// TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 목5 목6 ")
struct TimetableModel: Codable {
    let sbjDivcls, sbjNo, name, time: String
}

struct LectureModel: Identifiable {
    var id = UUID()
    var title: String
    var color: String
    var week: LectureWeeks
    var startAt: LectureTableTime
    var endAt: LectureTableTime
}

extension LectureModel {
    static let mainExample: [LectureModel] = [
        LectureModel(title: "컴퓨터네트워크", color: "FF0000",
                     week: .mon,
                     startAt: .init(hour: 4, minute: 0),
                     endAt: .init(hour: 5, minute: 0)),
        LectureModel(title: "컴퓨터네트워크", color: "FF0000",
                     week: .mon,
                     startAt: .init(hour: 5, minute: 0),
                     endAt: .init(hour: 6, minute: 0)),
        LectureModel(title: "컴퓨터네트워크", color: "FF0000",
                     week: .mon,
                     startAt: .init(hour: 6, minute: 0),
                     endAt: .init(hour: 7, minute: 0))
    ]
    static let emptyExample: [LectureModel] = [
        
    ]
    static let examples: [LectureModel] = [
        LectureModel(title: "Lecture1", color: "FF204E",
                     week: .mon,
                     startAt: .init(hour: 9, minute: 0),
                     endAt: .init(hour: 11, minute: 0)),
        LectureModel(title: "Lecture2", color: "007F73",
                     week: .tue,
                     startAt: .init(hour: 15, minute: 0),
                     endAt: .init(hour: 17, minute: 0)),
        LectureModel(title: "Lecture3", color: "E8751A",
                     week: .thu,
                     startAt: .init(hour: 11, minute: 0),
                     endAt: .init(hour: 13, minute: 0))
    ]
}
