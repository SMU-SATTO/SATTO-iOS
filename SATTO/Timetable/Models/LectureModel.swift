//
//  LectureModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI
import JHTimeTable

struct MajorComb: Equatable, Identifiable {
    let id = UUID()
    let combination: [Combination]
    
    static func == (lhs: MajorComb, rhs: MajorComb) -> Bool {
        return lhs.combination == rhs.combination
    }
}

struct Combination: Equatable {
    let lectName, code: String
    
    static func == (lhs: Combination, rhs: Combination) -> Bool {
        return lhs.lectName == rhs.lectName && lhs.code == rhs.code
    }
}

//MARK: - LectureModel
///  LectureModel(major: "전공", "sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "과목명", prof: "교수명", "time: "목4 목5 목6 ")
struct LectureModel: Codable {
    let sbjDivcls, sbjNo, sbjName, time: String
    let prof: String
    let major: String
    let credit: Int
    
    
    init(sbjDivcls: String = "Unknown", sbjNo: String = "Unknown", sbjName: String = "Unknown", time: String = "Unknown", prof: String = "Unknown", major: String = "Unknown", credit: Int = 0) {
        self.sbjDivcls = sbjDivcls
        self.sbjNo = sbjNo
        self.sbjName = sbjName
        self.time = time
        self.prof = prof
        self.major = major
        self.credit = credit
    }
}

////MARK: - TimetableMain에서 사용하는 구조체
//struct TimetableMainInfoModel {
//    let timetableId: Int?
//    let subjectModels: [LectureModel]
//    let semesterYear: String?
//    let timeTableName: String?
//}

//MARK: - TimetableListModel
struct TimetableListModel {
    let id: Int
    let timetableName: String
    let semesterYear: String
    let isPublic: Bool
    let isRepresent: Bool
}

struct OldLectureModel: Identifiable {
    var id = UUID()
    var title: String
    var color: Color
    var week: LectureWeeks
    var startAt: LectureTableTime
    var endAt: LectureTableTime
}

extension OldLectureModel {
    static let examples: [OldLectureModel] = [
        OldLectureModel(title: "Lecture1", color: .red,
                     week: .mon,
                     startAt: .init(hour: 9, minute: 0),
                     endAt: .init(hour: 11, minute: 0)),
        OldLectureModel(title: "Lecture2", color: .blue,
                     week: .tue,
                     startAt: .init(hour: 15, minute: 0),
                     endAt: .init(hour: 17, minute: 0)),
        OldLectureModel(title: "Lecture3", color: .gray,
                     week: .thu,
                     startAt: .init(hour: 11, minute: 0),
                     endAt: .init(hour: 13, minute: 0))
    ]
}
