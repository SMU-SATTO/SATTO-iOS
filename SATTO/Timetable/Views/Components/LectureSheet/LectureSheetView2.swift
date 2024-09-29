//
//  LectureSheetView2.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureSheetView2: View {
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    
    @State private var showFloater: Bool = false
    
    var showResultAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                LectureListView(
                    lectureSheetViewModel: lectureSheetViewModel,
                    containerSize: geometry.size,
                    showFloater: $showFloater
                )
                LectureSelectionList(lectureSheetViewModel: lectureSheetViewModel, showResultAction: showResultAction)
            }
            .popup(isPresented: $showFloater) {
                floaterView
            } customize: {
                $0.type(.floater())
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .autohideIn(1.5)
            }
        }
    }
    
    private var floaterView: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color.popupBackground)
            .frame(width: 200, height: 50)
            .shadow(radius: 10)
            .overlay(
                Text("시간대나 과목이 겹쳐요!")
                    .font(.sb16)
            )
    }
}
