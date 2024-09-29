//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureSelectionList: View {
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    var showResultAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if !lectureSheetViewModel.isSelectedSubjectsEmpty() {
                HStack {
                    Text("선택한 과목")
                        .font(.sb14)
                        .foregroundStyle(Color.blackWhite200)
                        .padding(.top, 10)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(lectureSheetViewModel.selectedLectures, id: \.sbjDivcls) { subject in
                            HStack {
                                Text(subject.sbjName)
                                    .font(.m14)
                                Button(action: {
                                    lectureSheetViewModel.removeSubject(subject)
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12)
                                }
                            }
                            .foregroundStyle(Color.blackWhite200)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundStyle(Color.subjectItemBackground)
                                    .frame(height: 25)
                                    .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: -5))
                            )
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        }
                    }
                }
                HStack {
                    GeometryReader { geometry in
                        Button(action: {
                            lectureSheetViewModel.clear()
                        }) {
                            Text("선택 초기화")
                                .font(.sb14)
                                .foregroundStyle(Color.buttonBlue)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.buttonBlue, lineWidth: 1)
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .frame(height: 40)
                    GeometryReader { geometry in
                        Button(action: {
                            showResultAction()
                        }) {
                            Text("\(lectureSheetViewModel.selectedLectures.count)개 결과 보기")
                                .font(.sb14)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.buttonBlue)
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .frame(height: 40)
                }
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal, 20)
    }
}
