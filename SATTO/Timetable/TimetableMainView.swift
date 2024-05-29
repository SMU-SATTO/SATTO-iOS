//
//  TimetableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView
import DGCharts
import JHTimeTable

enum TabType {
    case timetable
    case credits
}

struct TimetableMainView: View {
    @Binding var stackPath: [Route]
    
    @State private var selectedTab = TabType.timetable
    @State private var selectedPickerIndex = "총 이수학점"
    
    @State var username = "민재"
    
    @State private var isMenuOpen = false
    @State var selectedIndex = 0
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    headerView
                    tabContentView
                    Spacer()
                }
            }
            .popup(isPresented: $isMenuOpen, view: {
                TimetableMenuView(isMenuOpen: $isMenuOpen)
            }, customize: {
                $0
                    .position(.trailing)
                    .appearFrom(.right)
                    .backgroundColor(.black.opacity(0.5))
            })
        }
    }
    
    private var headerView: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            .fill(Color(red: 0.85, green: 0.87, blue: 1))
            .frame(height: 160)
            .overlay(
                ZStack {
                    headerContent
                    headerImage
                }
            )
    }
    
    private var headerContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            headerTabs
            headerMessage
            createTimetableButton
        }
        .padding(.leading, 20)
    }
    
    private var headerTabs: some View {
        HStack(spacing: 20) {
            tabButton(title: "시간표", tab: .timetable)
            tabButton(title: "이수 학점", tab: .credits)
            Spacer()
        }
    }
    
    private var headerMessage: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("2024년 2학기 시간표가 업로드됐어요!")
                .font(.b16)
                .foregroundStyle(.black)
            Text("\(username)님을 위한 시간표를 만들어 드릴게요.")
                .font(.m12)
                .foregroundStyle(.gray400)
        }
    }
    
    private var createTimetableButton: some View {
        Button(action: {
            stackPath.append(Route.timetableOption)
        }) {
            Text("시간표 만들기 ->")
                .font(.sb12)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color("blue_7"))
                        .padding(EdgeInsets(top: -10, leading: -15, bottom: -10, trailing: -15))
                )
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
    }
    
    private var headerImage: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Image("TimeTableMainView_SATTO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.35) // Adjust width dynamically
                    .frame(height: geometry.size.height * 1.0) // Adjust height dynamically
                    .padding(.trailing, 5)
            }
        }
    }
    
    private var tabContentView: some View {
        VStack {
            if selectedTab == .timetable {
                timetableView
            } else if selectedTab == .credits {
                creditsView
            }
        }
    }
    
    private var timetableView: some View {
        VStack {
            HStack {
                Text("\(username)님의 이번 학기 시간표")
                    .font(.b14)
                    .padding(.leading, 30)
                Spacer()
                Button(action: {
                    isMenuOpen.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 10)
            
            TimetableView(timetableBaseArray: [])
            .padding(.horizontal, 15)
        }
    }
    
    private var creditsView: some View {
        VStack {
            HStack {
                Text("\(username)님의 이수 학점")
                    .font(.b14)
                    .padding(.leading, 30)
                Spacer()
            }
            .padding(.top, 10)
            
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
                    .font(.b14)
                    .padding(.leading, 30)
                Spacer()
            }
            
            GraduationRequirementsRadarView(entries: ChartTransaction.allTransactions.map { RadarChartDataEntry(value: $0.quantity) })
                .frame(width: 300, height: 300)
        }
    }
    
    @ViewBuilder
    private func tabButton(title: String, tab: TabType) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .font(selectedTab == tab ? .sb16 : .sb14)
                .foregroundStyle(selectedTab == tab ? Color("blue_5") : .black)
        }
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
                    .font(.sb14)
                    .foregroundStyle(selectedOption == text ? Color("blue_4") : Color.black)
            )
            .onTapGesture {
                withAnimation {
                    selectedOption = text
                }
            }
    }
}

#Preview {
    TimetableMainView(stackPath: .constant([.timetableMake]))
}
