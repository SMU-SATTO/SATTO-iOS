//
//  TimetableOptionView.swift
//  SATTO
//
//  Created by 김영준 on 3/16/24.
//

import SwiftUI

struct TimetableOptionView: View {
    @Binding var stackPath: [Route]
    
    @State private var isAutoSelected = false
    @State private var isCustomSelected = false
    
    var body: some View {
        VStack {
            Text("시간표 생성 방식을 선택해주세요")
                .font(.sb18)
            
            VStack(spacing: 20) {
                optionButton(imageName: "Auto", title: "자동으로 생성하기", isSelected: $isAutoSelected) {
                    isAutoSelected = true
                    isCustomSelected = false
                }
                
                optionButton(imageName: "Custom", title: "커스텀 생성하기", isSelected: $isCustomSelected) {
                    isCustomSelected = true
                    isAutoSelected = false
                }
                Button(action: {
                    if isAutoSelected {
                        stackPath.append(Route.timetableMake)
                    }
                    else if isCustomSelected {
                        stackPath.append(Route.timetableCustom)
                    }
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 150, height: 50)
                        .overlay(
                            Text("다음으로")
                                .font(.sb18)
                                .foregroundStyle(.white)
                        )
                }
                .disabled(isAutoSelected == false && isCustomSelected == false)
            }
            .padding(.top, 50)
        }
    }
    
    @ViewBuilder
    private func optionButton(imageName: String, title: String, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 240, height: 180)
                .foregroundStyle(isSelected.wrappedValue ? Color(red: 0.96, green: 0.98, blue: 1) : .gray100)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 1)
                        .stroke(isSelected.wrappedValue ? .blue1 : .gray200, lineWidth: 1.3)
                        .overlay {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                Text(title)
                                    .font(isSelected.wrappedValue ? .sb14 : .m14)
                                    .foregroundStyle(isSelected.wrappedValue ? Color(red: 0.28, green: 0.18, blue: 0.89) : Color(red: 0.45, green: 0.47, blue: 0.5))
                            }
                        }
                )
        }
    }
}

#Preview {
    TimetableOptionView(stackPath: .constant([.timetableMake]))
}
