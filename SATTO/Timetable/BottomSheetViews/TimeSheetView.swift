//
//  TimeSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct TimeSheetView: View {
    var cellWidth: CGFloat = 45
    var cellHeight: CGFloat = 30
    var cellWidthSpacing: CGFloat = 0.5
    var cellHeightSpacing: CGFloat = 0.5
    
    var lineWidth: CGFloat = 1
    
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    var weekdayNum = 7
    var timeCellNum = 13
    
    var numSubviews = 91
    
    var minTime = 8
    var maxTime = 22
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    var rectangles = Rectangles()
  
    var body: some View {
        TimeSelectorView(title: "보고싶은 시간대를 선택해주세요.", cellWidth: cellWidth, cellHeight: cellHeight, cellWidthSpacing: cellWidthSpacing, cellHeightSpacing: cellHeightSpacing, lineWidth: lineWidth, numSubviews: numSubviews, minTime: minTime, maxTime: maxTime, weekdayNum: weekdayNum, timeCellNum: timeCellNum, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews)
    }
}

#Preview {
    TimeSheetView()
}
