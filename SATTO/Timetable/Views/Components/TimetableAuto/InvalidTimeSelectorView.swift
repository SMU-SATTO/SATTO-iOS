//
//  InvalidTimeSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

// MARK: - 불가능한 시간대 선택
struct InvalidTimeSelectorView: View {
    @ObservedObject var viewModel: ConstraintsViewModel
    @State var isPresented: Bool = false
    @State var hasShownPopup: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 5) {
                Text("불가능한 시간대를 선택해주세요.")
                    .font(.sb18)
                    .frame(width: 320, alignment: .topLeading)
                Text("드래그로 선택할 수 있어요.")
                    .font(.sb12)
                    .foregroundStyle(.gray)
                    .frame(width: 320, alignment: .topLeading)
                if viewModel.selectedBlocks.count > 15 {
                    Text("불가능한 시간대가 많으면 원활한 시간표 생성이 어려울 수 있어요.")
                        .font(.sb12)
                        .foregroundStyle(.red)
                        .frame(width: 320, alignment: .topLeading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            TimeSelectorView(viewModel: viewModel)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 10, trailing: 20))
        }
    }
}

#Preview {
    InvalidTimeSelectorView(viewModel: ConstraintsViewModel(container: .preview))
}
