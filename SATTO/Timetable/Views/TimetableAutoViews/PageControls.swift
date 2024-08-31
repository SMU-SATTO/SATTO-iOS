//
//  PageControls.swift
//  SATTO
//
//  Created by yeongjoon on 7/6/24.
//

import SwiftUI

struct CustomPageControl: View {
    let totalIndex: Int
    let selectedIndex: Int
    
    @Namespace private var animation
    
    let rectangleHeight: CGFloat = 7
    let rectangleRadius: CGFloat = 5
    
    var body: some View {
        HStack {
            ForEach(0..<totalIndex, id: \.self) { index in
                if selectedIndex > index {
                    // 지나온 페이지
                    Rectangle()
                        .foregroundStyle(Color.pagecontrolPrevious)
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                } else if selectedIndex == index {
                    // 선택된 페이지
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                        .overlay {
                            Rectangle()
                                .foregroundStyle(Color.pagecontrolCurrent)
                                .frame(height: rectangleHeight)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: rectangleRadius)
                                )
                                .matchedGeometryEffect(id: "IndicatorAnimationId", in: animation)
                        }
                } else {
                    // 나머지 페이지
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                }
            }
        }
    }
}
