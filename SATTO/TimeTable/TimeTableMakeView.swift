//
//  TimeTableMakeView.swift
//  SATTO
//
//  Created by 김영준 on 2/29/24.
//

import SwiftUI

struct TimeTableMakeView: View {
    @StateObject var timeTableMainViewModel = TimeTableMainViewModel()
    @State private var selectedTab = 0
    
    var tabs: [AnyView] {
        [
            AnyView(TimeTableOptionView()),
            AnyView(CreditRangePickerView()),
            AnyView(EssentialClassesSelectorView()),
            AnyView(MajorCountSelectorView(timeTableMainViewModel: timeTableMainViewModel)),
            AnyView(InvalidTimeSelectorView()),
            AnyView(MajorCombinationSelectorView()),
            AnyView(FinalTimetableSelectorView())
        ]
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                CustomPageControl(
                    totalIndex: tabs.count,
                    selectedIndex: selectedTab
                )
                .animation(.spring(), value: UUID())
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 20)
            
            TabView(selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabs[index].tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 100)
            
            HStack(spacing: 20) {
                if (selectedTab != 0) {
                    Button(action: {
                        if selectedTab > 0 {
                            selectedTab -= 1
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 150, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 2)
                                    .stroke(.blue, lineWidth: 2)
                                    .overlay {
                                        Text("이전으로")
                                            .font(
                                                Font.custom("Pretendard", size: 18)
                                                    .weight(.semibold)
                                            )
                                            .foregroundStyle(Color(red: 0.11, green: 0.33, blue: 1))
                                        
                                    }
                            )
                        
                    }
                }
                if (selectedTab != 6) {
                    Button(action: {
                        if selectedTab < tabs.count - 1 {
                            selectedTab += 1
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.11, green: 0.33, blue: 1))
                            .frame(width: 150, height: 50)
                            .overlay {
                                Text("다음으로")
                                    .font(Font.custom("Pretendard", size: 18))
                                    .foregroundStyle(.white)
                            }
                    }
                }
            }
        }
        .padding(.bottom, 100)
        .animation(.easeInOut, value: UUID())
    }
}

struct CustomPageControl: View {
    let totalIndex: Int
    let selectedIndex: Int
    
    @Namespace private var animation
    
    let rectangleHeight: CGFloat = 7
    let rectangleRadius: CGFloat = 5
    
    var body: some View {
        HStack {
            //MARK: - 개수 수정 필요
            ForEach(0..<totalIndex, id: \.self) { index in
                if selectedIndex == index {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                        .overlay {
                           Rectangle()
                            //MARK: - 색깔 asset 설정
                                .fill(Color(red: 0.06, green: 0.51, blue: 0.79))
                                .frame(height: rectangleHeight)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: rectangleRadius)
                                )
                                .matchedGeometryEffect(id: "IndicatorAnimationId", in: animation)
                        }
                } else {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(
                            RoundedRectangle(cornerRadius: rectangleRadius)
                        )
                }
            }
        }
    }
}


#Preview {
    TimeTableMakeView()
}
