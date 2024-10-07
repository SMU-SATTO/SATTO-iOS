//
//  TimetablePopupViews.swift
//  SATTO
//
//  Created by yeongjoon on 7/6/24.
//

import SwiftUI

struct FinishMakingTimetablePopup: View {
    @Binding var isPresented: Bool
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.popupBackground)
                .frame(width: 300, height: 360)
                .overlay(
                    VStack(spacing: 30) {
                        Image(systemName: "light.beacon.max")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Text("시간표 생성을 마치고\n등록된 시간표 목록을 보러가시겠어요?")
                            .font(.sb16)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                        VStack {
                            Button(action: {
                                action()
                                isPresented = false
                            }) {
                                Text("시간표 목록 보러 가기")
                                    .font(.sb14)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.buttonBlue)
                            )
                            .frame(height: 40)
                            Button(action: {
                                isPresented = false
                            }) {
                                Text("시간표 등록 더하기")
                                    .font(.sb14)
                                    .foregroundStyle(Color.buttonBlue)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 2)
                                            .stroke(Color.buttonBlue, lineWidth: 1.5)
                                    )
                            )
                            .frame(height: 40)
                        }
                        .padding(.horizontal, 15)
                    }
                )
        }
    }
}


