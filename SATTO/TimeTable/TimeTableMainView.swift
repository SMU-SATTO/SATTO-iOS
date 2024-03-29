//
//  TimeTableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView
import DGCharts
import JHTimeTable

struct TimeTableMainView: View {
    @State private var selectedTab = "이수 학점"
    @State private var selectedPickerIndex = "총 이수학점"
    
    @State var username = "민재"
    
    @State private var isMenuOpen = false
    @State var selectedIndex = 0
   
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 0.85, green: 0.87, blue: 1))
                    .frame(height: 200)
                    .overlay(
                        ZStack {
                            VStack(alignment: .leading) {
                                HStack(spacing: 20) {
                                    VStack {
                                        Button(action: {
                                            selectedTab = "시간표"
                                        }) {
                                            Text("시간표")
                                                .font(
                                                    Font.custom("Pretendard", size: 14)
                                                        .weight(.semibold)
                                                )
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    VStack {
                                        Button(action: {
                                            selectedTab = "이수 학점"
                                        }) {
                                            Text("이수 학점")
                                                .font(
                                                    Font.custom("Pretendard", size: 14)
                                                )
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    Spacer()
                                    
                                   
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("2024년 1학기 시간표가 업로드됐어요!")
                                        .font(
                                            Font.custom("Pretendard", size: 16)
                                                .weight(.bold)
                                        )
                                        .foregroundStyle(.black)
                                        .padding(.top, 20)
                                    
                                    Text("민재님을 위한 시간표를 만들어 드릴게요.")
                                        .font(
                                            Font.custom("Pretendard", size: 12)
                                                .weight(.medium)
                                        )
                                        .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                                        .padding(.top, 5)
                                    
                                    Button(action: {
                                        
                                    }) {
                                        RoundedRectangle(cornerRadius: 7)
                                            .fill(Color(red: 0.11, green: 0.33, blue: 1))
                                            .frame(width: 120, height: 35)
                                            .overlay(
                                                Text("시간표 만들기 ->")
                                                    .font(
                                                        Font.custom("Pretendard", size: 12)
                                                            .weight(.semibold)
                                                    )
                                                    .foregroundStyle(.white)
                                            )
                                    }
                                    .padding(.top, 10)
                                }
                                
                            }
                            .padding(.leading, 20)
                            HStack {
                                Spacer()
                                Image("TimeTableMainView_SATTO")
                                    .resizable()
                                    .frame(width: 180, height: 160)
                                
                            }
                        }
                    )
                if selectedTab == "시간표" {
                    VStack {
                        HStack {
                            Text("\(username)님의 이번 학기 시간표")
                                .padding(.leading, 10)
                            Spacer()
                            //MARK: - 오른쪽 메뉴 오픈
                            Button(action: {
                                isMenuOpen.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }
                            .padding(.trailing, 10)
                        }
                        .padding(.top, 10)
                        JHLectureTable {
                            ForEach(LectureModel.examples) { lecture in
                                ZStack(alignment: .topLeading) {
                                    Rectangle()
                //                        .foregroundStyle(Color(hexString: lecture.color))
                                    Text(lecture.title)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                        .padding(EdgeInsets(top: 2, leading: 3, bottom: 0, trailing: 0))
                                }
                                .lectureTableTime(week: lecture.week,
                                                  startAt: lecture.startAt,
                                                  endAt: lecture.endAt)
                            }
                        } timebar: { time in
                            // Add customized timebar
                            Text("\(time.hour)")
                                .padding(.trailing, 3)
                        } weekbar: { week in
                            // week: LectureWeeks enum
                            // You can use week.symbol, week.shortSymbol, week.veryShortSymbol
                            // Add cusomized weekbar
                            Text("\(week)")
                                .padding(.horizontal, 0)
                        } background: {
                            // Add background
                        }
                        .lectureTableWeekdays([.sun, .mon, .tue, .wed, .thu, .fri, .sat])
                        .lectureTableTimes(startAt: .init(hour: 8, minute: 0), endAt: .init(hour: 22, minute: 0)) // 시작, 끝 시간 설정
                        .lectureTableBorder(width: 0.5, radius: 0, color: "#979797") // table 그리드 선 색 변경
                        .lectureTableBar(time: .init(height: 0, width: 30), week: .init(height: 30, width: 10)) //날짜, 시간 위치 변경 가능
                        .padding(.horizontal, 15)
                    }
                }
                else if selectedTab == "이수 학점" {
                    HStack {
                        Text("\(username)님의 이수 학점")
                            .padding(.leading, 30)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.98))
                        .frame(height: 50)
                        .overlay(
                            HStack(spacing: 0) {
                                ForEach(["총 이수학점", "전공", "교양필수", "교양"], id: \.self) { text in
                                    CustomPickerView(text: text, selectedOption: $selectedPickerIndex)
                                }
                                .padding(.horizontal, 5)
                            }
                                .padding(.horizontal, 5)
                        )
                        .padding(.horizontal, 20)
                    HStack {
                        Text("졸업까지 필요한 학점")
                            .padding(.leading, 30)
                        Spacer()
                    }
                    GraduationRequirementsRadarView(entries: ChartTransaction.allTransactions.map { RadarChartDataEntry(value: $0.quantity) })
                        .frame(width: 300, height: 300)
                }
                Spacer()
            }
        }
        .popup(isPresented: $isMenuOpen, view: {
            TimeTableMenuView(isMenuOpen: $isMenuOpen)
        }, customize: {
            $0
                .position(.trailing)
                .appearFrom(.right)
                .backgroundColor(.black.opacity(0.5))
        })
    }
}

struct CustomPickerView: View {
    var text: String
    @Binding var selectedOption: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(selectedOption == text ? Color.white : Color.clear)
            .frame(height: 30)
            .overlay(
                Text(text)
                    .font(
                        Font.custom("Pretendard", size: 14)
                            .weight(.semibold)
                    )
                    .foregroundStyle(selectedOption == text ? Color.blue : Color.black)
            )
            .onTapGesture {
                withAnimation {
                    selectedOption = text
                }
            }
    }
}

#Preview {
    TimeTableMainView()
}
