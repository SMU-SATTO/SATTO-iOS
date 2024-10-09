//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/29/24.
//

import Foundation

struct CurrentLectureListRequest: Codable {
    let searchText: String
    let grade: [Int]
    let elective: Int
    let normal: Int
    let essential: Int
    let humanity, society, nature, engineering, art: Int
    let isCyber: Int
    let timeZone: String
}

struct CurrentLectureResponseDto: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: CurrentLectureResponseDTOList?
}

struct CurrentLectureResponseDTOList: Decodable {
    let currentLectureResponseDTOList: [CurrentLectureDTO]
    let listSize, totalPage: Int?
    let totalElements: String?
    let isFirst, isLast: Bool?
}

struct CurrentLectureDTO: Decodable {
    let department, code, codeSection, lectName: String?
    let professor: String?
    let lectTime: String?
    let cmpDiv: String?
    let subjectType: String?
    let credit: Int?
}
