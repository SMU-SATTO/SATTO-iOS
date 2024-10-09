//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import SwiftUI

@MainActor
class ConstraintState: ObservableObject {
    @Published var constraints: ConstraintModel = ConstraintModel()
    
    //request할 때 보낼 과목 조합 리스트
    @Published var selectedMajorCombs: [MajorComb] = []      //majorList
    
    //서버에서 준 과목 조합 리스트
    @Published var majorCombs: [MajorComb]?
    @Published var finalTimetableList: [[LectureModel]]?
    
    @Published private(set) var semesterYear: String = "2024학년도 2학기"
}
