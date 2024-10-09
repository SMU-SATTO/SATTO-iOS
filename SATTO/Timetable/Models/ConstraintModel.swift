//
//  ConstraintModel.swift
//  SATTO
//
//  Created by yeongjoon on 10/8/24.
//

import Foundation

struct ConstraintModel {
    var credit: Int
    var majorCount: Int
    var eLearnCount: Int
    var requiredLectures: [LectureModel]
    var invalidTimes: Set<String>
    
    init(credit: Int = 18,
         majorCount: Int = 3,
         eLearnCount: Int = 0,
         requiredLectures: [LectureModel] = [],
         invalidTimes: Set<String> = []) {
        self.credit = credit
        self.majorCount = majorCount
        self.eLearnCount = eLearnCount
        self.requiredLectures = requiredLectures
        self.invalidTimes = invalidTimes
    }
}
