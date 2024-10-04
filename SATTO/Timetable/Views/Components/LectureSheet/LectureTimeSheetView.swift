//
//  LectureTimeSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct LectureTimeSheetView: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 5) {
                Text("시간대를 선택해주세요.")
                    .font(.sb18)
                    .frame(width: 320, alignment: .topLeading)
                Text("드래그로 선택할 수 있어요.")
                    .font(.sb12)
                    .foregroundStyle(.gray)
                    .frame(width: 320, alignment: .topLeading)
            }
            TimeSelectorView(viewModel: viewModel)
                .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

#Preview {
    LectureTimeSheetView(viewModel: LectureSheetViewModel(container: .preview))
}
