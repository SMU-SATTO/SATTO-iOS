//
//  SATTOLectureSheetView.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct SATTOLectureSheetView: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    
    @State private var showFloater: Bool = false
    
    @State private var selectedTab = ""
    
    var showResultAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.popupBackground
                .ignoresSafeArea(.all)
            VStack(spacing: 15) {
                VStack {
                    LectureFilterView(viewModel: viewModel)
                    VStack(spacing: 5) {
                        LectureListView(
                            viewModel: viewModel,
                            showFloater: $showFloater
                        )
                        LectureSelectionList(lectureSheetViewModel: viewModel, showResultAction: showResultAction)
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
