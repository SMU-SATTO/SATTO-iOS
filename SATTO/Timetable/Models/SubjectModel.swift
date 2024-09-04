//
//  SubjectModel.swift
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

protocol SubjectModelBase: Codable {
    var sbjDivcls: String { get }
    var sbjNo: String { get }
    var sbjName: String { get }
    var time: String { get }
}

// MARK: - SubjectModel
/// SubjectModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 목5 목6 ")
struct SubjectModel: SubjectModelBase {
    let sbjDivcls, sbjNo, sbjName, time: String
}

//MARK: - SubjectDetailModel
///  SubjectDetailModel(major: "전공", "sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "과목명", prof: "교수명", "time: "목4 목5 목6 ", enrollmentCapacity: 200, enrolledStudents: 230)
struct SubjectDetailModel: SubjectModelBase {
    let major: String
    let sbjDivcls, sbjNo, sbjName, prof, time: String
    let credit, enrollmentCapacity, enrolledStudents: Int
    let yesterdayEnrolledData, threeDaysAgoEnrolledData: Int
    
    
    init(major: String = "Unknown", sbjDivcls: String = "Unknown", sbjNo: String = "Unknown", sbjName: String = "Unknown", prof: String = "Unknown", time: String = "Unknown", credit: Int = 0, enrollmentCapacity: Int = 0, enrolledStudents: Int = 0, yesterdayEnrolledData: Int = 0, threeDaysAgoEnrolledData: Int = 0) {
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

//MARK: - TimetableMain에서 사용하는 구조체
struct TimetableMainInfoModel {
    let timetableId: Int?
    let subjectModels: [SubjectModel]
    let semesterYear: String?
    let timeTableName: String?
}

//MARK: - TimetableListModel
struct TimetableListModel {
    let id: Int
    let timetableName: String
    let semesterYear: String
    let isPublic: Bool
    let isRepresent: Bool
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
