//
//  TimeTableCustom.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI

struct TimeTableCustom: View {
    @Binding var stackPath: [Route]
    
    var body: some View {
        Text("수동 생성")
    }
}

#Preview {
    TimeTableCustom(stackPath: .constant([.timeTableCustom]))
}
