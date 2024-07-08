//
//  FriendModel.swift
//  SATTO
//
//  Created by 황인성 on 7/7/24.
//

import Foundation


struct Friend: Codable {
    
    var studentId: String
    var email: String
//    var password: String
    var name: String
    var nickname: String
    var department: String
    var grade: String
    var isPublic: String

}

struct Timetable: Codable {
    
    var timeTableId: Int
    var semesterYear: String
    var timeTableName: String
    var isPublic: Bool
    var isRepresent: Bool
    
}

// MARK: - Result
struct DetailTimetable: Codable {
    let timeTableId: Int
    let lects: [Lecture]
    let semesterYear, timeTableName: String
    let isPublic, isRepresented: Bool
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
