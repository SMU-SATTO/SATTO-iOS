//
//  DefaultSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI
import PopupView

struct SubjectSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    ///서버에서 받아온 bottomSheetViewModel
    @ObservedObject var bottomSheetViewModel: BottomSheetViewModel
    @ObservedObject var selectedValues: SelectedValues
    
    @State private var expandedSubjectIndex: Int?
    @State private var showFloater: Bool = false
    
    var showResultAction: () -> Void
    
    @State private var isLoading: Bool = false
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                subjectListView(containerSize: geometry.size)
                selectedSubjectsView
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

    private func subjectListView(containerSize: CGSize) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(bottomSheetViewModel.subjectDetailDataList.indices, id: \.self) { index in
                        let subjectDetail = bottomSheetViewModel.subjectDetailDataList[index]
                        subjectCardView(subjectDetail, at: index, containerSize: containerSize)
                            .padding(.horizontal, 10)
                            .onAppear {
                                if index == bottomSheetViewModel.subjectDetailDataList.count - 1 {
                                    bottomSheetViewModel.loadMoreSubjects()
                                }
                            }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                    if bottomSheetViewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .onAppear {
                if bottomSheetViewModel.subjectDetailDataList.isEmpty {
                    bottomSheetViewModel.fetchCurrentLectureList(page: 0)
                }
            }
        }
    }
    
    private func subjectCardView(_ subjectDetail: SubjectDetailModel, at index: Int, containerSize: CGSize) -> some View {
        ZStack {
            subjectCardContent(subjectDetail, at: index, containerSize: containerSize)
            subjectCardButton(subjectDetail)
            subjectCardBorder(subjectDetail)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(selectedValues.isSelected(subject: subjectDetail) ? Color.subjectCardSelected : Color.subjectCardBackground)
                .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
            //TODO: - ToggleExpansion 백엔드 이슈로 빼기로 결정
//                .onTapGesture {
//                    withAnimation {
//                        toggleExpansion(at: index)
//                    }
//                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    private func subjectCardContent(_ subjectDetail: SubjectDetailModel, at index: Int, containerSize: CGSize) -> some View {
        VStack(alignment: .leading) {
            subjectMajorView(subjectDetail)
            subjectInfoView(subjectDetail)
            //MARK: - 담은 인원 백엔드 이슈로 빼기로 결정
//            subjectEnrollmentView(subjectDetail)
            if isExpanded(at: index) {
                subjectChartView(subjectDetail, containerSize: containerSize)
            }
        }
    }
    
    private func subjectMajorView(_ subjectDetail: SubjectDetailModel) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.subjectMajorBackground)
            .frame(width: 50, height: 20)
            .overlay(
                Text(subjectDetail.major)
                    .foregroundStyle(Color.subjectMajorText)
                    .font(.sb12)
            )
            .padding([.leading, .top], 10)
    }
    
    private func subjectInfoView(_ subjectDetail: SubjectDetailModel) -> some View {
        VStack(spacing: 3) {
            HStack {
                VStack(alignment: .leading) {
                    Text(subjectDetail.sbjName)
                        .font(.sb16)
                        .padding(.trailing, 30)
                    Text(subjectDetail.prof)
                        .font(.m14)
                }
                Spacer()
            }
            HStack {
                Text(subjectDetail.time)
                    .font(.m12)
                Text(subjectDetail.sbjDivcls)
                    .font(.m12)
                Spacer()
            }
            .foregroundStyle(.gray400)
        }
        .padding(.leading, 10)
    }
    
    private func subjectEnrollmentView(_ subjectDetail: SubjectDetailModel) -> some View {
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(Color(red: 0.67, green: 0.75, blue: 0.94))
                .frame(width: 260, height: 1)
                .padding(.leading, 10)
            HStack {
                Text("수강정원")
                Text("\(subjectDetail.enrollmentCapacity)")
                Text("담은인원")
                Text("\(subjectDetail.enrolledStudents)")
            }
            .font(.m16)
            .padding(.leading, 10)
        }
    }
    
    private func subjectChartView(_ subjectDetail: SubjectDetailModel, containerSize: CGSize) -> some View {
        HStack {
            Spacer()
            SubjectChartView(todayEnrolledData: subjectDetail.enrolledStudents, yesterdayEnrolledData: subjectDetail.yesterdayEnrolledData, threeDaysAgoEnrolledData: subjectDetail.threeDaysAgoEnrolledData)
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    private func subjectCardButton(_ subjectDetail: SubjectDetailModel) -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    let selectionSuccess = selectedValues.toggleSelection(subject: subjectDetail)
                    if !selectionSuccess {
                        showFloater = true
                    }
                }) {
                    Image(systemName: selectedValues.isSelected(subject: subjectDetail) ? "checkmark.circle.fill" : "plus.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color(red: 0.063, green: 0.51, blue: 0.788))
                }
                .padding([.top, .trailing], 20)
            }
            Spacer()
        }
    }
    
    private func subjectCardBorder(_ subjectDetail: SubjectDetailModel) -> some View {
        selectedValues.isSelected(subject: subjectDetail) ?
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.subjectCardBorder, lineWidth: 1)
        : nil
    }
    
    private var selectedSubjectsView: some View {
        VStack(spacing: 0) {
            if !selectedValues.isSelectedSubjectsEmpty() {
                selectedSubjectsHeaderView
                selectedSubjectsListView
                selectedSubjectsActionsView
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var selectedSubjectsHeaderView: some View {
        HStack {
            Text("선택한 과목")
                .font(.sb14)
                .foregroundStyle(Color.blackWhite200)
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private var selectedSubjectsListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(selectedValues.selectedSubjects, id: \.sbjDivcls) { subject in
                    if let detailedSubject = subject as? SubjectDetailModel {
                        selectedSubjectDetailItemView(detailedSubject)
                    } else if let basicSubject = subject as? SubjectModel {
                        selectedSubjectItemView(basicSubject)
                    } else {
                        Text("Invalid subject data")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
    
    private func selectedSubjectItemView(_ subject: SubjectModel) -> some View {
        HStack {
            Text(subject.sbjName)
                .font(.m14)
            Button(action: {
                selectedValues.removeSubject(subject)
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
    
    private func selectedSubjectDetailItemView(_ subject: SubjectDetailModel) -> some View {
        HStack {
            Text(subject.sbjName)
                .font(.m14)
            Button(action: {
                selectedValues.removeSubject(subject)
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
    
    private var selectedSubjectsActionsView: some View {
        HStack {
            clearSelectionButton
            showResultButton
        }
    }
    
    private var clearSelectionButton: some View {
        GeometryReader { geometry in
            Button(action: {
                selectedValues.clear()
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
                Text("\(selectedValues.selectedSubjects.count)개 결과 보기")
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
    
    private func isExpanded(at index: Int) -> Bool {
        guard let expandedSubjectIndex = expandedSubjectIndex else {
            return false
        }
        return index == expandedSubjectIndex
    }
    
    private func toggleExpansion(at index: Int) {
        if isExpanded(at: index) {
            expandedSubjectIndex = nil
        } else {
            expandedSubjectIndex = index
        }
    }
}

#Preview {
    SubjectSheetView(bottomSheetViewModel: BottomSheetViewModel(), selectedValues: SelectedValues(), showResultAction: {})
        .preferredColorScheme(.light)
}
