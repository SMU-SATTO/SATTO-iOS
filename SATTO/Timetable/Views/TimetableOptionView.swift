//
//  TimetableOptionView.swift
//  SATTO
//
//  Created by 김영준 on 3/16/24.
//

import SwiftUI

struct TimetableOptionView: View {
    @Binding var stackPath: [TimetableRoute]
    @ObservedObject var constraintsViewModel: ConstraintsViewModel
    
    @State private var isAutoSelected = false
    @State private var isCustomSelected = false
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                Text("시간표 생성 방식을 선택해 주세요.")
                    .font(.sb18)
                
                VStack(spacing: 20) {
                    optionButton(imageName: "Auto", title: "자동으로 생성하기", isSelected: $isAutoSelected) {
                        isAutoSelected = true
                        isCustomSelected = false
                        constraintsViewModel.clear()
                    }
                    
                    optionButton(imageName: "Custom", title: "커스텀 생성하기", isSelected: $isCustomSelected) {
                        isCustomSelected = true
                        isAutoSelected = false
                    }
                    Button(action: {
                        if isAutoSelected {
                            stackPath.append(TimetableRoute.timetableAuto)
                        }
                        else if isCustomSelected {
                            stackPath.append(TimetableRoute.timetableCustom)
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(!isAutoSelected && !isCustomSelected ? Color.gray: Color.buttonBlue)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        stackPath.removeLast()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("뒤로가기")
                                .font(.sb16)
                        }
                        .foregroundStyle(Color.blackWhite)
                    }
                }
            }
        }
    }
    
    private func optionButton(imageName: String, title: String, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 20)
                .aspectRatio(4/3, contentMode: .fit)
                .padding(.horizontal, 60)
                .foregroundStyle(isSelected.wrappedValue ? Color.optionSelected : Color.optionUnselected)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 1)
                        .stroke(isSelected.wrappedValue ? Color.optionStrokeSelected : Color.optionStrokeUnselected, lineWidth: 1.3)
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(.horizontal, 60)
                                Text(title)
                                    .font(isSelected.wrappedValue ? .sb14 : .m14)
                                    .foregroundStyle(isSelected.wrappedValue ? Color.optionStrokeSelected : Color.blackWhite)
                            }
                        }
                )
        }
    }
}

//#Preview {
//    TimetableOptionView(stackPath: .constant([.timetableAuto]), constraintViewModel: .preview)
//        .preferredColorScheme(.dark)
//}
