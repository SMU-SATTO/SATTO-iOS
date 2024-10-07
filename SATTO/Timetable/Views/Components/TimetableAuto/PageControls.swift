//
//  PageControls.swift
//  SATTO
//
//  Created by yeongjoon on 7/6/24.
//

import SwiftUI

struct TimetableAutoPageControl: View {
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

struct FinalTimetablePageIndicator: View {
    @Binding var currIndex: Int
    @State var totalIndex: Int
    
    var body: some View {
        VStack {
            pageIndicator
        }
    }
    
    private var pageIndicator: some View {
        GeometryReader { geometry in
            HStack(spacing: 8) { // 간격을 좁게 조정
                ForEach(pageIndicatorIndices(), id: \.self) { index in
                    Circle()
                        .fill(index == currIndex ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                        .scaleEffect(circleScaleEffect(index: index))
                        .animation(.easeInOut, value: currIndex)
                        .onTapGesture {
                            withAnimation {
                                currIndex = index
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .frame(height: 20)
    }
    
    private func circleScaleEffect(index: Int) -> CGFloat {
        let maxIndicators = 9
        let halfMax = maxIndicators / 2
        
        if index == currIndex {
            return 1.0
        } else if (currIndex > halfMax && currIndex < totalIndex - halfMax && index == currIndex - halfMax) || (currIndex > halfMax && currIndex < totalIndex - halfMax - 1 && index == currIndex + halfMax) {
            return 0.6
        } else if (currIndex == halfMax && index == currIndex + halfMax) || (currIndex == totalIndex - halfMax - 1 && index == currIndex - halfMax) {
            return 0.6
        } else {
            return 0.8
        }
    }

    private func pageIndicatorIndices() -> [Int] {
        let maxIndicators = 9
        let halfMax = maxIndicators / 2
        
        if totalIndex <= maxIndicators {
            return Array(0..<totalIndex)
        } else if currIndex <= halfMax {
            return Array(0..<maxIndicators)
        } else if currIndex >= totalIndex - halfMax - 1 {
            return Array((totalIndex - maxIndicators)..<totalIndex)
        } else {
            return Array((currIndex - halfMax)..<(currIndex + halfMax + 1))
        }
    }
}
