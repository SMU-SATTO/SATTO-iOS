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
