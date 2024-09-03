//
//  FriendModel.swift
//  SATTO
//
//  Created by 황인성 on 7/7/24.
//

import Foundation


struct FriendResponse: Codable {
    
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [Friend]
}

struct Friend: Codable, Equatable {
    
    var studentId: String
    var profileImg: String?
    var email: String
    var name: String
    var nickname: String
    var department: String
    var grade: String
    var isPublic: String
}

struct TimeTableResponse: Codable {
    
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [Timetable]
}

struct Timetable: Codable {
    
    var timeTableId: Int
    var semesterYear: String
    var timeTableName: String
    var isPublic: Bool
    var isRepresent: Bool
}


struct TimeTableInfoResponse: Codable {
    
    var isSuccess: Bool
    var code: String
    var message: String
    var result: TimeTableInfo
}

struct TimeTableInfo: Codable {
    
    let timeTableId: Int
    let lects: [Lecture]
    let semesterYear: String
    let timeTableName: String
    let isPublic: Bool
    let isRepresented: Bool
}

struct Lecture: Codable {
    
    var code: String
    var codeSection: String
    var lectName: String
    var professor: String
    var lectTime: String
    var cmpDiv: String
    var credit: Int
}

struct CompareTimetableResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [[Lecture]]
}
