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
            
            VStack(spacing: 20) {
                optionButton(imageName: "Auto", title: "자동으로 생성하기", isSelected: $isAutoSelected) {
                    isAutoSelected.toggle()
                    if isAutoSelected {
                        isCustomSelected = false
                    }
                }
                
                optionButton(imageName: "Custom", title: "커스텀 생성하기", isSelected: $isCustomSelected) {
                    isCustomSelected.toggle()
                    if isCustomSelected {
                        isAutoSelected = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func optionButton(imageName: String, title: String, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 238, height: 163)
                .foregroundStyle(isSelected.wrappedValue ? .blue1 : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 2)
                        .stroke(.blue1, lineWidth: 1.5)
                        .overlay {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                Text(title)
                                    .font(isSelected.wrappedValue ? .sb14 : .m14)
                                    .foregroundStyle(Color(red: 0.28, green: 0.18, blue: 0.89))
                            }
                        }
                )
        }
    }
}

#Preview {
    TimeTableOptionView()
}
