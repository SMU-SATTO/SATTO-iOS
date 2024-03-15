//
//  TimeTableMenuView.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import SwiftUI

struct TimeTableMenuView: View {
    @Binding var isMenuOpen: Bool
    var body: some View {
        VStack {
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, bottomLeading: 20))
                .fill(.white)
                .frame(width: 220)
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isMenuOpen = false
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(.black)
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Circle()
                                .foregroundStyle(.black)
                                .frame(width: 60, height: 60)
                            VStack {
                                HStack {
                                    Text("김영준")
                                    Text("201911111")
                                }
                                Text("컴퓨터과학과")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("전체 시간표 보기")
                        }
                        
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    TimeTableMenuView(isMenuOpen: .constant(true))
}
