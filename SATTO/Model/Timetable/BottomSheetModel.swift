//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/3/24.
//

import Foundation

//MARK: - 바텀시트 필터링 모델
struct BottomSheetModel: Codable {
    let grade: Int
    let GEOption: String
    let eLearn: Int
    let time: String
}

//MARK: - 바텀시트 수강인원 그래프 모델
struct ValuePerSubjectCategory {
    var category: String
    var value: Int
    var date: String
}
