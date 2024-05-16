//
//  DefaultSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI
import Charts



struct SubjectDetail {
    var subject: TimetableDetailModel
    var isExpanded: Bool = false
    var isSelected: Bool = false
}

struct DefaultSheetView: View {
    @ObservedObject var timetableViewModel = TimetableViewModel()
    
    @State private var selectedSubjects: [TimetableDetailModel] = []
    @State private var selectedSubjectIndex: [Int] = []
    @State private var expandedSubjectIndex: Int?
    
    var showResultAction: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(timetableViewModel.subjectDetailDataList.indices, id: \.self) { index in
                    let subjectDetail = timetableViewModel.subjectDetailDataList[index]
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(isSelected(at: index) ? Color.white : Color.gray50)
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
                                    .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
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
                                        toggleSelection(at: index)
                                        //MARK: - 강의 리스트에 추가
                                        
                                    }) {
                                        Image(systemName: isSelected(at: index) ?  "checkmark.circle.fill" : "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    }
                                    .padding([.top, .trailing], 20)
                                }
                                Spacer()
                            }
                        )
                        .overlay(
                            isSelected(at: index) ?
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
            }

            if selectedSubjectIndex.count != 0 {
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
                            ForEach(selectedSubjects, id: \.sbjDivcls) { subject in
                                HStack {
                                    Text(subject.sbjName)
                                        .font(.m14)
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12)
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
                            selectedSubjects.removeAll()
                            selectedSubjectIndex.removeAll()
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
                                    Text("19개 결과 보기")
                                        .font(.sb14)
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
            }
        }
    }
    
    private func isExpanded(at index: Int) -> Bool {
        guard let expandedSubjectIndex = expandedSubjectIndex else {
            return false
        }
        return index == expandedSubjectIndex
    }
    
    private func isSelected(at index: Int) -> Bool {
        return selectedSubjectIndex.contains(index)
    }
    
    private func toggleExpansion(at index: Int) {
        if isExpanded(at: index) {
            expandedSubjectIndex = nil
        } else {
            expandedSubjectIndex = index
        }
    }
    
    private func toggleSelection(at index: Int) {
        let selectedSubject = timetableViewModel.subjectDetailDataList[index]
        if let selectedIndex = selectedSubjectIndex.firstIndex(of: index) {
            selectedSubjectIndex.remove(at: selectedIndex)
            if let indexToRemove = selectedSubjects.firstIndex(where: { $0.sbjDivcls == selectedSubject.sbjDivcls }) {
                selectedSubjects.remove(at: indexToRemove)
            }
        } else {
            selectedSubjectIndex.append(index)
            selectedSubjects.append(selectedSubject)
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
    DefaultSheetView(showResultAction: {})
}
