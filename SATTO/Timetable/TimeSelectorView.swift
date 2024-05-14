//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import SwiftUI

struct InvalidTimeSelectorView2: View {
    var cellWidth: CGFloat = 45
    var cellHeight: CGFloat = 30
    var cellWidthSpacing: CGFloat = 0.5
    var cellHeightSpacing: CGFloat = 0.5
    var lineWidth: CGFloat = 1
    
    var weekdayNum = 7
    var timeCellNum = 13
    
    let numSubviews = 91
    
    var minTime = 8
    var maxTime = 22
    
    @State var selectedSubviews = Set<Int>()
    @State var alreadySelectedSubviews = Set<Int>()
    @Binding var invalidPopup: Bool
    
    var body: some View {
        VStack {
            TimeSelectorView(title: "테스트용", cellWidth: cellWidth, cellHeight: cellHeight, cellWidthSpacing: cellWidthSpacing, cellHeightSpacing: cellHeightSpacing, lineWidth: lineWidth, numSubviews: numSubviews, minTime: minTime, maxTime: maxTime, weekdayNum: weekdayNum, timeCellNum: timeCellNum, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews)
        }
//        .onChange(of: selectedIndexesText) { newValue in
//            if newValue.split(separator: " ").count > 30 {
//                invalidPopup = true
//            }
//        }
    }
}

#Preview {
    InvalidTimeSelectorView2(invalidPopup: .constant(false))
}

//MARK: - 전부 파라미터로 굳이 받지 말고 나중에 요일 고정되면 let으로 고정시키기
struct TimeSelectorView: View {
    var title: String
    var cellWidth: CGFloat
    var cellHeight: CGFloat
    var cellWidthSpacing: CGFloat
    var cellHeightSpacing: CGFloat
    var lineWidth: CGFloat
    var numSubviews: Int
    var minTime: Int
    var maxTime: Int
    var weekdayNum: Int
    var timeCellNum: Int
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    var rectangles = Rectangles()
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 5) {
                    Text(title)
                        .font(.sb18)
                        .frame(width: 320, alignment: .topLeading)
                    Text("드래그로 선택할 수 있어요.")
                        .font(.sb12)
                        .foregroundStyle(.gray500)
                        .frame(width: 320, alignment: .topLeading)
                }
                
                let subviews = (0..<numSubviews).map { i in
                    TimeCellRectangle(selectedSubviews: $selectedSubviews, index: i)
                }
                HStack {
                    VStack(spacing: 0) {
                        ForEach((minTime..<maxTime), id: \.self) { hour in
                            Text("\(hour):00")
                                .font(.m12)
                                .frame(width: cellWidth, height: cellHeight)
                        }
                    }
                    .padding(.top, 30)
                    VStack {
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(spacing: 0), count: weekdayNum),
                            content: {
                                ForEach(0 ..< weekdayNum, id: \.self) { i in
                                    Text(weekdays[i])
                                        .font(.m12)
                                        .padding(.leading, cellWidthSpacing)
                                        .padding(.top, cellHeightSpacing)
                                }
                            }
                        )
                        .frame(width: cellWidth * CGFloat(weekdayNum) + cellWidthSpacing * (CGFloat(weekdayNum) + 2),
                               height: 20)
                        
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(spacing: 0), count: weekdayNum),
                            spacing: 0,
                            content: {
                                ForEach(0 ..< subviews.count, id: \.self) { i in
                                    subviews[i]
                                        .frame(width: cellWidth, height: cellHeight)
                                        .background() {
                                            GeometryReader { gp -> Color in
                                                rectangles.content[i] = gp.frame(in: .named("container"))
                                                return Color.clear
                                            }
                                        }
                                        .padding(.leading, cellWidthSpacing)
                                        .padding(.top, cellHeightSpacing)
                                }
                            }
                        )
                        .frame(width: cellWidth * CGFloat(weekdayNum) + cellWidthSpacing * (CGFloat(weekdayNum) + 2),
                               height: cellHeight * CGFloat(timeCellNum) + cellHeightSpacing * CGFloat(timeCellNum))
                        .coordinateSpace(name: "container")
                        .gesture(dragSelect)
                        .background(
                            GeometryReader { proxy in
                                Path { path in
                                    let width = proxy.size.width
                                    let height = proxy.size.height
                                    let cellWidth = width / CGFloat(weekdayNum)
                                    let cellHeight = height / CGFloat(numSubviews / weekdayNum)
                                    for i in 0...weekdayNum {
                                        let x = CGFloat(i) * cellWidth
                                        path.move(to: CGPoint(x: x, y: 0 - cellHeightSpacing / 2))
                                        path.addLine(to: CGPoint(x: x, y: height + cellHeightSpacing / 2))
                                    }
                                    for i in 0...numSubviews / weekdayNum {
                                        let y = CGFloat(i) * cellHeight
                                        path.move(to: CGPoint(x: 0 - cellWidthSpacing / 2, y: y))
                                        path.addLine(to: CGPoint(x: width + cellWidthSpacing / 2, y: y))
                                    }
                                }
                                .stroke(Color.black, lineWidth: lineWidth)
                            }
                        )
                    }
                }
                VStack {
                    Text("선택된 index 출력: \(selectedIndexesText)")
                }
            }
        }
    }

    var selectedIndexesText: String {
        let selectedIndexes = selectedSubviews.map { i in
            let weekdayIndex = i % weekdayNum
            let timeIndex = i / weekdayNum + 0
            return (weekdayIndex, timeIndex)
        }
        let sortedIndexes = selectedIndexes.sorted { $0.0 == $1.0 ? $0.1 < $1.1 : $0.0 < $1.0 }
        return sortedIndexes.map { "\(weekdays[$0.0])\($0.1)" }.joined(separator: " ")
    }

    var dragSelect: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard let index = findSubviewIndex(at: value.location) else {
                    return
                }
                guard !self.alreadySelectedSubviews.contains(index) else {
                    return
                }
                self.alreadySelectedSubviews.insert(index)
                updateSelectedViews(in: value.location)
            }
            .onEnded { _ in
                self.alreadySelectedSubviews.removeAll()
            }
    }

    func findSubviewIndex(at point: CGPoint) -> Int? {
        for i in 0 ..< numSubviews {
            if let rect = rectangles.content[i], rect.contains(point) {
                return i
            }
        }
        return nil
    }

    func updateSelectedViews(in point: CGPoint) {
        for i in 0 ..< numSubviews {
            if let rect = rectangles.content[i], rect.contains(point) {
                if selectedSubviews.contains(i) {
                    selectedSubviews.remove(i)
                } else {
                    selectedSubviews.insert(i)
                }
            }
        }
    }
}
