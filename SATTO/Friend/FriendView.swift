//
//  FriendView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct FriendView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            background
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    ZStack(alignment: .top) {
                        upperRoundRectangle
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                
                                // 팔로워 버튼
                                Button(action: {
                                    navPathFinder.addPath(route: .followerSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("\(friendViewModel.follower.count)")
                                            .foregroundColor(Color.gray800)
                                        
                                        Text("팔로워")
                                            .foregroundColor(Color.gray500)
                                    }
                                    .font(.sb16)
                                })
                                
                                Spacer()
                                
                                ProfileImageCell(inCircleSize: 100, outCircleSize: 105)
                                    .shadow(radius: 15, x: 0, y: 10)
                                    .padding(.top, -72)
                                    .zIndex(1)
                                
                                Spacer()
                                
                                // 팔로잉 버튼
                                Button(action: {
                                    navPathFinder.addPath(route: .followingSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("\(friendViewModel.following.count)")
                                            .foregroundColor(Color.gray800)
                                        
                                        Text("팔로잉")
                                            .foregroundColor(Color.gray500)
                                    }
                                    .font(.sb16)
                                })
                            }
                            .padding(.top, 22)
                            .padding(.bottom, 14)
                            .padding(.horizontal, 51)
                            
                            // 친구창 들어가는 깊이의 마지막요소의 데이터 사용
                            Text("\(friendViewModel.friend.last?.name ?? "name") \(friendViewModel.friend.last?.studentId ?? "studentId")")
                                .font(.sb16)
                                .foregroundColor(Color.gray800)
                                .padding(.bottom, 5)
                            Text("\(friendViewModel.friend.last?.department ?? "department")")
                                .font(.m14)
                                .foregroundColor(Color.gray600)
                                .padding(.bottom, 23)
                            
                            HStack(spacing: 0) {
                                // 내가 보는 친구가 내 팔로잉 목록에 있을때 언팔로잉 버튼이 표시됨
                                if friendViewModel.myFollowing.contains(friendViewModel.friend.last ?? Friend(studentId: "친구배열 비어있음", email: "친구배열 비어있음", name: "친구배열 비어있음", nickname: "친구배열 비어있음", department: "친구배열 비어있음", grade: "친구배열 비어있음", isPublic: "친구배열 비어있음")) {
                                    
                                    Button(action: {
                                        // 언팔로잉 하면 내 팔로잉, 팔로워 새로고침
                                        friendViewModel.unfollowing(studentId: friendViewModel.friend.last?.studentId ?? "studentId") {
                                            friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                                            friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                                        }
                                    }, label: {
                                        unfollowingButton
                                    })
                                    .padding(.trailing, 53)
                                }
                                // 내가 보는 친구가 내 팔로잉 목록에 없을때 팔로잉 버튼이 표시됨
                                else if !friendViewModel.myFollowing.contains(friendViewModel.friend.last ?? Friend(studentId: "친구배열 비어있음", email: "친구배열 비어있음", name: "친구배열 비어있음", nickname: "친구배열 비어있음", department: "친구배열 비어있음", grade: "친구배열 비어있음", isPublic: "친구배열 비어있음")) {
                                    
                                    Button(action: {
                                        // 팔로잉 하면 내 팔로잉, 팔로워 새로고침
                                        friendViewModel.followingRequest(studentId: friendViewModel.friend.last?.studentId ?? "friendViewModel.friend 비어있음") {
                                            friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
                                            friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
                                        }
                                    }, label: {
                                        followButton
                                    })
                                    .padding(.trailing, 53)
                                }
                                
                                overlappingTimetable
                            }
                            .padding(.bottom, 37)
                            
                            // 시간표 목록이 비어있을때
                            if friendViewModel.timeTables.isEmpty {
                                Text("시간표가 없습니다")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                            }
                            else {
                                HStack(spacing: 0) {
                                    Picker("Select Semester Year", selection: $friendViewModel.selectedSemesterYear) {
                                        ForEach(friendViewModel.getSemestersFromTimetables(timeTables: friendViewModel.timeTables), id: \.self) { semester in
                                            Text(friendViewModel.formatSemesterString(semester: semester))
                                                .tag(semester)
                                        }
                                    }
                                    
                                    Picker("Select Time Table", selection: $friendViewModel.selectedTimeTableName) {
                                        ForEach(friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear), id: \.self) { name in
                                            Text(name).tag(name)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .tint(Color.black)
                            }
                            
                            TimeTableTutorial(friendViewModel: friendViewModel)
                            
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            print("프렌드뷰 생성")
            // 내가 보는 친구의 팔로워, 팔로잉, 시간표 목록을 조회
            friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
            friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
            friendViewModel.fetchFriendTimetableList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 0) {
                    Button(action: {
                        navPathFinder.path.popLast()
                        friendViewModel.friend.popLast()
                    }, label: {
                        Image("Classic")
                            .renderingMode(.template)
                            .foregroundStyle(.backButton)
                    })
                    CustomNavigationTitle(title: "친구관리")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    var followButton: some View {
        Text("팔로우")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color.sattoPurple)
                    .cornerRadius(10)
            )
    }
    
    var unfollowingButton: some View {
        Text("팔로잉")
            .font(.m12)
            .foregroundColor(Color.sattoPurple)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.sattoPurple, lineWidth: 1)
            )
    }
    
    var overlappingTimetable: some View {
        Text("겹치는 시간표 확인")
            .font(.m12)
            .foregroundColor(Color.sattoPurple)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.sattoPurple, lineWidth: 1)
            )
    }
    
    var background: some View {
        VStack(spacing: 0) {
            Color.friendBackUpper
                .ignoresSafeArea(.all)
            Color.friendBackLower
                .ignoresSafeArea(.all)
        }
    }
    
    var upperRoundRectangle: some View {
        Rectangle()
            .fill(Color.friendBackLower)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(
                .rect(
                    topLeadingRadius: 60,
                    topTrailingRadius: 60
                )
            )
    }
}

#Preview {
    MyPageView()
        .environmentObject(FriendNavigationPathFinder.shared)
}
