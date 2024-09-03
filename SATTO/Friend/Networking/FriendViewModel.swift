//
//  FriendViewModel.swift
//  SATTO
//
//  Created by 황인성 on 6/26/24.
//

import Foundation
import Moya
import Combine
import SwiftUI


class FriendViewModel: ObservableObject {
    
    private let provider = MoyaProvider<FriendAPI>()
    
    // 찬구목록 타고 들어가는 깊이(첫번쨰 요소는 본인)
    @Published var friend: [Friend] = []
    
    // 내 팔로워, 팔로잉 목롱
    // 내 팔로워, 팔로잉 탭에서 보여지는 목록 아님
    @Published var myFollower: [Friend] = []
    @Published var myFollowing: [Friend] = []
    
    // 보여지는 팔로워, 팔로잉 목록
    @Published var follower: [Friend] = []
    @Published var following: [Friend] = []
    // 검색화면 검색 리스트
    @Published var searchUsers: [Friend] = []
    // 시간표 목록
    @Published var timeTables: [Timetable] = []
    // 강의정보가 포함된 상태 시간표
    @Published var timeTableInfo: TimeTableInfo?
    // 선택한 한기정보
    @Published var selectedSemesterYear: String = ""
    // 선택한 시간표 이름
    @Published var selectedTimeTableName: String = ""
    
