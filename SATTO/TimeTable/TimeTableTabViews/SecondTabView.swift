//
//  SecondTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 필수로 들어야 할 과목 선택
struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("이번 학기에 필수로 들어야 할\n과목을 선택해 주세요.")
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .lineSpacing(5)
                .frame(width: 320, alignment: .topLeading)
            Text("ex) 재수강, 교양필수, 전공필수")
                .font(Font.custom("Pretendard", size: 12))
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                .frame(width: 320, alignment: .topLeading)
                .padding(.top, 5)
        }
    }
}

#Preview {
    SecondTabView()
}
