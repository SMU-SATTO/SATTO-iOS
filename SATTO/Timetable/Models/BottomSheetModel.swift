//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/3/24.
//

import Foundation

//MARK: - 바텀시트 필터링 모델
struct BottomSheetModel: Codable {
    var grade: [Int]
    var GEOption: [String]
    var BGEOption: String
    var eLearn: Int
    var time: String
}

//MARK: - 바텀시트 수강인원 그래프 모델
struct ValuePerLectureCategory {
    var category: String
    var value: Int
    var date: String
}
