//
//  MajorCombinationSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 가능한 전공 조합 선택하는 페이지
struct MajorCombinationSelectorView: View {
    var body: some View {
        VStack {
            Text("님을 위한\n101개의 시간표가 만들어졌어요!")
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(Color.gray800)
                .frame(alignment: .topLeading)
            
            Text("님을 위한\n101개의 시간표가 만들어졌어요!")
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(Color.gray800)
                .frame(alignment: .topLeading)
        }
        
    }
}

#Preview {
    MajorCombinationSelectorView()
}
