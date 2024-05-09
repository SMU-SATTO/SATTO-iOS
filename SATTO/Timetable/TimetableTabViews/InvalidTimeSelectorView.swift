//
//  InvalidTimeSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 불가능한 시간대 선택
struct InvalidTimeSelectorView: View {
    var cellWidth: CGFloat = 45
    var cellHeight: CGFloat = 30
    var cellWidthSpacing: CGFloat = 0.5
    var cellHeightSpacing: CGFloat = 0.5
    
    var lineWidth: CGFloat = 1
    
    let timeSlots = ["8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00"]
    
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    var weekdayNum = 7
    var timeCellNum = 13
    
    var numSubviews = 91
    
    var minTime = 8
    var maxTime = 22
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var isFirstUsing = true
    
    var rectangles = Rectangles()
  
    var body: some View {
        ZStack {
            VStack {
                Text("불가능한 시간대가 있으면\n선택해 주세요.")
                    .font(.sb18)
                    .lineSpacing(5)
                    .frame(width: 320, alignment: .topLeading)
                
                let subviews = (0..<numSubviews).map { i in
                    TimeCellRectangle(selectedSubviews: $selectedSubviews, index: i)
                }
                HStack {
                    /// 왼쪽 시간대 설정
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
                            //MARK: - 가로 설정
                            columns: [GridItem](repeating: GridItem(spacing: 0), count: weekdayNum),
                            spacing: 0,
                            content: {
                                ForEach(0 ..< subviews.count, id: \.self) { i in
                                    //                                let weekdayIndex = i % weekdayNum // 요일 인덱스
                                    //                                let timeIndex = i / weekdayNum + minTime // 시간대 인덱스 (시작 시간에 따라 증가)
                                    //                                let text = "\(weekdays[weekdayIndex])\(timeIndex)"
                                    subviews[i]
                                        .frame(width: cellWidth, height: cellHeight)
                                        .background() {
                                            GeometryReader { gp -> Color in
                                                rectangles.content[i] = gp.frame(in: .named("container"))
                                                return Color.clear
                                            }
                                        }
                                    //spacing 동작이 가운데부터 뜯어서 padding으로 구현
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
                            // 그리드 선
                            GeometryReader { proxy in
                                Path { path in
                                    let width = proxy.size.width
                                    let height = proxy.size.height
                                    let cellWidth = width / CGFloat(weekdayNum)
                                    let cellHeight = height / CGFloat(numSubviews / weekdayNum)
                                    //세로
                                    for i in 0...weekdayNum {
                                        let x = CGFloat(i) * cellWidth
                                        path.move(to: CGPoint(x: x, y: 0 - cellHeightSpacing / 2))
                                        path.addLine(to: CGPoint(x: x, y: height + cellHeightSpacing / 2))
                                    }
                                    //가로
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
        .popup(isPresented: $isFirstUsing, view: {
            if selectedIndexesText.split(separator: " ").count > 30 {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 300)
                    .overlay(
                        VStack(spacing: 30) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.yellow)
                                
                            Text("불가능한 시간대가 많으면\n원활한 시간표 생성이 어려울 수 있어요.")
                                .font(.sb16)
                                .lineSpacing(5)
                                .multilineTextAlignment(.center)
                            Button(action: {
                                isFirstUsing = false
                            }) {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.blue)
                                    .frame(width: 250, height: 40)
                                    .overlay(
                                        Text("확인했어요")
                                            .font(.sb14)
                                            .foregroundStyle(.white)
                                    )
                            }
                        }
                    )
            }
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        })
    }
    
    // 선택된 셀의 인덱스를 기반으로 요일과 시간을 계산하여 텍스트로 반환하는 계산된 속성
    private var selectedIndexesText: String {
        let selectedIndexes = selectedSubviews.map { i in
            let weekdayIndex = i % weekdayNum // 요일 인덱스
            ///아래의 1을 minTime으로 바꾸면 1교시가 월8로 표시됨
            let timeIndex = i / weekdayNum + 0 // 시간대 인덱스 (시작 시간에 따라 증가)
            return (weekdayIndex, timeIndex) // 튜플로 반환
        }
        let sortedIndexes = selectedIndexes.sorted { $0.0 == $1.0 ? $0.1 < $1.1 : $0.0 < $1.0 } // 요일로 먼저 정렬하고, 시간으로 정렬
        return sortedIndexes.map { "\(weekdays[$0.0])\($0.1)" }.joined(separator: " ")
    }

    
    private var dragSelect: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                // 현재 접근한 요소의 인덱스를 찾습니다.
                guard let index = findSubviewIndex(at: value.location) else {
                    return
                }
                // 이미 접근한 요소라면 무시합니다.
                guard !self.alreadySelectedSubviews.contains(index) else {
                    return
                }
                // 접근한 요소를 추적합니다.
                self.alreadySelectedSubviews.insert(index)
                // 선택된 뷰를 업데이트합니다.
                updateSelectedViews(in: value.location)
            }
            .onEnded { _ in
                // 드래그가 종료되면 추적된 요소를 초기화합니다.
                self.alreadySelectedSubviews.removeAll()
            }
    }

    // 드래그된 지점에 해당하는 뷰의 인덱스를 반환하는 함수
    private func findSubviewIndex(at point: CGPoint) -> Int? {
        for i in 0 ..< numSubviews {
            if let rect = rectangles.content[i], rect.contains(point) {
                return i
            }
        }
        return nil
    }
    
    private func updateSelectedViews(in point: CGPoint) {
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

struct TimeCellRectangle: View {
    @Binding var selectedSubviews: Set<Int>
    let index: Int
    
    var body: some View {
        Rectangle()
            .foregroundStyle(selectedSubviews.contains(index) ? .gray200 : .white)
    }
}

/// A map `[Int : CGRect]` without the nasty copy-on-assignment behavior.
class Rectangles {
    var content = [Int : CGRect]()
}

#Preview {
    InvalidTimeSelectorView()
}
