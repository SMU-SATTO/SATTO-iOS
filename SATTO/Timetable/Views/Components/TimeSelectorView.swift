//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import SwiftUI

struct TimeSelectorView<VM>: View where VM: TimeSelectorViewModelProtocol{
    @ObservedObject var viewModel: VM
    
    var title: String = ""
    var cellWidth: CGFloat = 40
    var cellHeight: CGFloat = 30
    var lineWidth: CGFloat = 1
    var minTime: Int = 8
    var maxTime: Int = 21
    var preselectedSlots: [String] = []
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    private var weekdayNum: Int { weekdays.count }
    
    @Binding var invalidPopup: Bool
    @State private var disposable: Bool = true
    
    var body: some View {
        VStack {
            HeaderView(title: title)
            TimeGridView(
                cellWidth: cellWidth,
                cellHeight: cellHeight,
                lineWidth: lineWidth,
                minTime: minTime,
                maxTime: maxTime,
                weekdays: weekdays,
                preselectedIndexes: preselectedIndexes,
                selectedSubviews: $selectedSubviews,
                alreadySelectedSubviews: $alreadySelectedSubviews,
                invalidPopup: $invalidPopup,
                disposable: $invalidPopup
            )
//            selectedIndexesView
        }
        .onAppear {
            removePreselectedIndexes()
        }
        .onChange(of: selectedIndexesText) { newValue in
            if newValue.split(separator: " ").count > 30 && disposable{
                invalidPopup = true
                disposable = false
            }
            viewModel.selectedTimes = newValue
        }
    }
    
    private func removePreselectedIndexes() {
        for index in preselectedIndexes {
            selectedSubviews.remove(index)
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
}

private struct HeaderView: View {
    var title: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.sb18)
                .frame(width: 320, alignment: .topLeading)
            Text("드래그로 선택할 수 있어요.")
                .font(.sb12)
                .foregroundStyle(.gray)
                .frame(width: 320, alignment: .topLeading)
        }
    }
}

private struct TimeGridView: View {
    var cellWidth: CGFloat
    var cellHeight: CGFloat
    var lineWidth: CGFloat
    var minTime: Int
    var maxTime: Int
    var weekdays: [String]
    var preselectedIndexes: Set<Int>
    var selectedSubviews: Binding<Set<Int>>
    var alreadySelectedSubviews: Binding<Set<Int>>
    @Binding var invalidPopup: Bool
    @State private var rectangles = [Int: CGRect]()
    @Binding var disposable: Bool
    
    var body: some View {
        HStack {
            timeColumn
            gridContent
        }
    }
    
    private var timeColumn: some View {
        VStack(spacing: 0) {
            ForEach(minTime...maxTime, id: \.self) { hour in
                Text("\(hour):00")
                    .font(.m10)
                    .frame(width: cellWidth, height: cellHeight + lineWidth)
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
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: weekdays.count)) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.m12)
            }
        }
        .frame(width: totalGridWidth, height: 20)
    }
    
    private var timeSlotsGrid: some View {
        ZStack {
            gridLines
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: weekdays.count), spacing: lineWidth) {
                ForEach(0..<weekdays.count * (maxTime - minTime), id: \.self) { i in
                    TimeCellRectangle(
                        selectedSubviews: selectedSubviews,
                        preselectedIndexes: preselectedIndexes,
                        index: i
                    )
                    .frame(width: cellWidth, height: cellHeight)
                    .background(geometryReader(for: i))
                }
            }
            .coordinateSpace(name: "container")
            .gesture(dragSelect)
        }
        .frame(width: totalGridWidth, height: totalGridHeight)
    }
    
    private var totalGridWidth: CGFloat {
        cellWidth * CGFloat(weekdays.count) + lineWidth * (CGFloat(weekdays.count))
    }
    
    private var totalGridHeight: CGFloat {
        cellHeight * CGFloat(maxTime - minTime) + lineWidth * CGFloat(maxTime - minTime)
    }
    
    private var gridLines: some View {
        GeometryReader { proxy in
            Path { path in
                drawGridLines(path: &path, width: proxy.size.width, height: proxy.size.height)
            }
            .stroke(Color.blackWhite, lineWidth: lineWidth)
        }
    }
    
    ///선 그리기
    private func drawGridLines(path: inout Path, width: CGFloat, height: CGFloat) {
        /// cellWidth: 표 전체 가로 길이 geometryReader로 가져온 뒤 요일 수 만큼 나누기. 즉 세로 선 개수
        let cellWidth = width / CGFloat(weekdays.count)
        /// cellHeight: 표 전체 세로 길이 geometryReader로 가져온 뒤 time 수 만큼 나누기. 즉 가로 선 개수
        let cellHeight = height / CGFloat(maxTime - minTime)
        
        for i in 0...weekdays.count {
            let x = CGFloat(i) * cellWidth
            path.move(to: CGPoint(x: x, y: -lineWidth / 2))
            path.addLine(to: CGPoint(x: x, y: height + lineWidth / 2))
        }
        
        for i in 0...(maxTime - minTime) {
            let y = CGFloat(i) * cellHeight
            path.move(to: CGPoint(x: -lineWidth / 2, y: y))
            path.addLine(to: CGPoint(x: width + lineWidth / 2, y: y))
        }
    }
    
    private func geometryReader(for index: Int) -> some View {
        GeometryReader { gp in
            Color.clear.onAppear {
                rectangles[index] = gp.frame(in: .named("container"))
            }
        }
    }
    
    private var dragSelect: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard let index = findSubviewIndex(at: value.location) else { return }
                guard !alreadySelectedSubviews.wrappedValue.contains(index) else { return }
                guard !preselectedIndexes.contains(index) else { return }
                alreadySelectedSubviews.wrappedValue.insert(index)
                updateSelectedViews(at: value.location)
            }
            .onEnded { _ in
                alreadySelectedSubviews.wrappedValue.removeAll()
            }
    }
    
    private func findSubviewIndex(at point: CGPoint) -> Int? {
        rectangles.first { $0.value.contains(point) }?.key
    }
    
    private func updateSelectedViews(at point: CGPoint) {
        for (index, rect) in rectangles where rect.contains(point) {
            if selectedSubviews.wrappedValue.contains(index) {
                selectedSubviews.wrappedValue.remove(index)
            } else {
                selectedSubviews.wrappedValue.insert(index)
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
            .foregroundStyle(preselectedIndexes.contains(index) ? .gray : selectedSubviews.contains(index) ? Color.timeselectorCellSelected : Color.timeselectorCellUnselected)
            .overlay(
                preselectedIndexes.contains(index) ? Color.timeselectorCellPreselected : Color.clear
            )
    }
}

//#Preview {
//    TimeSelectorView(viewModel: constraintsViewModel(), selectedSubviews: .constant([0, 1, 2, 3, 4, 5, 6, 7, 16, 17, 18]), alreadySelectedSubviews: .constant([]), invalidPopup: .constant(false))
//        .preferredColorScheme(.light)
//}
