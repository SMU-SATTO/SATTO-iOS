//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import SwiftUI

/// 학점 최대치 넘어가면 선택 못하게 해야하나? ex) 18학점 최대인데 18학점 이상 선택하는 경우의 수
/// 미리 시간대 선택하고 이전으로 돌아가서 수업 선택하면 중복으로 선택되는 이슈 있음
/// 바텀시트뷰에서 사용 방법 생각해야함
struct TimeSelectorView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    var title: String
    var cellWidth: CGFloat = 45
    var cellHeight: CGFloat = 30
    var cellWidthSpacing: CGFloat = 0.5
    var cellHeightSpacing: CGFloat = 0.5
    var lineWidth: CGFloat = 1
    var minTime: Int = 8
    var maxTime: Int = 22
    var preselectedSlots: [String]
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    private var weekdayNum: Int { weekdays.count }
    private var timeCellNum: Int { maxTime - minTime - 1 }
    private var numSubviews: Int { weekdayNum * timeCellNum }
    
    @State private var rectangles = [Int: CGRect]()
    @Binding var invalidPopup: Bool
    @State private var disposable: Bool = true
    
    var body: some View {
        VStack {
            headerView
            scheduleGrid
            selectedIndexesView
        }
        .onChange(of: selectedIndexesText) { newValue in
            if newValue.split(separator: " ").count > 30 && disposable{
                invalidPopup = true
                disposable = false
            }
            selectedValues.invalidTimes = newValue
        }
    }
    
    private var preselectedIndexes: Set<Int> {
        Set(preselectedSlots.compactMap { slot in
            guard let weekdayIndex = weekdays.firstIndex(of: String(slot.prefix(1))),
                  let timeIndex = Int(slot.dropFirst(1))
            else { return nil }
            return weekdayIndex + (timeIndex * weekdayNum)
        })
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.sb18)
                .frame(width: 320, alignment: .topLeading)
            Text("드래그로 선택할 수 있어요.")
                .font(.sb12)
                .foregroundColor(.gray)
                .frame(width: 320, alignment: .topLeading)
        }
    }
    
    private var scheduleGrid: some View {
        HStack {
            timeColumn
            gridContent
        }
    }
    
    private var timeColumn: some View {
        VStack(spacing: 0) {
            ForEach(minTime..<maxTime, id: \.self) { hour in
                Text("\(hour):00")
                    .font(.m12)
                    .frame(width: cellWidth, height: cellHeight)
            }
        }
        .padding(.top, 30)
    }
    
    private var gridContent: some View {
        VStack {
            weekdayHeader
            timeSlotsGrid
        }
    }
    
    private var weekdayHeader: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: weekdayNum)) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.m12)
                    .padding(.leading, cellWidthSpacing)
                    .padding(.top, cellHeightSpacing)
            }
        }
        .frame(width: totalGridWidth, height: 20)
    }
    
    private var timeSlotsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: weekdayNum), spacing: 0) {
            ForEach(0..<numSubviews, id: \.self) { i in
                TimeCellRectangle(
                    selectedSubviews: $selectedSubviews,
                    preselectedIndexes: preselectedIndexes,
                    index: i
                )
                .frame(width: cellWidth, height: cellHeight)
                .background(geometryReader(for: i))
                .padding(.leading, cellWidthSpacing)
                .padding(.top, cellHeightSpacing)
            }
        }
        .frame(width: totalGridWidth, height: totalGridHeight)
        .coordinateSpace(name: "container")
        .gesture(dragSelect)
        .background(gridLines)
    }
    
    private var totalGridWidth: CGFloat {
        cellWidth * CGFloat(weekdayNum) + cellWidthSpacing * (CGFloat(weekdayNum) + 2)
    }
    
    private var totalGridHeight: CGFloat {
        cellHeight * CGFloat(timeCellNum) + cellHeightSpacing * CGFloat(timeCellNum)
    }
    
    private var gridLines: some View {
        GeometryReader { proxy in
            Path { path in
                drawGridLines(path: &path, width: proxy.size.width, height: proxy.size.height)
            }
            .stroke(Color.black, lineWidth: lineWidth)
        }
    }
    
    private func drawGridLines(path: inout Path, width: CGFloat, height: CGFloat) {
        let cellWidth = width / CGFloat(weekdayNum)
        let cellHeight = height / CGFloat(timeCellNum)
        
        for i in 0...weekdayNum {
            let x = CGFloat(i) * cellWidth
            path.move(to: CGPoint(x: x, y: -cellHeightSpacing / 2))
            path.addLine(to: CGPoint(x: x, y: height + cellHeightSpacing / 2))
        }
        
        for i in 0...timeCellNum {
            let y = CGFloat(i) * cellHeight
            path.move(to: CGPoint(x: -cellWidthSpacing / 2, y: y))
            path.addLine(to: CGPoint(x: width + cellWidthSpacing / 2, y: y))
        }
    }
    
    private func geometryReader(for index: Int) -> some View {
        GeometryReader { gp in
            Color.clear.onAppear {
                rectangles[index] = gp.frame(in: .named("container"))
            }
        }
    }
    
    private var selectedIndexesView: some View {
        VStack {
            Text("선택된 불가능한 시간대: \(selectedIndexesText)")
        }
    }
    
    private var selectedIndexesText: String {
        let selectedIndexes = selectedSubviews.map { index in
            let weekdayIndex = index % weekdayNum
            let timeIndex = index / weekdayNum
            return (weekdayIndex, timeIndex)
        }
        
        let sortedIndexes = selectedIndexes.sorted { $0.0 == $1.0 ? $0.1 < $1.1 : $0.0 < $1.0 }
        return sortedIndexes.map { "\(weekdays[$0.0])\($0.1)" }.joined(separator: " ")
    }
    
    private var dragSelect: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard let index = findSubviewIndex(at: value.location) else { return }
                guard !alreadySelectedSubviews.contains(index) else { return }
                guard !preselectedIndexes.contains(index) else { return }
                alreadySelectedSubviews.insert(index)
                updateSelectedViews(at: value.location)
            }
            .onEnded { _ in
                alreadySelectedSubviews.removeAll()
            }
    }
    
    private func findSubviewIndex(at point: CGPoint) -> Int? {
        rectangles.first { $0.value.contains(point) }?.key
    }
    
    private func updateSelectedViews(at point: CGPoint) {
        for (index, rect) in rectangles where rect.contains(point) {
            if selectedSubviews.contains(index) {
                selectedSubviews.remove(index)
            } else {
                selectedSubviews.insert(index)
            }
        }
    }
}

struct TimeCellRectangle: View {
    @Binding var selectedSubviews: Set<Int>
    var preselectedIndexes: Set<Int>
    let index: Int
    
    var body: some View {
        Rectangle()
            .foregroundColor(preselectedIndexes.contains(index) ? .gray : selectedSubviews.contains(index) ? .gray200 : .white)
            .overlay(
                preselectedIndexes.contains(index) ? Color.black.opacity(0.3) : Color.clear
            )
    }
}
