//
//  InvalidTimeSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

// MARK: - 불가능한 시간대 선택
struct InvalidTimeSelectorView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    @Binding var invalidPopup: Bool
    
    var body: some View {
        ScrollView {
            TimeSelectorView(viewModel: selectedValues,
                             title: "불가능한 시간대가 있으면\n선택해 주세요.",
                             preselectedSlots: selectedValues.parsePreselectedSlots(),
                             selectedSubviews: $selectedSubviews,
                             alreadySelectedSubviews: $alreadySelectedSubviews, invalidPopup: $invalidPopup)
            .padding(.horizontal, 15)
        }
    }
}

struct InvalidPopupView: View {
    @Binding var invalidPopup: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.popupBackground)
            .frame(width: 300, height: 300)
            .overlay(
                VStack(spacing: 30) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.yellow)
                    
                    Text("불가능한 시간대가 많으면\n원활한 시간표 생성이 어려울 수 있어요.")
                        .font(.sb16)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        invalidPopup = false
                    }) {
                        Text("확인했어요")
                            .font(.sb14)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.buttonBlue)
                    )
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                }
            )
    }
}

#Preview {
    InvalidTimeSelectorView(selectedValues: SelectedValues(), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]), invalidPopup: .constant(false))
}
