//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
protocol LectureSearchServiceProtocol: Sendable {
    func set<Value>(_ keyPath: WritableKeyPath<LectureSearchState, Value>, to value: Value)
    func searchLecture() async throws
    func searchLecture(page: Int) async throws
}

struct LectureSearchService: LectureSearchServiceProtocol {
    var appState: AppState
    var webRepositories: AppEnvironment.WebRepositories
    
    var lectureSearchRepository: LectureSearchRepositoryProtocol {
        webRepositories.lectureSearchRepository
    }
    
    func set<Value>(_ keyPath: WritableKeyPath<LectureSearchState, Value>, to value: Value) {
        appState.lectureSearch[keyPath: keyPath] = value
    }

    func searchLecture() async throws {
        let pageToFetch = appState.lectureSearch.currentPage ?? 0
        appState.lectureSearch.currentPage = 0
        try await searchLecture(page: pageToFetch)
    }
    
    func searchLecture(page: Int) async throws {
        guard appState.lectureSearch.isLoading != true else { return }
        appState.lectureSearch.isLoading = true
        
        let lectureFilter = appState.lectureSearch.lectureFilter
        
        // 학년 필터 변환 로직
        let grade: [Int] = lectureFilter.category.grade.compactMap { grade in
            switch grade {
            case "1학년": return 1
            case "2학년": return 2
            case "3학년": return 3
            case "4학년": return 4
            default: return nil
            }
        }
        
        // e-러닝 필터 변환 로직
        let isCyber: Int = {
            switch lectureFilter.category.eLearn {
            case "E러닝만 보기": return 1
            case "E러닝 빼고 보기": return 2
            default: return 0
            }
        }()
        
        let timeZone = convertSetToString(lectureFilter.category.time)
        
        let lectureSearchRequest = CurrentLectureListRequest(
            searchText: lectureFilter.searchText,
            grade: grade,
            elective: lectureFilter.category.elective.isAnyElectiveSelected() ? 1 : 0,
            normal: lectureFilter.category.elective.normal ? 1 : 0,
            essential: lectureFilter.category.elective.essential ? 1 : 0,
            humanity: lectureFilter.category.elective.balance.humanity ? 1 : 0,
            society: lectureFilter.category.elective.balance.society ? 1 : 0,
            nature: lectureFilter.category.elective.balance.nature ? 1 : 0,
            engineering: lectureFilter.category.elective.balance.engineering ? 1 : 0,
            art: lectureFilter.category.elective.balance.art ? 1 : 0,
            isCyber: isCyber,
            timeZone: timeZone
        )
        
        let dto = try await lectureSearchRepository
            .fetchCurrentLectureList(request: lectureSearchRequest, page: page)
        
        guard let lectureLists = dto.result else {
            appState.lectureSearch.lectureList = []
            return
        }
        
        let lectureModels: [LectureModel] = lectureLists.currentLectureResponseDTOList.map {
            LectureModel(
                sbjDivcls: $0.codeSection ?? "Error",
                sbjNo: $0.code ?? "Error",
                sbjName: $0.lectName ?? "Error",
                time: $0.lectTime?.trimmingCharacters(in: .whitespaces) ?? "일10",
                prof: $0.professor ?? "Error",
                major: $0.cmpDiv ?? "Error",
                credit: $0.credit ?? 0
            )
        }
        
        if appState.lectureSearch.currentPage == 0 {
            appState.lectureSearch.lectureList = lectureModels
        }
        else {
            appState.lectureSearch.lectureList?.append(contentsOf: lectureModels)
        }
        appState.lectureSearch.totalPage = lectureLists.totalPage
        appState.lectureSearch.hasMorePages = appState.lectureSearch.currentPage ?? 0 < (appState.lectureSearch.totalPage ?? 0) - 1
        appState.lectureSearch.isLoading = false
    }
    
    func convertSetToString(_ set: Set<String>) -> String {
        let weekdaysOrder = ["월", "화", "수", "목", "금", "토", "일"]
        
        let sortedSet = set.sorted {
            let firstDay = String($0.prefix(1))
            let secondDay = String($1.prefix(1))
            
            // 요일 순서에 맞춰 정렬
            if let firstIndex = weekdaysOrder.firstIndex(of: firstDay),
               let secondIndex = weekdaysOrder.firstIndex(of: secondDay) {
                if firstIndex == secondIndex {
                    // 같은 요일일 경우 시간 순서로 정렬
                    return $0.compare($1, options: .numeric) == .orderedAscending
                }
                return firstIndex < secondIndex
            }
            return false
        }
        
        return sortedSet.joined(separator: " ")
    }
}

struct FakeLectureSearchService: LectureSearchServiceProtocol {
    func set<Value>(_ keyPath: WritableKeyPath<LectureSearchState, Value>, to value: Value) { }
    func searchLecture() async throws { }
    func searchLecture(page: Int) async throws { }
}
