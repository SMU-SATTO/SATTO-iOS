//
//  TimeSelectorViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 9/30/24.
//

import Foundation

protocol TimeSelectorViewModelProtocol: ObservableObject {
    ///drag로 선택한 블록
    var selectedBlocks: Set<String> { get set }
    ///한 번의 드래그 중 앞서 선택된 블록을 임시로 저장
    var tempDragBlocks: Set<String> { get set }
    ///이미 선택된 시간대
    var preSelectedBlocks: Set<String> { get }
}

class TimeSelectorViewModel: TimeSelectorViewModelProtocol {   
    @Published var selectedBlocks: Set<String> = []
    @Published var tempDragBlocks: Set<String> = []
    @Published var preSelectedBlocks: Set<String> = []
}
