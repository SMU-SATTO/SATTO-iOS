//
//  LectureSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI
import PopupView

struct LectureSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    @ObservedObject var constraintsViewModel: ConstraintsViewModel
    
    @State private var showFloater: Bool = false
    
    var showResultAction: () -> Void
    
    @State private var isLoading: Bool = false
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                lectureListView(containerSize: geometry.size)
                selectedLecturesView
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

    private func lectureListView(containerSize: CGSize) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(lectureSheetViewModel.lectureList.indices, id: \.self) { index in
                        let lectureDetail = lectureSheetViewModel.lectureList[index]
                        lectureCardView(lectureDetail, at: index, containerSize: containerSize)
                            .padding(.horizontal, 10)
                            .task {
                                if index == lectureSheetViewModel.lectureList.count - 1 {
                                    await lectureSheetViewModel.loadMoreLectures()
                                }
                            }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                    if lectureSheetViewModel.isLoading {
                        ProgressView()
                            .padding()
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
    
    private func lectureCardView(_ lectureDetail: LectureModel, at index: Int, containerSize: CGSize) -> some View {
        ZStack {
            lectureCardContent(lectureDetail, at: index, containerSize: containerSize)
            lectureCardButton(lectureDetail)
            lectureCardBorder(lectureDetail)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(constraintsViewModel.isSelected(Lecture: lectureDetail) ? Color.subjectCardSelected : Color.subjectCardBackground)
                .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    private func lectureCardContent(_ lectureDetail: LectureModel, at index: Int, containerSize: CGSize) -> some View {
        VStack(alignment: .leading) {
            lectureMajorView(lectureDetail)
            lectureInfoView(lectureDetail)
        }
    }
    
    private func lectureMajorView(_ lectureDetail: LectureModel) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.subjectMajorBackground)
            .frame(width: 50, height: 20)
            .overlay(
                Text(lectureDetail.major)
                    .foregroundStyle(Color.subjectMajorText)
                    .font(.sb12)
            )
            .padding([.leading, .top], 10)
    }
    
    private func lectureInfoView(_ lectureDetail: LectureModel) -> some View {
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
    
    private func lectureCardButton(_ lectureDetail: LectureModel) -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    let selectionSuccess = constraintsViewModel.toggleSelection(Lecture: lectureDetail)
                    if !selectionSuccess {
                        showFloater = true
                    }
                }) {
                    Image(systemName: constraintsViewModel.isSelected(Lecture: lectureDetail) ? "checkmark.circle.fill" : "plus.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color(red: 0.063, green: 0.51, blue: 0.788))
                }
                .padding([.top, .trailing], 20)
            }
            Spacer()
        }
    }
    
    private func lectureCardBorder(_ lectureDetail: LectureModel) -> some View {
        constraintsViewModel.isSelected(Lecture: lectureDetail) 
        ? RoundedRectangle(cornerRadius: 10)
            .stroke(Color.subjectCardBorder, lineWidth: 1)
        : nil
    }
    
    private var selectedLecturesView: some View {
        VStack(spacing: 0) {
            if !constraintsViewModel.isSelectedLecturesEmpty() {
                selectedLecturesHeaderView
                selectedLecturesListView
                selectedLecturesActionsView
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var selectedLecturesHeaderView: some View {
        HStack {
            Text("선택한 과목")
                .font(.sb14)
                .foregroundStyle(Color.blackWhite200)
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private var selectedLecturesListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(constraintsViewModel.selectedLectures, id: \.sbjDivcls) { Lecture in
                    selectedLectureItemView(Lecture)
                }
            }
        }
    }
    
    private func selectedLectureItemView(_ Lecture: LectureModel) -> some View {
        HStack {
            Text(Lecture.sbjName)
                .font(.m14)
            Button(action: {
                constraintsViewModel.removeLecture(Lecture)
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
    
    private var selectedLecturesActionsView: some View {
        HStack {
            clearSelectionButton
            showResultButton
        }
    }
    
    private var clearSelectionButton: some View {
        GeometryReader { geometry in
            Button(action: {
                constraintsViewModel.clear()
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
    }

    private var showResultButton: some View {
        GeometryReader { geometry in
            Button(action: {
                showResultAction()
            }) {
                Text("\(constraintsViewModel.selectedLectures.count)개 결과 보기")
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
    LectureSheetView(lectureSheetViewModel: LectureSheetViewModel(container: .preview), constraintsViewModel: ConstraintsViewModel(container: .preview), showResultAction: {})
        .preferredColorScheme(.light)
}
