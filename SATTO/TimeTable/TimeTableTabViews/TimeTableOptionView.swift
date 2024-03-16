//
//  TimeTableOptionView.swift
//  SATTO
//
//  Created by 김영준 on 3/16/24.
//

import SwiftUI

struct TimeTableOptionView: View {
    var body: some View {
        Text("시간표 생성 방식을 선택해주세요")
        Button(action: {
            
        }) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 238, height: 163)
                .foregroundStyle(.white)
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
            
        }) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 238, height: 163)
                .foregroundStyle(.white)
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

#Preview {
    TimeTableOptionView()
}
