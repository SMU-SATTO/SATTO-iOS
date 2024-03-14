//
//  TimeTableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

struct TimeTableMainView: View {
    @State private var selectedTab = "시간표"
    @State private var selectedPickerIndex = "총 이수학점"
    
    @State var username = "민재"
    
    @State private var isMenuOpen = false
    
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 0.85, green: 0.87, blue: 1))
                    .frame(height: 200)
                    .overlay(
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
                                
                                //MARK: - 오른쪽 메뉴 오픈
                                Button(action: {
                                    isMenuOpen.toggle()
                                }) {
                                    Image(systemName: "list.bullet")
                                }
                                .padding(.trailing, 10)
                            }
                            
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
                            .padding(.top, 10
                            )
                        }
                            .padding(.leading, 20)
                    )
                
                if selectedTab == "시간표" {
                    Text("\(username)님의 이번 학기 시간표")
                        .padding(.top, 10)
                }
                else if selectedTab == "이수 학점" {
                    Text("\(username)님의 이수 학점")
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
                }
                Spacer()
            }
            .disabled(isMenuOpen)
            if isMenuOpen {
                TimeTableMenuView(isMenuOpen: $isMenuOpen)
            }
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
                    .font(
                        Font.custom("Pretendard", size: 14)
                            .weight(.semibold)
                    )
                    .foregroundStyle(selectedOption == text ? Color.blue : Color.black)
            )
            .onTapGesture {
                selectedOption = text
            }
    }
}

#Preview {
    TimeTableMainView()
}
