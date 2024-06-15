//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

//MARK: - 팝업 상위뷰로 넘겨야 백그라운드 색 제대로 변함
struct FinalTimetableSelectorView: View {
    @Binding var showingPopup: Bool

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("좌우로 스크롤해 \n원하는 시간표를 골라보세요!")
                    .font(.sb16)
                TimetableView(timetableBaseArray: [])
                    .onTapGesture {
                        showingPopup.toggle()
                    }
            }
        }
    }
}


#Preview {
    FinalTimetableSelectorView(showingPopup: .constant(false))
        .preferredColorScheme(.dark)
}