    let colors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .yellow, .red, .gray, .cyan, .indigo
    ]
    
    @Published var colorMapping: [String: Color] = [:]
    
    @Published var compareFriends: [Friend] = []
    @Published var overlappingLectures: [[Lecture]] = []
    @Published var overlappingGapLectures: [[Lecture]] = []
    
    init() {
        
    }
    
    // 팔로잉 요청보내기
    func followingRequest(studentId: String, completion: @escaping () -> Void) {
        provider.request(.followingRequest(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("followingRequest네트워크 요청 성공🚨")
                    completion()
                case .failure:
                    print("followingRequest네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 펄로잉 취소
    func unfollowing(studentId: String, completion: @escaping () -> Void) {
        provider.request(.unfollwing(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("unfollowing네트워크 요청 성공🚨")
                    completion()
                case .failure:
                    print("unfollowing네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 나를 팔로잉하는 친구 삭제
    func unfollow(studentId: String, completion: @escaping () -> Void) {
        provider.request(.unfollow(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("unfollow네트워크 요청 성공🚨")
                    completion()
                case .failure:
                    print("unfollow네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 친구 팔로워 목록조회
    func fetchFollowerList(studentId: String) {
        provider.request(.followerList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.follower = friendResponse.result
                        print("fetchFollowerList매핑 성공🚨")
                    }
                    else {
                        print("fetchFollowerList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchFollowerList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 친구 팔로잉 목록조회
    func fetchFollowingList(studentId: String) {
        provider.request(.followingList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.following = friendResponse.result
                        print("fetchFollowingList매핑 성공🚨")
                    }
                    else {
                        print("fetchFollowingList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchFollowingList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 내 팔로워 목록조회
    func fetchMyFollowerList(studentId: String, completion: @escaping () -> Void) {
        provider.request(.followerList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.myFollower = friendResponse.result
                        print("fetchMyFollowerList매핑 성공🚨")
                        completion()
                    }
                    else {
                        print("fetchMyFollowerList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchMyFollowerList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 내 팔로잉 목록조회
    func fetchMyFollowingList(studentId: String, completion: @escaping () -> Void) {
        provider.request(.followingList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.myFollowing = friendResponse.result
                        print("fetchMyFollowingList매핑 성공🚨")
                        completion()
                    }
                    else {
                        print("fetchMyFollowingList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchMyFollowingList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 유저 검색
    func searchUser(studentIdOrName: String) {
        provider.request(.searchUser(studentIdOrName: studentIdOrName)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.searchUsers = friendResponse.result
                        print("searchUser매핑 성공🚨")
                    }
                    // 실패하면 searchUsers비우기
                    else {
                        print("searchUser매핑 실패🚨")
                        self.searchUsers = []
                    }
                case .failure:
                    print("searchUser네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 친구 시간표 조회
    func fetchFriendTimetableList(studentId: String) {
        provider.request(.friendTimetableList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let timeTableResponse = try? response.map(TimeTableResponse.self) {
                        self.timeTables = timeTableResponse.result
                        self.selectedSemesterYear = self.getSemestersFromTimetables(timeTables: self.timeTables).first ?? ""
                        print("fetchFriendTimetableList매핑 성공🚨")
                    }
                    else {
                        print("fetchFriendTimetableList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchFriendTimetableList네트워크 요청 실패🚨")
                }
            }
        }
    }

    // 내 시간표 조회
    func fetchMyTimetableList() {
        provider.request(.myTimeTableList) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let timeTableResponse = try? response.map(TimeTableResponse.self) {
                        self.timeTables = timeTableResponse.result
                        self.selectedSemesterYear = self.getSemestersFromTimetables(timeTables: self.timeTables).first ?? ""
                        print("fetchMyTimetableList매핑 성공🚨")
                    }
                    else {
                        print("fetchMyTimetableList매핑 실패🚨")
                    }
                case .failure:
                    print("fetchMyTimetableList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 시간표 강의 조회
    func fetchTimeTableInfo(timeTableId: Int) {
        provider.request(.fetchTimeTableInfo(timeTableId: timeTableId)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        if let timeTableInfoResponse = try? response.map(TimeTableInfoResponse.self) {
                            self.timeTableInfo = timeTableInfoResponse.result
                            self.assignColors()
                            print("fetchTimeTableInfo매핑 성공🚨")
                        }
                        else {
                            self.timeTableInfo = TimeTableInfo(timeTableId: 999, lects: [], semesterYear: "없음", timeTableName: "없음", isPublic: false, isRepresented: false)
                            print("fetchTimeTableInfo매핑 실패🚨")
                        }
                    case .failure:
                        print("fetchTimeTableInfo네트워크 요청 실패🚨")
                    }
                }

            }
        }
    
    func postCompareTimeTable(studentIds: [String]) {
        provider.request(.compareTimeTable(studentIds: studentIds)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                        }
                        
                        if let compareTimeTableResponse = try? response.map(CompareTimetableResponse.self) {
                            self.overlappingLectures = compareTimeTableResponse.result
                            print(self.overlappingLectures)
                            print("postCompareTimeTable매핑 성공🚨")
                        }
                        else {
                            print("postCompareTimeTable매핑 실패🚨")
                        }
                    case .failure:
                        print("postCompareTimeTable네트워크 요청 실패🚨")
                    }
                }

            }
    }
    
    func postCompareTimeTableGap(studentIds: [String]) {
        provider.request(.compareTimeTableGap(studentIds: studentIds)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                        }
                        
                        if let compareTimeTableResponse = try? response.map(CompareTimetableResponse.self) {
                            self.overlappingGapLectures = compareTimeTableResponse.result
                            print(self.overlappingGapLectures)
                            print("postCompareTimeTableGap매핑 성공🚨")
                        }
                        else {
                            print("postCompareTimeTableGap매핑 실패🚨")
                        }
                    case .failure:
                        print("postCompareTimeTableGap네트워크 요청 실패🚨")
                    }
                }

            }
    }
    

    // 학수번호랑 색이랑 맵핑하는 메서드
    func assignColors() {
        // 빈 딕셔너리 생성
        var assignedColors: [String: Color] = [:]
        // 색깔 인덱스 0
        var colorIndex = 0
        
        // timeTableInfo가 nil이 아닐때
        if let lectures = self.timeTableInfo?.lects {
            // 강의들을 반복하면서
            for lecture in lectures {
                // 만약 강의의 학수번호가 매핑이 안되있을떄
                if assignedColors[lecture.codeSection] == nil {
                    // 강의의 학수번호에 맵핑
                    // 나머지 연산자로 색배열 순회가능
                    assignedColors[lecture.codeSection] = self.colors[colorIndex % self.colors.count]
                    // 색깔 인덱스 +1
                    colorIndex += 1
                }
            }
        }
        self.colorMapping = assignedColors
    }
    
    // 학수번호를 넣으면 색이 반환된다
    // @Published var colorMapping: [String: Color] = [:]
    // 이미 학수번호에 색깔이 맵핑 되어있음
    // 없는 학수번호는 투명색
    func getColorForCodeSection(codeSection: String) -> Color {
        return self.colorMapping[codeSection] ?? .clear
    }

    // 내가 고른 학기와 시간표 이름에 해당하는 시간표ID를 반환
    func getSelectedTimetableId(timeTables: [Timetable]) -> Int {
        return timeTables.filter{ $0.semesterYear == selectedSemesterYear && $0.timeTableName == selectedTimeTableName }.first?.timeTableId ?? 9999
    }
    // 학기정보 포멧팅 ex) 2023학년도 1학기
    func formatSemesterString(semester: String) -> String {
        return "\(semester.prefix(4))학년도 \(semester.suffix(1))학기"
    }
    // 시간표 목록의 학기정보만 중복없이 시간순으로 정렬
    func getSemestersFromTimetables(timeTables: [Timetable]) -> [String] {
        return Array(Set(timeTables.map { $0.semesterYear })).sorted(by: >)
    }
    // 내가 선택한 학기정보에 맞는 시간표 이름만 필터링
    func getTimetableNamesForSemester(timeTables: [Timetable], semester: String) -> [String] {
        return timeTables.filter { $0.semesterYear == semester }.sorted(by: { $0.isRepresent && !$1.isRepresent }).map { $0.timeTableName }
    }
}
