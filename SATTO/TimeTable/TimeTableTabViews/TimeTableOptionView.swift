//
//  TimeTableOptionView.swift
//  SATTO
//
//  Created by 김영준 on 3/16/24.
//

import SwiftUI

struct TimeTableOptionView: View {
    @State private var isAutoSelected = false
    @State private var isCustomSelected = false
    
    var body: some View {
        VStack {
            Text("시간표 생성 방식을 선택해주세요")
            Button(action: {
                isAutoSelected.toggle()
                if isAutoSelected {
                    isCustomSelected = false // 다른 버튼은 선택 해제
                }
            }) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 238, height: 163)
                    .foregroundStyle(isAutoSelected ? .blue1 : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 2)
                            .stroke(.blue1, lineWidth: 2)
                            .overlay {
                                VStack {
                                    Image("")
                                    Text("자동으로 생성하기")
                                        .font(
                                            Font.custom("Pretendard", size: 18)
                                                .weight(.semibold)
                                        )
                                        .foregroundStyle(Color(red: 0.11, green: 0.33, blue: 1))
                                }
                            }
                    )
            }
            Button(action: {
                isCustomSelected.toggle()
                if isCustomSelected {
                    isAutoSelected = false // 다른 버튼은 선택 해제
                }
            }) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 238, height: 163)
                    .foregroundStyle(isCustomSelected ? .blue1 : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 2)
                            .stroke(.blue1, lineWidth: 2)
                            .overlay {
                                VStack {
                                    Image("")
                                    Text("커스텀 생성하기")
                                        .font(
                                            Font.custom("Pretendard", size: 18)
                                                .weight(.semibold)
                                        )
                                        .foregroundStyle(Color(red: 0.11, green: 0.33, blue: 1))
                                }
                            }
                    )
            }
        }
    }
}

#Preview {
    TimeTableOptionView()
}
