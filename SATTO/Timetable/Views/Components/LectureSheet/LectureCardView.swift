//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import SwiftUI

struct LectureCardView: View {
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    @Binding var showFloater: Bool
    var lectureDetail: LectureModel
    var index: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.subjectMajorBackground)
                    .frame(width: 50, height: 20)
                    .overlay(
                        Text(lectureDetail.major)
                            .foregroundStyle(Color.subjectMajorText)
                            .font(.sb12)
                    )
                    .padding([.leading, .top], 10)
                VStack(spacing: 3) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(lectureDetail.sbjName)
                                .font(.sb16)
                                .padding(.trailing, 30)
                            Text(lectureDetail.prof)
                                .font(.m14)
                        }
                        Spacer()
                    }
                    HStack {
                        Text(lectureDetail.time)
                            .font(.m12)
                        Text(lectureDetail.sbjDivcls)
                            .font(.m12)
                        Spacer()
                    }
                    .foregroundStyle(.gray400)
                }
                .padding(.leading, 10)
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        let selectionSuccess = lectureSheetViewModel.toggleSelection(lecture: lectureDetail)
                        if !selectionSuccess {
                            showFloater = true
                        }
                    }) {
                        Image(systemName: lectureSheetViewModel.isSelected(Lecture: lectureDetail) ? "checkmark.circle.fill" : "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color(red: 0.063, green: 0.51, blue: 0.788))
                    }
                    .padding([.top, .trailing], 20)
                }
                Spacer()
            }
            Group {
                lectureSheetViewModel.isSelected(Lecture: lectureDetail)
                ? RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.subjectCardBorder, lineWidth: 1)
                : nil
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(lectureSheetViewModel.isSelected(Lecture: lectureDetail) ? Color.subjectCardSelected : Color.subjectCardBackground)
                .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        )
    }
}

#Preview {
    @Environment(\.colorScheme) var colorScheme
    LectureCardView(lectureSheetViewModel: LectureSheetViewModel(container: .preview), showFloater: .constant(false), lectureDetail: LectureModel(), index: 0, colorScheme: _colorScheme)
}
