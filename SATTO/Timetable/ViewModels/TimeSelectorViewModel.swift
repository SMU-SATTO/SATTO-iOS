//
//  TimeSelectorViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import Foundation

protocol TimeSelectorViewModelProtocol: ObservableObject {
    var selectedTimes: String { get set }
    
    ///drag로 선택한 블록
    var selectedBlocks: Set<Int> { get set }
    ///한 번의 드래그 중 앞서 선택된 블록을 임시로 저장
    var tempDragBlocks: Set<Int> { get set }
    ///이미 선택된 시간대
    var preSelectedBlocks: Set<Int> { get }
}

class TimeSelectorViewModel: TimeSelectorViewModelProtocol {
    @Published var selectedTimes: String = ""
    
    @Published var selectedBlocks: Set<Int> = []
    @Published var tempDragBlocks: Set<Int> = []
    @Published var preSelectedBlocks: Set<Int> = [1, 5, 0]
}
