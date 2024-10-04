//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureListView: View {
    @ObservedObject var viewModel: LectureSearchViewModel
    @Binding var showFloater: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.lectureList.indices, id: \.self) { index in
                        let lecture = viewModel.lectureList[index]
                        LectureCardView(lectureSearchViewModel: viewModel, showFloater: $showFloater, lectureDetail: lecture, index: index)
                            .padding(.horizontal, 10)
                            .task {
                                if index == viewModel.lectureList.count - 1 {
                                    await viewModel.loadMoreLectures()
                                }
                            }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                    
                    if viewModel.isLoading {
                        ProgressView().padding()
                    }
                }
            }
        }
    }
}
