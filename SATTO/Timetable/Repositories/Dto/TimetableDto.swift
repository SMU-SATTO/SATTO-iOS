//
//  Response.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation

struct MajorCombResponseDto: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: [MajorCombDto]?
}

struct MajorCombDto: Decodable {
    let combination: [CombinationDto]
}

struct CombinationDto: Decodable {
    let lectName, code: String
}

struct FinalTimetableListResponseDto: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: [FinalTimetableListDto]?
}

struct FinalTimetableListDto: Decodable {
    let timeTable: [FinalTimetableDto]
    let totalTime: String
}

struct FinalTimetableDto: Decodable {
    let code, codeSection, lectName, professor: String
    let lectTime: String
    let cmpDiv: String
    let credit: Int
}

struct TimetableListResponseDto: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: [TimetableListDto]
}

struct TimetableListDto: Decodable {
    let timeTableId: Int
    let semesterYear: String
    let timeTableName: String
    let isPublic: Bool
    let isRepresent: Bool
}

struct UserTimetableResponseDto: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: UserTimetableDto?
}

struct UserTimetableDto: Decodable {
    let timeTableId: Int?
    let lects: [LectDto]?
    let semesterYear, timeTableName: String?
    let isPublic, isRepresented: Bool?
}

struct LectDto: Decodable {
    let code, codeSection, lectName, professor: String?
    let lectTime, cmpDiv: String?
    let credit: Int?
}
