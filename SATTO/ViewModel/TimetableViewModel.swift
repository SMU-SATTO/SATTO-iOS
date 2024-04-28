//
//  TimetableViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import Foundation

class TimetableViewModel: ObservableObject {
    @Published var subjectData = TimetableModel(sbjDivcls: "", sbjNo: "", name: "", time: "")
    
}
