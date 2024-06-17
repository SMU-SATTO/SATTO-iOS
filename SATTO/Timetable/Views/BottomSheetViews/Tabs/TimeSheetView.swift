//
//  TimeSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct TimeSheetView: View {
    @ObservedObject var bottomSheetViewModel: BottomSheetViewModel
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    var body: some View {
        ScrollView {
            TimeSelectorView(viewModel: bottomSheetViewModel,
                             title: "보고싶은 시간대를 선택해주세요.",
                             preselectedSlots: [],
                             selectedSubviews: $selectedSubviews,
                             alreadySelectedSubviews: $alreadySelectedSubviews, invalidPopup: .constant(false))
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    TimeSheetView(bottomSheetViewModel: BottomSheetViewModel(), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]))
}
