//
//  SeventhTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

struct SeventhTabView: View {
    @State var showingPopup = false

    var body: some View {
        Text("OpenPopupView")
            .onTapGesture {
                showingPopup.toggle()
            }
            .popup(isPresented: $showingPopup) {
                Text("The popup")
                    .frame(width: 300, height: 450)
                    .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                    .cornerRadius(20.0)
            } customize: {
                $0
//                    .type(.floater())
//                    .position(.bottom) // 팝업 뷰가 위치할 방향
                    .appearFrom(.bottom) //튀어나올 위치
                    .animation(.spring()) //튀어나오는 애니메이션
                    .closeOnTapOutside(false) //밖에 클릭하면 close될건지?
                    .backgroundColor(.black.opacity(0.5))
                    
            }
    }
}

#Preview {
    SeventhTabView()
}
