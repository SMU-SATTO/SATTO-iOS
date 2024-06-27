//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

struct FinalTimetableSelectorView: View {
    @Binding var showingPopup: Bool

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("좌우로 스크롤해 \n원하는 시간표를 골라보세요!")
                    .font(.sb16)
                TimetableView(timetableBaseArray: [])
                    .onTapGesture {
                        showingPopup.toggle()
                    }
            }
        }
    }
}

struct FinalSelectPopupView: View {
    @Binding var finalSelectPopup: Bool
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 600)
                .foregroundStyle(Color.popupBackground)
                .overlay(
                    VStack(spacing: 0) {
                        TimetableView(timetableBaseArray: [])
                            .padding(EdgeInsets(top: -45, leading: 15, bottom: 0, trailing: 15))
                        Text("이 시간표를 이번 학기 시간표로\n결정하시겠어요?")
                            .font(.sb16)
                            .foregroundStyle(Color.blackWhite200)
                            .multilineTextAlignment(.center)
                            .padding(.top, -40)
                        
                        Button(action: {
                            //TODO: - API
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.buttonBlue)
                                .frame(height: 40)
                                .padding(.horizontal, 30)
                                .overlay(
                                    Text("네, 결정했어요")
                                        .font(.sb14)
                                        .foregroundStyle(.white)
                                )
                                .padding(.top, 10)
                        }
                        
                        Button(action: {
                            finalSelectPopup = false
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.clear)
                                .frame(height: 40)
                                .padding(.horizontal, 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.buttonBlue, lineWidth: 1.5)
                                        .padding(.horizontal, 30)
                                        .overlay(
                                            Text("아니요, 더 둘러볼래요")
                                                .font(.sb14)
                                                .foregroundStyle(Color.buttonBlue)
                                        )
                                )
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                        }
                    }
                )
        }
    }
}

#Preview {
    FinalTimetableSelectorView(showingPopup: .constant(false))
//    FinalSelectPopupView(finalSelectPopup: .constant(true))
        .preferredColorScheme(.dark)
}
