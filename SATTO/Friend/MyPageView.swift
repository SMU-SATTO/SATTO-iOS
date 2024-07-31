//
//  MyPageView.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject var friendViewModel = FriendViewModel()
    
    var body: some View {
        
        NavigationStack(path: $navPathFinder.path) {
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
                                
                                Text("\(authViewModel.user?.name ?? "name") \(authViewModel.user?.studentId ?? "studentId")")
                                    .font(.sb16)
                                    .foregroundColor(Color.gray800)
                                    .padding(.bottom, 5)
                                
                                Text("\(authViewModel.user?.department ?? "department")")
                                    .font(.m14)
                                    .foregroundColor(Color.gray600)
                                    .padding(.bottom, 23)
                                
                                HStack(spacing: 0) {
                                    checkGraduation
                                        .padding(.trailing, 53)
                                    
                                    modifyTimetable
                                }
                                .padding(.bottom, 37)
                                
                                Text("selectedSemesterYear: \(friendViewModel.selectedSemesterYear)")
                                Text("selectedTimeTableName: \(friendViewModel.selectedTimeTableName)")
                                Text("필터링된 시간표id: \(friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))")
                                
                                Button(action: {
                                    print(friendViewModel.follower)
                                }, label: {
                                    Text("팔로워 조회")
                                })
                                Button(action: {
                                    print(friendViewModel.following)
                                }, label: {
                                    Text("팔로잉 조회")
                                })
                                Button(action: {
                                    print(friendViewModel.myFollower)
                                }, label: {
                                    Text("내팔로워 조회")
                                })
                                Button(action: {
                                    print(friendViewModel.myFollowing)
                                }, label: {
                                    Text("내팔로잉 조회")
                                })
                                
                                Button(action: {
                                    print("\(friendViewModel.friend)")
                                }, label: {
                                    Text("현재 정보 조회")
                                })
                                
                                if friendViewModel.timeTables.isEmpty {
                                    Text("시간표가 없습니다")
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
                print("마이페이지뷰 생성")
                
                authViewModel.userInfoInquiry {
                    
//                    friendViewModel.myProfile = authViewModel.user
                    
                    if friendViewModel.friend.isEmpty {
                        let friend = convertUserToFriend(user: authViewModel.user ?? User(studentId: "studentId", email: "email", password: "password", name: "name", nickname: "nickname", department: "department", grade: 5, isPublic: true))
                        friendViewModel.friend.append(friend)
                    }
                    
                    friendViewModel.fetchMyFollowerList(studentId: authViewModel.user?.studentId ?? "asd") {
                        friendViewModel.follower = friendViewModel.myFollower
                    }
                    friendViewModel.fetchMyFollowingList(studentId: authViewModel.user?.studentId ?? "asd") {
                        friendViewModel.following = friendViewModel.myFollowing
                    }
                    
                }
                
                friendViewModel.fetchMyTimetableList()
            }
            .onDisappear {
                print("마이페이지뷰 사라짐")
                friendViewModel.myFollowing = friendViewModel.following
            }
            .onChange(of: friendViewModel.selectedSemesterYear) { _ in
                friendViewModel.selectedTimeTableName = friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear).first ?? "이름없음"
            }
            .onChange(of: friendViewModel.selectedTimeTableName) { _ in
                friendViewModel.fetchTimeTableInfo(timeTableId: friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))
            }
            .navigationDestination(for: FriendRoute.self) { route in
                switch route {
                case .search:
                    SearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "친구의 학번을 입력해 주세요")
                case .followerSearch:
                    FollwerSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로워 목록")
                case .followingSearch:
                    FollowingSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로잉 목록")
                case .friend:
                    FriendView(friendViewModel: friendViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        CustomNavigationTitle(title: "내프로필")
                    }
                    .frame(maxWidth: .infinity)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {
                            navPathFinder.addPath(route: .search)
                        }, label: {
                            Image("searchIcon")
                        })
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
        }
    }
    
    var checkGraduation: some View {
        Text("졸업요건 확인")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.31, blue: 1.0))
                    .cornerRadius(10)
            )
    }
    
    var modifyTimetable: some View {
        Text("시간표 과목수정")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }
    
    var background: some View {
        VStack(spacing: 0) {
            Color(red: 0.92, green: 0.93, blue: 0.94)
                .ignoresSafeArea(.all)
            
            Color.white
                .ignoresSafeArea(.all)
        }
    }
    
    var upperRoundRectangle: some View {
        Rectangle()
            .fill(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(
                .rect(
                    topLeadingRadius: 60,
                    topTrailingRadius: 60
                )
            )
    }
    
    func convertUserToFriend(user: User) -> Friend {
        return Friend(
            studentId: user.studentId,
            email: user.email,
            name: user.name,
            nickname: user.nickname,
            department: user.department,
            grade: String(user.grade),
            isPublic: user.isPublic ? "true" : "false"
        )
    }
    
}


