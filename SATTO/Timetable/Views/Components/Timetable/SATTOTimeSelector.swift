//
//  SATTOTimeSelector.swift
//  SATTO
//
//  Created by yeongjoon on 10/1/24.
//

import SwiftUI

struct SATTOTimeSelector<VM>: View where VM: TimeSelectorViewModelProtocol {
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
                SATTOGrid(weekCount: config.weeks.count, hourCount: config.time.endAt.hour - config.time.startAt.hour, config: config)
                    .stroke(Color(UIColor.quaternaryLabel.withAlphaComponent(0.1)))
            }
        }
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
                        let index = week * (config.time.endAt.hour - config.time.startAt.hour) + time
                        Rectangle()
                            .foregroundStyle(viewModel.preSelectedBlocks.contains(index) ? .red : viewModel.selectedBlocks.contains(index) ? .timeselectorCellSelected : .timeselectorCellUnselected)
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
                if let index = findBlockIndex(at: dragLocation) {
                    updateSelectedViews(for: index)
                }
            }
            .onEnded { _ in
                viewModel.tempDragBlocks.removeAll()
            }
    }
    
    private func findBlockIndex(at location: CGPoint) -> Int? {
        let week = Int(location.x / cellWidth)
        let time = Int(location.y / cellHeight)
        
        guard week >= 0 && week < config.weeks.count else { return nil }
        guard time >= 0 && time < config.time.endAt.hour - config.time.startAt.hour else { return nil }
        
        let index = week * (config.time.endAt.hour - config.time.startAt.hour) + time
        return index
    }
    
    private func updateSelectedViews(for index: Int) {
        guard !viewModel.tempDragBlocks.contains(index),
              !viewModel.preSelectedBlocks.contains(index) else { return }
        
        viewModel.tempDragBlocks.insert(index)
        
        if viewModel.selectedBlocks.contains(index) {
            viewModel.selectedBlocks.remove(index)
        } else {
            viewModel.selectedBlocks.insert(index)
        }
    }
}


#Preview {
    SATTOTimeSelector(viewModel: TimeSelectorViewModel())
        .aspectRatio(7/10, contentMode: .fit)
        .frame(maxWidth: 350, maxHeight: 500)
}
