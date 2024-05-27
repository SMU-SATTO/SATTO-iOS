//
//  DefaultSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI
import Charts
import PopupView

//MARK: - 할일
/// 학점 넘치는 선택은 어떻게 처리?

struct SubjectSheetView: View {
    ///서버에서 받아온 TimetableViewModel
    @ObservedObject var timetableViewModel: TimetableViewModel
    @ObservedObject var selectedValues: SelectedValues
    
    @State private var expandedSubjectIndex: Int?
    @State private var showFloater: Bool = false
    
    var showResultAction: () -> Void
    
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
                    .autohideIn(0.7)
            }
        }
    }
    
    private func subjectListView(containerSize: CGSize) -> some View {
        ScrollView {
            VStack {
                ForEach(timetableViewModel.subjectDetailDataList.indices, id: \.self) { index in
                    let subjectDetail = timetableViewModel.subjectDetailDataList[index]
                    subjectCardView(subjectDetail, at: index, containerSize: containerSize)
                        .padding(.horizontal, 10)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        }
    }
    
    private func subjectCardView(_ subjectDetail: TimetableDetailModel, at index: Int, containerSize: CGSize) -> some View {
        ZStack {
            subjectCardContent(subjectDetail, at: index, containerSize: containerSize)
            subjectCardButton(subjectDetail)
            subjectCardBorder(subjectDetail)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(selectedValues.isSelected(subject: subjectDetail) ? Color.white : Color.white)
                .shadow(color: Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65), radius: 6.23, x: 0, y: 1.22)
                .onTapGesture {
                    withAnimation {
                        toggleExpansion(at: index)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
        )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    private func subjectCardContent(_ subjectDetail: TimetableDetailModel, at index: Int, containerSize: CGSize) -> some View {
        VStack(alignment: .leading) {
            subjectMajorView(subjectDetail)
            subjectInfoView(subjectDetail)
            subjectEnrollmentView(subjectDetail)
            if isExpanded(at: index) {
                subjectChartView(subjectDetail, containerSize: containerSize)
            }
        }
    }
    
    private func subjectMajorView(_ subjectDetail: TimetableDetailModel) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color(red: 0.91, green: 0.94, blue: 1))
            .frame(width: 50, height: 23)
            .overlay(
                Text(subjectDetail.major)
                    .foregroundStyle(.blue)
                    .font(.sb12)
            )
            .padding([.leading, .top], 10)
    }
    
    private func subjectInfoView(_ subjectDetail: TimetableDetailModel) -> some View {
        VStack(spacing: 3) {
            HStack {
                Text(subjectDetail.sbjName)
                    .font(.sb16)
                    .foregroundStyle(.black)
                Text(subjectDetail.prof)
                    .font(.m14)
                    .foregroundStyle(.black)
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
    
    private func subjectEnrollmentView(_ subjectDetail: TimetableDetailModel) -> some View {
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
    
    private func subjectChartView(_ subjectDetail: TimetableDetailModel, containerSize: CGSize) -> some View {
        HStack {
            Spacer()
            SubjectChartView(todayEnrolledData: subjectDetail.enrolledStudents, yesterdayEnrolledData: subjectDetail.yesterdayEnrolledData, threeDaysAgoEnrolledData: subjectDetail.threeDaysAgoEnrolledData)
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    private func subjectCardButton(_ subjectDetail: TimetableDetailModel) -> some View {
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
                }
                .padding([.top, .trailing], 20)
            }
            Spacer()
        }
    }
    
    private func subjectCardBorder(_ subjectDetail: TimetableDetailModel) -> some View {
        selectedValues.isSelected(subject: subjectDetail) ?
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color(red: 0.4, green: 0.31, blue: 1), lineWidth: 1)
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
    }
    
    private var selectedSubjectsHeaderView: some View {
        HStack {
            Text("선택한 과목")
                .font(.sb14)
                .foregroundStyle(.gray800)
                .padding([.top, .leading], 10)
            Spacer()
        }
    }
    
    private var selectedSubjectsListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(selectedValues.selectedSubjects, id: \.sbjDivcls) { subject in
                    selectedSubjectItemView(subject as! TimetableDetailModel)
                }
            }
            .padding(.leading, 20)
        }
    }
    
    private func selectedSubjectItemView(_ subject: TimetableDetailModel) -> some View {
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
        .foregroundStyle(.gray600)
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.gray100)
                .frame(height: 25)
                .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: -5))
        )
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1), lineWidth: 1)
                    .foregroundStyle(.white)
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
                    .foregroundStyle(Color("blue_7"))
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(height: 40)
    }
    
    private var floaterView: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.white)
            .frame(width: 200, height: 50)
            .shadow(radius: 10)
            .overlay(
                Text("시간대가 겹쳐요!")
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

//MARK: - 수강인원 그래프 구현
struct ValuePerSubjectCategory {
    var category: String
    var value: Int
    var date: String
}

struct SubjectChartView: View {
    let subjectChartData: [ValuePerSubjectCategory]
    
    var todayEnrolledData: Int
    var yesterdayEnrolledData: Int
    var threeDaysAgoEnrolledData: Int
    
    init(todayEnrolledData: Int, yesterdayEnrolledData: Int, threeDaysAgoEnrolledData: Int) {
        self.todayEnrolledData = todayEnrolledData
        self.yesterdayEnrolledData = yesterdayEnrolledData
        self.threeDaysAgoEnrolledData = threeDaysAgoEnrolledData
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        let currentDate = Date()
        subjectChartData = [
            .init(category: "2 days ago", value: threeDaysAgoEnrolledData, date: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!)),
            .init(category: "Yesterday", value: yesterdayEnrolledData, date: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!)),
            .init(category: "Today", value: todayEnrolledData, date: dateFormatter.string(from: currentDate))
        ]
    }
    
    var body: some View {
        VStack {
            Chart(subjectChartData, id: \.category) { item in
                BarMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
                .cornerRadius(5)
            }
            .foregroundStyle(Color(red: 0.9, green: 0.91, blue: 1))
            .frame(width: 200, height: 160)
        }
    }
}


#Preview {
    SubjectSheetView(timetableViewModel: TimetableViewModel(), selectedValues: SelectedValues(), showResultAction: {})
}
