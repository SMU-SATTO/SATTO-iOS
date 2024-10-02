//
//  TimeSelectorView.swift
//  SATTO
//
//  Created by yeongjoon on 10/1/24.
//

import SwiftUI

struct TimeSelectorView<VM>: View where VM: TimeSelectorViewModelProtocol {
    @ObservedObject var viewModel: VM
    
    var config = TimetableConfiguration.timeSelectConfig
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width - config.timebar.width) / CGFloat(config.weeks.count)
            let cellHeight = (geometry.size.height - config.weekbar.height) / CGFloat(config.time.endAt.hour - config.time.startAt.hour)
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: config.timebar.width)
                        WeekBar(weekdays: config.weeks, totalWidth: config.weekbar.width, cellWidth: cellWidth, height: config.weekbar.height)
                    }
                    HStack(spacing: 0) {
                        TimeBar(startTime: config.time.startAt.hour, endTime: config.time.endAt.hour, totalHeight: config.timebar.height, cellHeight: cellHeight, width: config.timebar.width)
                        SelectableTimeBlock(viewModel: viewModel, config: config, cellWidth: cellWidth, cellHeight: cellHeight)
                    }
                }
                TimetableGrid(weekCount: config.weeks.count, hourCount: config.time.endAt.hour - config.time.startAt.hour, config: config)
                    .stroke(Color(UIColor.quaternaryLabel.withAlphaComponent(0.1)))
            }
        }
        .frame(minWidth: 210, minHeight: 300)
    }
}

struct SelectableTimeBlock<VM>: View where VM: TimeSelectorViewModelProtocol {
    @ObservedObject var viewModel: VM
    let config: TimetableConfiguration
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<config.time.endAt.hour - config.time.startAt.hour, id: \.self) { time in
                HStack(spacing: 0) {
                    ForEach(0..<config.weeks.count, id: \.self) { week in
                        let weekTimeString = "\(config.weeks[week].shortSymbolKor)\(time)"
                        Rectangle()
                            .foregroundStyle(viewModel.preSelectedBlocks.contains(weekTimeString)
                                             ? .red
                                             : viewModel.selectedBlocks.contains(weekTimeString)
                                             ? .timeselectorCellSelected
                                             : .timeselectorCellUnselected)
                            .frame(width: cellWidth, height: cellHeight)
                    }
                }
            }
        }
        .gesture(dragSelect)
    }
    
    private var dragSelect: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let dragLocation = value.location
                if let weekTimeString = findBlockWeekTimeString(at: dragLocation) {
                    updateSelectedViews(for: weekTimeString)
                }
            }
            .onEnded { _ in
                viewModel.tempDragBlocks.removeAll()
            }
    }
    
    private func findBlockWeekTimeString(at location: CGPoint) -> String? {
        let week = Int(location.x / cellWidth)
        let time = Int(location.y / cellHeight)
        
        guard week >= 0 && week < config.weeks.count else { return nil }
        guard time >= 0 && time < config.time.endAt.hour - config.time.startAt.hour else { return nil }
        
        return "\(config.weeks[week].shortSymbolKor)\(time)"
    }
    
    private func updateSelectedViews(for weekTimeString: String) {
        guard !viewModel.preSelectedBlocks.contains(weekTimeString),
              !viewModel.tempDragBlocks.contains(weekTimeString) else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.tempDragBlocks.insert(weekTimeString)
            
            if viewModel.selectedBlocks.contains(weekTimeString) {
                viewModel.selectedBlocks.remove(weekTimeString)
            } else {
                viewModel.selectedBlocks.insert(weekTimeString)
            }
        }
    }
}


#Preview {
    TimeSelectorView(viewModel: TimeSelectorViewModel())
        .aspectRatio(7/10, contentMode: .fit)
        .frame(maxWidth: 350, maxHeight: 500)
}
