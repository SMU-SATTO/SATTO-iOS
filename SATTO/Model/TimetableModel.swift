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

protocol TimetableBase: Codable {
    var sbjDivcls: String { get }
    var sbjNo: String { get }
    var sbjName: String { get }
    var time: String { get }
}

// MARK: - TimetableModel
/// TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 목5 목6 ")
struct TimetableModel: TimetableBase {
    let sbjDivcls, sbjNo, sbjName, time: String
}

//MARK: - TimetableDetailModel
///  TimetableDetailModel(major: "전공", "sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "과목명", prof: "교수명", "time: "목4 목5 목6 ", enrollmentCapacity: 200, enrolledStudents: 230)
struct TimetableDetailModel: TimetableBase {
    let major: String
    let sbjDivcls, sbjNo, sbjName, prof, time: String
    let credit, enrollmentCapacity, enrolledStudents: Int
    let yesterdayEnrolledData, threeDaysAgoEnrolledData: Int
    
    
    init(major: String, sbjDivcls: String, sbjNo: String, sbjName: String, prof: String, time: String, credit: Int, enrollmentCapacity: Int, enrolledStudents: Int, yesterdayEnrolledData: Int, threeDaysAgoEnrolledData: Int) {
        self.major = major
        self.sbjDivcls = sbjDivcls
        self.sbjNo = sbjNo
        self.sbjName = sbjName
        self.prof = prof
        self.time = time
        self.credit = credit
        self.enrollmentCapacity = enrollmentCapacity
        self.enrolledStudents = enrolledStudents
        self.yesterdayEnrolledData = yesterdayEnrolledData
        self.threeDaysAgoEnrolledData = threeDaysAgoEnrolledData
    }
}

struct TimetableDetailList: Codable {
    let timetable: [TimetableDetailModel]
    
    init(timetable: [TimetableDetailModel]) {
        self.timetable = timetable
    }
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
