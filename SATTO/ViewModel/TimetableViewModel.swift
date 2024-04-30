//
//  TimetableViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import Foundation

class TimetableViewModel: ObservableObject {
    @Published var subjectData = TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 목5 목6 ")
    
}
