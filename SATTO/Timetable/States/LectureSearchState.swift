//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation

@MainActor
class LectureSearchState: ObservableObject {
    @Published var searchText: String = ""
    ///["전체", "1학년", "2학년", "3학년", "4학년"]
    @Published var selectedGrades: [String] = ["전체"]
    ///["전체", "일반교양", "균형교양", "교양필수"]
    @Published var selectedGE: [String] = ["전체"]
    ///["전체", "인문", "사회", "자연", "공학", "예술"]
    @Published var selectedBGE: [String] = ["전체"]
    ///["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    @Published var selectedELOption: [String] = ["전체"]
    @Published var selectedTimes: String = ""
    
    @Published var subjectDetailDataList: [SubjectDetailModel]?
    
    @Published var selectedLectures: [SubjectModelBase] = []
    
    @Published var currentPage: Int?
    @Published var totalPage: Int? = 0
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool?
    
    func resetState() {
        subjectDetailDataList = []
        currentPage = 0
        totalPage = 0
        isLoading = false
        hasMorePages = true
    }
    
    func addCurrentPage() {
        currentPage = (currentPage ?? 0) + 1
    }
    
    func resetCurrPage() {
        currentPage = 0
    }
}
