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
    let combination: [Combination]
}

struct Combination: Decodable {
    let lectName, code: String
}

//MARK: - TimetableAutoResponse
struct FinalTimetableListResponseDto: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [FinalTimetableListDto]
}

struct FinalTimetableListDto: Decodable {
    let timetable: [FinalTimetableDto]
    let totalTime: String
}

struct FinalTimetableDto: Decodable {
    let department: String
    let code, codeSection, lectName, professor: String
    let lectTime: String
    let cmpDiv: String
    let credit: Int
}

//MARK: - TimetableListResponse
struct TimetableListResponseDto: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: [TimetableListDto]
}

//MARK: - Dummy
extension TimetableListResponseDto {
    static var dummyData: TimetableListResponseDto {
        TimetableListResponseDto(
            code: "COMMON200",
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

struct LectDto: Decodable {
    let department, code, lectName, professor: String
    let lectTime, cmpDiv: String
    let subjectType: String
    let credit: Int
}

//MARK: - CurrentLectureListResponse
struct CurrentLectureResponseDto: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: CurrentLectureResponseDTOList?
}

struct CurrentLectureResponseDTOList: Decodable {
    let currentLectureResponseDTOList: [CurrentLectureDTO]
}

struct CurrentLectureDTO: Decodable {
    let department, code, codeSection, lectName: String?
    let professor: String?
    let lectTime: String?
    let cmpDiv: String?
    let subjectType: String?
    let credit: Int?
}
