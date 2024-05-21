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
/// 같은 시간대 비교해서 중복선택하면 선택 못하게 해야함
/// 학점 넘치는 선택은 어떻게 처리?

struct SubjectSheetView: View {
    ///서버에서 받아온 TimetableViewModel
    @ObservedObject var timetableViewModel: TimetableViewModel
    
    @State private var expandedSubjectIndex: Int?
    @State private var showFloater: Bool = false
    
    var showResultAction: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(timetableViewModel.subjectDetailDataList.indices, id: \.self) { index in
                    let subjectDetail = timetableViewModel.subjectDetailDataList[index]
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(timetableViewModel.isSelected(subject: subjectDetail) ? Color.white : Color.gray50)
                        .frame(width: 330, height: isExpanded(at: index) ? 310 : 130)
                        .shadow(color: Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.25), radius: 6.23, x: 0, y: 1.22)
                        .overlay(
                            VStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0.91, green: 0.94, blue: 1))
                                    .frame(width: 50, height: 23)
                                    .overlay(
                                        Text("\(subjectDetail.major)")
                                            .foregroundStyle(.blue)
                                            .font(.sb12)
                                    )
                                    .padding([.leading, .top], 10)
                                VStack(spacing: 3) {
                                    HStack {
                                        Text("\(subjectDetail.sbjName)")
                                            .font(.sb20)
                                            .foregroundStyle(.black)
                                        Text("\(subjectDetail.prof)")
                                            .foregroundStyle(.black)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("\(subjectDetail.time)")
                                            .font(.m14)
                                        Text("\(subjectDetail.sbjDivcls)")
                                            .font(.m14)
                                        Spacer()
                                    }
                                    .foregroundStyle(.gray400)
                                }
                                .padding(.leading, 10)
                                
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
                                Spacer()
                                if isExpanded(at: index) {
                                    HStack {
                                        Spacer()
                                        SubjectChartView(todayEnrolledData: subjectDetail.enrolledStudents, yesterdayEnrolledData: subjectDetail.yesterdayEnrolledData, threeDaysAgoEnrolledData: subjectDetail.threeDaysAgoEnrolledData)
                                        Spacer()
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                        )
                        .overlay(
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        let selectionSuccess = timetableViewModel.toggleSelection(subject: subjectDetail)
                                        //MARK: - 시간 겹친다고 알림 띄우기 토스트창으로? 띄우기
                                        if !selectionSuccess {
                                            showFloater = true
                                        }
                                    }) {
                                        Image(systemName: timetableViewModel.isSelected(subject: subjectDetail) ?  "checkmark.circle.fill" : "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    }
                                    .padding([.top, .trailing], 20)
                                }
                                Spacer()
                            }
                        )
                        .overlay(
                            timetableViewModel.isSelected(subject: subjectDetail) ?
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.4, green: 0.31, blue: 1), lineWidth: 1)
                            : nil
                        )
                        .onTapGesture {
                            withAnimation {
                                toggleExpansion(at: index)
                            }
                        }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }

            if !timetableViewModel.isSelectedSubjectsEmpty() {
                VStack(spacing: 0) {
                    HStack {
                        Text("선택한 과목")
                            .font(.sb14)
                            .foregroundStyle(.gray800)
                            .padding(.top, 10)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(timetableViewModel.selectedSubjects, id: \.sbjDivcls) { subject in
                                HStack {
                                    Text(subject.sbjName)
                                        .font(.m14)
                                    Button(action: {
                                        timetableViewModel.removeSubject(subject)
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12)
                                    }
                                }
                                .foregroundStyle(.gray600)
                                .frame(height: 60)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundStyle(.gray100)
                                    .frame(height: 25)
                                    .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: -5))
                            )
                        }
                        .padding(.leading, 20)
                    }
                    HStack {
                        Button(action: {
                            timetableViewModel.clear()
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.4, green: 0.31, blue: 1), lineWidth: 1)
                                .foregroundStyle(.white)
                                .frame(width: 170, height: 40)
                                .overlay(
                                    Text("선택 초기화")
                                        .font(.sb14)
                                )
                        }
                        Button(action: {
                            self.showResultAction()
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color("blue_7"))
                                .frame(width: 170, height: 40)
                                .overlay(
                                    Text("\(timetableViewModel.selectedSubjects.count)개 결과 보기")
                                        .font(.sb14)
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
            }
        }
        .popup(isPresented: $showFloater) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 200, height: 50)
                .shadow(radius: 10)
                .overlay(
                    Text("시간대가 겹쳐요!")
                )
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(0.7)
        }
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
    SubjectSheetView(timetableViewModel: TimetableViewModel(), showResultAction: {})
}
