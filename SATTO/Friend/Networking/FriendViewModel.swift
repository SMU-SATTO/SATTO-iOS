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
    
    @Published var errorMessage: String?
    
    
    @Published var friend: [Friend] = []
    
    @Published var myFollower: [Friend] = []
    @Published var myFollowing: [Friend] = []
    
    @Published var follower: [Friend] = []
    @Published var following: [Friend] = []
    @Published var searchUsers: [Friend] = []
    
    @Published var timeTables: [Timetable] = []
    
    @Published var timeTableInfo: TimeTableInfo?
    
    @Published var selectedSemesterYear: String = ""
    @Published var selectedTimeTableName: String = ""
    
    let colors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .yellow, .red, .gray, .cyan, .indigo
    ]
    
    @Published var colorMapping: [String: Color] = [:]
    
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
    
    // 팔로워 새로고침
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
    
    // 팔로잉 새로고침
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
    
    // 내 팔로워 새로고침
    func fetchMyFollowerList(studentId: String, completion: @escaping () -> Void) {
        provider.request(.followerList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.myFollower = friendResponse.result
//                        self.follower = friendResponse.result
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
    
    // 내 팔로잉 새로고침
    func fetchMyFollowingList(studentId: String, completion: @escaping () -> Void) {
        provider.request(.followingList(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let friendResponse = try? response.map(FriendResponse.self) {
                        self.myFollowing = friendResponse.result
//                        self.following = friendResponse.result
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
    
    
    
    func assignColors() {
        var assignedColors: [String: Color] = [:]
        var colorIndex = 0
        
        if let lectures = self.timeTableInfo?.lects {
            
            for lecture in lectures {
                if assignedColors[lecture.codeSection] == nil {
                    assignedColors[lecture.codeSection] = self.colors[colorIndex % self.colors.count]
                    colorIndex += 1
                }
            }
        }
//        print(assignedColors)
        self.colorMapping = assignedColors
    }
    
    func getColorForCodeSection(codeSection: String) -> Color {
        return self.colorMapping[codeSection] ?? .clear
    }

    
    
    func getSelectedTimetableId(timeTables: [Timetable]) -> Int {
        return timeTables.filter{ $0.semesterYear == selectedSemesterYear && $0.timeTableName == selectedTimeTableName }.first?.timeTableId ?? 9999
    }
    
    func formatSemesterString(semester: String) -> String {
        return "\(semester.prefix(4))학년도 \(semester.suffix(1))학기"
    }
    
    func getSemestersFromTimetables(timeTables: [Timetable]) -> [String] {
        return Array(Set(timeTables.map { $0.semesterYear })).sorted(by: >)
    }
    
    func getTimetableNamesForSemester(timeTables: [Timetable], semester: String) -> [String] {
        return timeTables.filter { $0.semesterYear == semester }.map { $0.timeTableName }
    }
}
