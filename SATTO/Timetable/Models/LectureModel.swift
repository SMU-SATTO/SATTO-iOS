//
//  LectureModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI

struct MajorComb: Equatable, Identifiable {
    let id = UUID()
    let combination: [Combination]
    
    static func == (lhs: MajorComb, rhs: MajorComb) -> Bool {
        return lhs.combination == rhs.combination
    }
}

struct Combination: Equatable {
    let lectName, code: String
    
    static func == (lhs: Combination, rhs: Combination) -> Bool {
        return lhs.lectName == rhs.lectName && lhs.code == rhs.code
    }
}

//MARK: - LectureModel
///  LectureModel(major: "전공", "sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "과목명", prof: "교수명", "time: "목4 목5 목6 ")
struct LectureModel: Codable {
    let sbjDivcls, sbjNo, sbjName, time: String
    let prof: String
    let major: String
    let credit: Int
    
    
    init(sbjDivcls: String = "Unknown", sbjNo: String = "Unknown", sbjName: String = "Unknown", time: String = "Unknown", prof: String = "Unknown", major: String = "Unknown", credit: Int = 0) {
        self.sbjDivcls = sbjDivcls
        self.sbjNo = sbjNo
        self.sbjName = sbjName
        self.time = time
        self.prof = prof
        self.major = major
        self.credit = credit
    }
}
