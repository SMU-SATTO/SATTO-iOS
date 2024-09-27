//
//  InvalidTimeSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

// MARK: - 불가능한 시간대 선택
struct InvalidTimeSelectorView: View {
    @ObservedObject var constraintsViewModel: ConstraintsViewModel
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    @Binding var invalidPopup: Bool
    
    var body: some View {
        ScrollView {
            TimeSelectorView(viewModel: constraintsViewModel,
                             title: "불가능한 시간대가 있으면\n선택해 주세요.",
                             preselectedSlots: constraintsViewModel.parsePreselectedSlots(),
                             selectedSubviews: $selectedSubviews,
                             alreadySelectedSubviews: $alreadySelectedSubviews, invalidPopup: $invalidPopup)
            .padding(.horizontal, 15)
        }
    }
}


#Preview {
    InvalidTimeSelectorView(constraintsViewModel: ConstraintsViewModel(container: .preview), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]), invalidPopup: .constant(false))
}
