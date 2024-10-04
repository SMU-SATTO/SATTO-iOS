//
//  LectureModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI

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

struct LectureFilterModel: Codable  {
    var searchText: String
    var category: LectureCategoryModel
    
    init(searchText: String = "", category: LectureCategoryModel = LectureCategoryModel()) {
        self.searchText = searchText
        self.category = category
    }
}

struct LectureCategoryModel: Codable {
    var grade: [String]
    var elective: ElectiveModel
    var eLearn: String /// 0: 전체, 1: E러닝만 보기, 2: E러닝 빼고 보기
    var time: Set<String>
    
    func isCategorySelected() -> Bool {
        return grade != [] ||
               eLearn != "전체" ||
               time != [] ||
               elective.isAnyElectiveSelected()
    }
    
    func isGradeSelected() -> Bool {
        return grade != []
    }
    
    func isElectiveSelected() -> Bool {
        return elective.isAnyElectiveSelected()
    }
    
    func isELearnSelected() -> Bool {
        return eLearn != "전체"
    }
    
    func isTimeSelected() -> Bool {
        return time != []
    }
    
    init(grade: [String] = [], elective: ElectiveModel = ElectiveModel(), eLearn: String = "", time: Set<String> = []) {
        self.grade = grade
        self.elective = elective
        self.eLearn = eLearn
        self.time = time
    }
}

struct ElectiveModel: Codable {
    var normal: Bool
    var balance: BalanceElectiveModel
    var essential: Bool
    
    func isAnyElectiveSelected() -> Bool {
        return normal || essential || balance.isBalanceElectiveSelected()
    }
    
    func isNormalSelected() -> Bool {
        return normal
    }
    
    func isBalanceSelected() -> Bool {
        return balance.isBalanceElectiveSelected()
    }
    
    func isEssentialSelected() -> Bool {
        return essential
    }
    
    init(normal: Bool = false, balance: BalanceElectiveModel = BalanceElectiveModel(), essential: Bool = false) {
        self.normal = normal
        self.balance = balance
        self.essential = essential
    }
}

struct BalanceElectiveModel: Codable {
    var humanity: Bool
    var society: Bool
    var nature: Bool
    var engineering: Bool
    var art: Bool
    
    func isBalanceElectiveSelected() -> Bool {
        return humanity || society || nature || engineering || art
    }
    
    init(humanity: Bool = false, society: Bool = false, nature: Bool = false, engineering: Bool = false, art: Bool = false) {
        self.humanity = humanity
        self.society = society
        self.nature = nature
        self.engineering = engineering
        self.art = art
    }
}


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
