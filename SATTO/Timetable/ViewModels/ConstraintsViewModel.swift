//
//  File.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import Combine
import Foundation

class ConstraintsViewModel: BaseViewModel, ObservableObject {
    @Published private var _constraints: ConstraintModel = ConstraintModel()
    var constraints: ConstraintModel {
        get { _constraints }
        set {
            constraintService.set(\.constraints, to: newValue)
            updatePreSelectedTimes()
        }
    }
    
    @Published private(set) var preSelectedTimes: Set<String> = []
    
    //request할 때 보낼 과목 조합 리스트
    @Published private var _selectedMajorCombs: [MajorComb] = []      //majorList
    var selectedMajorCombs: [MajorComb] {
        get { _selectedMajorCombs }
        set { constraintService.set(\.selectedMajorCombs, to: newValue) }
    }
    
    //서버에서 준 과목 조합 리스트
    @Published private(set) var majorCombinations: [MajorComb]?
    @Published private(set) var finalTimetableList: [[LectureModel]]?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init (container: DIContainer) {
        super.init(container: container)

        constraintState.$constraints
            .assign(to: \._constraints, on: self)
            .store(in: &cancellables)
        
        updatePreSelectedTimes()
        
        appState.lectureSearch.$selectedLectures
            .sink { [weak self] selectedLectures in
                DispatchQueue.main.async {
                    self?.constraints.requiredLectures = selectedLectures
                }
            }
            .store(in: &cancellables)
        
        constraintState.$selectedMajorCombs
            .assign(to: \._selectedMajorCombs, on: self)
            .store(in: &cancellables)
        
        constraintState.$majorCombs
            .assign(to: \.majorCombinations, on: self)
            .store(in: &cancellables)
        
        constraintState.$finalTimetableList
            .assign(to: \.finalTimetableList, on: self)
            .store(in: &cancellables)
    }
    
    private var constraintService: ConstraintServiceProtocol {
        services.constraintService
    }
    
    private var constraintState: ConstraintState {
        appState.constraint
    }
    
    func resetAllProperties() {
        constraints = ConstraintModel()
    }
    
    private func updatePreSelectedTimes() {
        let times = constraints.requiredLectures.flatMap { lecture in
            lecture.time.components(separatedBy: " ")
        }
        preSelectedTimes = Set(times)
    }
    
    func toggleSelection(_ combination: MajorComb) {
        if selectedMajorCombs.contains(where: { $0.combination == combination.combination }) {
            selectedMajorCombs.removeAll(where: { $0.combination == combination.combination })
        } else {
            selectedMajorCombs.append(combination)
        }
    }

    func isSelected(_ combination: MajorComb) -> Bool {
        return selectedMajorCombs.contains(where: { $0.combination == combination.combination })
    }

    func fetchMajorCombinations() async {
        do {
            try await constraintService.getMajorComb()
        } catch {
            print("전공조합을 가져오는데 실패했어요.")
        }
    }
    
    func fetchFinalTimetableList(isRaw: Bool) async {
        do {
            try await constraintService.getFinalTimetableList(isRaw: isRaw)
        } catch {
            print("최종 시간표 목록을 가져오는데 실패했어요.")
        }
    }
    
    func saveTimetable(timetableIndex: Int, timetableName: String) async {
        do {
            try await constraintService.saveTimetable(timetableIndex: timetableIndex, timetableName: timetableName)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
    
    func saveCustomTimetable(codeSectionList: [String], timeTableName: String) async {
        do {
            try await constraintService.saveCustomTimetable(codeSectionList: codeSectionList, timeTableName: timeTableName)
        } catch {
            print("시간표 저장에 실패했어요")
        }
    }
}

