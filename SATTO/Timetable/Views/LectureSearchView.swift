//
//  LectureSearchView.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureSearchView: View {
    @ObservedObject var viewModel: LectureSearchViewModel
    
    @State private var showFloater: Bool = false
    
    @State private var selectedTab = ""
    
    @State var currCategory: String?
    
    var showResultAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.popupBackground
                .ignoresSafeArea(.all)
            VStack(spacing: 15) {
                VStack {
                    LectureFilterView(viewModel: viewModel, currCategory: $currCategory)
                        .padding(.top, 20)
                    if currCategory != "시간" {
                        Group {
                            VStack(spacing: 5) {
                                LectureListView(
                                    viewModel: viewModel,
                                    showFloater: $showFloater
                                )
                                LectureSelectionList(lectureSearchViewModel: viewModel, showResultAction: showResultAction)
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
                            .task {
                                if viewModel.lectureList.isEmpty {
                                    await viewModel.searchLecture()
                                }
                            }
                        }
                        .padding(.horizontal, 10)
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

#Preview {
    LectureSearchView(viewModel: LectureSearchViewModel(container: .preview), showResultAction: {})
}
