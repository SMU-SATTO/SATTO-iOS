//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 7/5/24.
//

import SwiftUI

struct TimetableCompletionView: View {
    @Binding var stackPath: [TimetableRoute]
    var body: some View {
        Text("메인화면으로 돌아가서 \n등록된 시간표를 확인해보세요!")
            .font(.sb16)
            .foregroundStyle(.blackWhite)
            .multilineTextAlignment(.center)
    }
    
}

#Preview {
    TimetableCompletionView(stackPath: .constant([]))
}
