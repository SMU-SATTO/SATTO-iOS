//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

//MARK: - 팝업 상위뷰로 넘겨야 백그라운드 색 제대로 변함
struct FinalTimetableSelectorView: View {
    @State var showingPopup = false

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
                .frame(width: 300, height: 600)
                .foregroundStyle(.white)
                .overlay(
                    VStack(spacing: 0) {
                        TimetableView(timetableBaseArray: [])
                            .padding(.horizontal, 30)
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color("blue_7"))
                            .frame(height: 40)
                            .padding(.horizontal, 30)
                            .overlay(
                                Text("네, 결정했어요")
                                    .font(.sb14)
                                    .foregroundStyle(.white)
                            )
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(height: 40)
                            .padding(.horizontal, 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("blue_7"), lineWidth: 1.5)
                                    .padding(.horizontal, 30)
                                    .overlay(
                                        Text("아니요, 더 둘러볼래요")
                                            .font(.sb14)
                                            .foregroundStyle(Color("blue_7"))
                                    )
                            )
                            .padding([.top, .bottom], 20)
                    }
                )
        }
    }
}

#Preview {
    FinalTimetableSelectorView()
}
