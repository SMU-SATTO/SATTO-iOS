//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
protocol LectureSearchServiceProtocol: Sendable {
    func setSelectedLectures(_ value: [LectureModel])
    func setSearchText(_ value: String)
    func setSelectedBlocks(_ value: Set<String>)
    func setPreSelectedBlocks(_ value: Set<String>)
    func fetchCurrentLectureList() async throws
    func fetchCurrentLectureList(page: Int) async throws
}

struct LectureSearchService: LectureSearchServiceProtocol {
    var appState: AppState
    var webRepositories: AppEnvironment.WebRepositories
    
    var lectureSearchRepository: LectureSearchRepositoryProtocol {
        webRepositories.lectureSearchRepository
    }
    
    func setSelectedLectures(_ value: [LectureModel]) {
        appState.lectureSearch.selectedLectures = value
    }
    
    func setSearchText(_ value: String) {
        appState.lectureSearch.searchText = value
    }
    
    func setSelectedBlocks(_ value: Set<String>) {
        appState.lectureSearch.selectedBlocks = value
    }
    
    func setPreSelectedBlocks(_ value: Set<String>) {
        appState.lectureSearch.preSelectedBlocks = value
    }
    
    func fetchCurrentLectureList() async throws {
        let pageToFetch = appState.lectureSearch.currentPage ?? 0
        appState.lectureSearch.currentPage = 0
        try await fetchCurrentLectureList(page: pageToFetch)
    }
    
    func fetchCurrentLectureList(page: Int) async throws {
        guard appState.lectureSearch.isLoading != true else { return }
        appState.lectureSearch.isLoading = true
        
        let grade: [Int] = appState.lectureSearch.selectedGrades.contains("전체") ? [] : appState.lectureSearch.selectedGrades.compactMap { grade in
            switch grade {
            case "1학년": return 1
            case "2학년": return 2
            case "3학년": return 3
            case "4학년": return 4
            default: return nil
            }
        }
        
        let elective = appState.lectureSearch.selectedGE.contains("균형교양") ? 1 : 0
        let normal = appState.lectureSearch.selectedGE.contains("일반교양") ? 1 : 0
        let essential = appState.lectureSearch.selectedGE.contains("교양필수") ? 1 : 0
        
        let humanity = appState.lectureSearch.selectedBGE.contains("인문") ? 1 : 0
        let society = appState.lectureSearch.selectedBGE.contains("사회") ? 1 : 0
        let nature = appState.lectureSearch.selectedBGE.contains("자연") ? 1 : 0
        let engineering = appState.lectureSearch.selectedBGE.contains("공학") ? 1 : 0
        let art = appState.lectureSearch.selectedBGE.contains("예술") ? 1 : 0
        
        let isCyber: Int = {
            let selectedELOption = appState.lectureSearch.selectedELOption 
            if selectedELOption.contains("전체") { return 0 }
            else if selectedELOption.contains("E러닝만 보기") { return 1 }
            else if selectedELOption.contains("E러닝 빼고 보기") { return 2 }
            return 0
        }()
        
        let lectureRequest: CurrentLectureListRequest = CurrentLectureListRequest(
            searchText: appState.lectureSearch.searchText,
            grade: grade,
            elective: elective,
            normal: normal,
            essential: essential,
            humanity: humanity,
            society: society,
            nature: nature,
            engineering: engineering,
            art: art,
            isCyber: isCyber,
            timeZone: appState.lectureSearch.selectedTimes)
        
        let dto = try await lectureSearchRepository.fetchCurrentLectureList(request: lectureRequest, page: page)
        
        guard let currentLectureLists = dto.result else {
            appState.lectureSearch.lectureList = []
            return
        }
        let lectureModels: [LectureModel] = currentLectureLists.currentLectureResponseDTOList.map {
            LectureModel(
                sbjDivcls: $0.codeSection ?? "Error", sbjNo: $0.code ?? "Error", sbjName: $0.lectName ?? "Error", time: $0.lectTime?.trimmingCharacters(in: .whitespaces) ?? "일10", prof: $0.professor ?? "Error", major: $0.cmpDiv ?? "Error", credit: $0.credit ?? 0
            )
        }
        if appState.lectureSearch.currentPage == 0 {
            appState.lectureSearch.lectureList = lectureModels
        }
        else {
            appState.lectureSearch.lectureList?.append(contentsOf: lectureModels)
        }
        appState.lectureSearch.totalPage = currentLectureLists.totalPage
        appState.lectureSearch.hasMorePages = appState.lectureSearch.currentPage ?? 0 < (appState.lectureSearch.totalPage ?? 0) - 1
        appState.lectureSearch.isLoading = false
    }
}

struct FakeLectureSearchService: LectureSearchServiceProtocol {
    func setSelectedLectures(_ value: [LectureModel]) { }
    func setSearchText(_ value: String) { }
    func setSelectedBlocks(_ value: Set<String>) { }
    func setPreSelectedBlocks(_ value: Set<String>) { }
    func fetchCurrentLectureList() async throws { }
    func fetchCurrentLectureList(page: Int) async throws { }
}
