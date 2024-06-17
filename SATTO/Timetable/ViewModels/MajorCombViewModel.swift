//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/4/24.
//

import Foundation
import Moya

class MajorCombViewModel: ObservableObject {
    @Published var majorCombinations: [MajorCombModel] = [
        MajorCombModel(lec: ["컴퓨터네트워크", "소프트웨어공학", "GPU프로그래밍", "디지털신호처리"], combCount: 26),
        MajorCombModel(lec: ["운영체제", "소프트웨어공학", "GPU프로그래밍", "디지털신호처리"], combCount: 16)
    ]
    
    func fetchMajorCombinations(GPA: Int, requiredLect: [SubjectModelBase], majorCount: Int, cyberCount: Int, impossibleTimeZone: String) {
        SATTONetworking.getMajorComb(GPA: GPA, requiredLect: requiredLect.map { $0.sbjDivcls }, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { result in
            switch result {
            case .success(let majorCombModel):
                DispatchQueue.main.async {
                    self.majorCombinations = [majorCombModel]
                }
            case .failure(let error):
                print("Error fetching major combinations: \(error)")
            }
        }
    }
}

class SelectedMajorComb: ObservableObject {
    @Published var selectedMajorCombs: [[String]] = []
    
    func toggleSelection(_ combination: [String]) {
        if selectedMajorCombs.contains(combination) {
            selectedMajorCombs.removeAll(where: { $0 == combination })
        }
        else {
            selectedMajorCombs.append(combination)
        }
    }
        
    func isSelected(_ combination: [String]) -> Bool {
        return selectedMajorCombs.contains(combination)
    }
    //MARK: - POST 요청
}
