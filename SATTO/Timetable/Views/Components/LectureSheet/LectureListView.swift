//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureListView: View {
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    var containerSize: CGSize
    @Binding var showFloater: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(lectureSheetViewModel.lectureList.indices, id: \.self) { index in
                        let subjectDetail = lectureSheetViewModel.lectureList[index]
                        LectureCardView(lectureSheetViewModel: lectureSheetViewModel, showFloater: $showFloater, lectureDetail: subjectDetail, index: index, containerSize: containerSize)
                            .padding(.horizontal, 10)
                            .task {
                                if index == lectureSheetViewModel.lectureList.count - 1 {
                                    await lectureSheetViewModel.loadMoreSubjects()
                                }
                            }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                    
                    if lectureSheetViewModel.isLoading {
                        ProgressView().padding()
                    }
                }
            }
            .task {
                if lectureSheetViewModel.lectureList.isEmpty {
                    await lectureSheetViewModel.fetchCurrentLectureList()
                }
            }
        }
    }
}
