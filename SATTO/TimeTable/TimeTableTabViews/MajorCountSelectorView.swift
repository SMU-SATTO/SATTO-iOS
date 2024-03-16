//
//  MajorCountSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 전공 개수 선택
struct MajorCountSelectorView: View {
    @ObservedObject var timeTableMainViewModel: TimeTableMainViewModel
    var body: some View {
        VStack {
            Text("이번 학기에 들어야 할\n전공 개수를 선택해 주세요.")
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .lineSpacing(5)
                .frame(width: 320, alignment: .topLeading)
            Text("이전 단계에서 선택한 전공 개수도 포함해 주세요.")
                .font(Font.custom("Pretendard", size: 12))
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                .frame(width: 320, alignment: .topLeading)
                .padding(.top, 5)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                .frame(width: 320, height: 50)
                .overlay {
                    HStack {
                        Button(action: {
                            if (timeTableMainViewModel.value > 0) {
                                timeTableMainViewModel.value -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .padding(.leading, 10)
                        Spacer()
                        Text("\(timeTableMainViewModel.value)")
                        Spacer()
                        Button(action: {
                            if (timeTableMainViewModel.value < 7) {
                                timeTableMainViewModel.value += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .padding(.trailing, 10)
                    }
                }
                .padding(.top, 10)
        }
    }
}

#Preview {
    MajorCountSelectorView(timeTableMainViewModel: TimeTableMainViewModel())
}
