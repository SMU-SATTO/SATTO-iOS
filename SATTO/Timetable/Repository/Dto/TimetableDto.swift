//
//  Response.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation

struct MajorCombResponseDto: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [MajorCombDto]
}

struct MajorCombDto: Decodable {
    let combination: [String]
}

struct FinalTimetableListResponseDto: Decodable {
    let code: Int
    let result: String
    let message: String
    let data: [FinalTimetableListDto]
}

struct FinalTimetableListDto: Decodable {
    let timetable: [FinalTimetableDto]
}

struct FinalTimetableDto: Decodable {
    let sbjNo, sbjDivcls: String
    let sbjName: String
    let time: String
    let category: String
}

struct TimetableListResponseDto: Decodable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: [TimetableListDto]
}

//MARK: - Dummy
extension TimetableListResponseDto {
    static var dummyData: TimetableListResponseDto {
        TimetableListResponseDto(
            code: 200,
            isSuccess: true,
            message: "Success",
            result: [
                TimetableListDto(id: 1, semesterYear: "2024년 1학기", timetableName: "시간표 1"),
                TimetableListDto(id: 1, semesterYear: "2024년 1학기", timetableName: "시간표 7"),
                TimetableListDto(id: 2, semesterYear: "2023년 2학기", timetableName: "시간표 2"),
                TimetableListDto(id: 3, semesterYear: "2023년 1학기", timetableName: "시간표 3")
            ]
        )
    }
}

struct TimetableListDto: Decodable {
    let id: Int
    let semesterYear: String
    let timetableName: String
}

struct UserTimetableResponseDto: Decodable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: UserTimetableDto
}

struct UserTimetableDto: Decodable {
    let lects: [LectDto]
    let semesterYear, timeTableName: String
    let isPublic, isRepresented: Bool
}

struct LectDto: Codable {
    let department, code, lectName, professor: String
    let lectTime, cmpDiv: String
    let subjectType: String
    let credit: Int
}
