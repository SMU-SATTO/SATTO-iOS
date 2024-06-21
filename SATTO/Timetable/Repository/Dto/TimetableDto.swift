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

