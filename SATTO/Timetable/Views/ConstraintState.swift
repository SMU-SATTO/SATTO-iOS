//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import SwiftUI

@MainActor
class ConstraintState: ObservableObject {
    @Published var credit: Int = 18                          //GPA
    @Published var majorNum: Int = 3                         //majorcount
    @Published var ELearnNum: Int = 0                        //cybercount
    @Published var selectedSubjects: [SubjectModelBase] = [] //requiredLect
    @Published var selectedTimes: String = ""                //impossibleTimeZone
    
    //request할 때 보낼 과목 조합 리스트
    @Published var selectedMajorCombs: [MajorComb] = []      //majorList
    
    //서버에서 준 과목 조합 리스트
    @Published var majorCombs: [MajorComb]?
    @Published var finalTimetableList: [[SubjectModelBase]]?
    
    func fetchMajorCombs(_ majorCombs: [MajorComb]) {
        self.majorCombs = majorCombs
    }
    
    func fetchFinalTimetableList(_ finalTimetableList: [[SubjectModelBase]]) {
        self.finalTimetableList = finalTimetableList
    }
    
    func toggleSelection(_ combination: MajorComb) {
        if selectedMajorCombs.contains(where: { $0.combination == combination.combination }) {
            selectedMajorCombs.removeAll(where: { $0.combination == combination.combination })
        } else {
            selectedMajorCombs.append(combination)
        }
    }
}
