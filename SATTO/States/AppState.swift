//
//  AppState.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import Combine
import SwiftUI

@MainActor
final class AppState {
    var timetable = TimetableState()
    var constraint = ConstraintState()
    var lectureSearch = LectureSearchState()
}

#if DEBUG
    extension AppState {
        static var preview: AppState {
            let state = AppState()
            
            return state
        }
    }
#endif
