//
//  TimetableModel.swift
//  SATTO
//
//  Created by yeongjoon on 9/23/24.
//

import Foundation

struct TimetableModel {
    let id: Int
    let semester: String
    let name: String
    let lectures: [SubjectModel]
    let isPublic: Bool
    let isRepresented: Bool
}

extension TimetableModel {
    
}

#if DEBUG
    extension TimetableModel {
        static var preview: TimetableModel {
            return .init(
                id: 0, semester: "2024-2", name: "시간표", lectures: [], isPublic: false, isRepresented: false
            )
        }
    }
#endif