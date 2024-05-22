//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView



struct FinalTimetableSelectorView: View {
    @State var showingPopup = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("좌우로 스크롤해 \n원하는 시간표를 골라보세요!")
                Text("OpenPopupView")
                    .onTapGesture {
                        showingPopup.toggle()
                    }
            }
        }
        .popup(isPresented: $showingPopup) {
            selectPopup()
        } customize: {
            $0
            //                    .type(.floater())
            //                    .position(.bottom) // 팝업 뷰가 위치할 방향
                .appearFrom(.bottom) //튀어나올 위치
                .animation(.spring()) //튀어나오는 애니메이션
                .closeOnTapOutside(false) //밖에 클릭하면 close될건지?
                .closeOnTap(false) //안에 클릭하면 close될건지?
                .backgroundColor(.black.opacity(0.5))
            
        }
    }
}

struct selectPopup: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 450)
                .foregroundStyle(.white)
                .overlay(
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.blue1)
                            .frame(width: 250, height: 44)
                            .shadow(color: Color(red: 0.96, green: 0.51, blue: 0.16).opacity(0.16), radius: 4, x: 0, y: 4)
                            .overlay(
                                Text("네, 결정했어요")
                                    .foregroundStyle(.white)
                            )
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 44)
                            .shadow(color: Color(red: 0.96, green: 0.51, blue: 0.16).opacity(0.16), radius: 4, x: 0, y: 4)
                    }
                )
        }
    }
}

#Preview {
    FinalTimetableSelectorView()
}
