//
//  MyPageView.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

enum FriendRoute: Hashable {
    case search
    case followerSearch
    case followingSearch
    case friend
    case compareTimeTable
}

final class FriendNavigationPathFinder: ObservableObject {
    static let shared = FriendNavigationPathFinder()
    private init() { }
    
    @Published var path: [FriendRoute] = []
    
    func addPath(route: FriendRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}

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
                                    
                                } // HStack
                                .padding(.top, 22)
                                .padding(.bottom, 14)
                                .padding(.horizontal, 51)
                                
                                Text("\(authViewModel.user.name) \(authViewModel.user.studentId)")
                                    .font(.sb16)
                                    .foregroundColor(Color.gray800)
                                    .padding(.bottom, 5)
                                
                                Text("\(authViewModel.user.department)")
                                    .font(.m14)
                                    .foregroundColor(Color.gray600)
                                    .padding(.bottom, 23)
                                
                                HStack(spacing: 0) {
                                    checkGraduation
                                        .padding(.trailing, 53)
                                    
                                    Button(action: {
                                        navPathFinder.addPath(route: .compareTimeTable)
                                    }, label: {
                                        modifyTimetable
                                    })
                                }
                                .padding(.bottom, 37)

                                if friendViewModel.timeTables.isEmpty {
                                    Text("시간표가 없습니다")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 20)
                                        .foregroundStyle(Color.cellText)
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
                                    .tint(Color.cellText)
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
                
                // 내 정보 조회가 성공하면
                authViewModel.userInfoInquiry {
                    // friend배열이 비어있으면 내 정보를 friend로 변환해서 첫번째 인덱스에 넣는다
                    if friendViewModel.friend.isEmpty {
                        let friend = convertUserToFriend(user: authViewModel.user)
                        friendViewModel.friend.append(friend)
                    }
                    // 내 팔로워들을 follower배열과 myFollower배열에 넣는다
                    friendViewModel.fetchMyFollowerList(studentId: authViewModel.user.studentId) {
                        friendViewModel.follower = friendViewModel.myFollower
                    }
                    // 내 팔로잉들을 following배열과 myFolloweing배열에 넣는다
                    friendViewModel.fetchMyFollowingList(studentId: authViewModel.user.studentId) {
                        friendViewModel.following = friendViewModel.myFollowing
                    }
                }
                // 내 시간표들을 조회한다 (강의정보 제외)
                friendViewModel.fetchMyTimetableList()
            }
            // 학기를 바꾸면 그 학기에 해당하는 시간표들의 첫번째 값을 보여준다
            .onChange(of: friendViewModel.selectedSemesterYear) { _ in
                friendViewModel.selectedTimeTableName = friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear).first ?? "이름없음"
            }
            // 시간표 이름을 바꾸면 그 시간표의 값을 보여준다
            .onChange(of: friendViewModel.selectedTimeTableName) { _ in
                friendViewModel.fetchTimeTableInfo(timeTableId: friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))
            }
            // 마이페이지에서 팔로워 누를때만 FollwerSearchView로 이동
            .navigationDestination(for: FriendRoute.self) { route in
                switch route {
                case .search:
                    SearchView(friendViewModel: friendViewModel)
                case .followerSearch:
                    FollwerSearchView(friendViewModel: friendViewModel)
                case .followingSearch:
                    FollowingSearchView(friendViewModel: friendViewModel)
                case .friend:
                    FriendView(friendViewModel: friendViewModel)
                case .compareTimeTable:
                    CompareTimeTableView(friendViewModel: friendViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        CustomNavigationTitle(title: "내프로필")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "bell")
                        })
                        
                        Button(action: {
                            navPathFinder.addPath(route: .search)
                        }, label: {
                            Image("searchIcon")
                                .renderingMode(.template)
                                .foregroundStyle(.backButton)
                        })
                    }
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
                    .fill(Color.sattoPurple)
                    .cornerRadius(10)
            )
    }
    
    var modifyTimetable: some View {
        Text("겹차는 시간표 확인")
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
    
    // user를 friend로 바꾸는 함수
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


