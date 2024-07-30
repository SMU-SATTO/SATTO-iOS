//
//  FriendView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

enum FriendRoute: Hashable {
    case search
    case followerSearch
    case followingSearch
    case friend
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






struct FriendView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Color(red: 0.92, green: 0.93, blue: 0.94)
                    .ignoresSafeArea(.all)
                
                Color.white
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    Spacer().frame(height: 60)
                    
                    
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 60,
                                    topTrailingRadius: 60
                                )
                            )
                        
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                
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
                            
                            
                            //                            Text("\(friendViewModel.friend?.name ?? "name") \(friendViewModel.friend?.studentId ?? "studentId")")
                            //                                .font(.sb16)
                            //                                .foregroundColor(Color.gray800)
                            //                                .padding(.bottom, 5)
                            
                            Text("\(friendViewModel.friend.last?.name ?? "name") \(friendViewModel.friend.last?.studentId ?? "studentId")")
                                .font(.sb16)
                                .foregroundColor(Color.gray800)
                                .padding(.bottom, 5)
                            
                            Text("\(friendViewModel.friend.last?.department ?? "department")")
                                .font(.m14)
                                .foregroundColor(Color.gray600)
                                .padding(.bottom, 23)
                            
                            HStack(spacing: 0) {
                                followState
                                    .padding(.trailing, 53)
                                
                                overlappingTimetable
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
            print("프렌드뷰 생성")
//            authViewModel.userInfoInquiry {
                friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
                friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
                friendViewModel.fetchFriendTimetableList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
//            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 0) {
                    
                    Button(action: {
                        navPathFinder.path.popLast()
                        friendViewModel.friend.popLast()
                    }, label: {
                        Image("Classic")
                    })
                    
                    CustomNavigationTitle(title: "친구관리")
                }
                .frame(maxWidth: .infinity)
            }
//            ToolbarItem(placement: .topBarTrailing) {
//                HStack(spacing: 0) {
//                    Button(action: {
//                        navPathFinder.addPath(route: .search)
//                    }, label: {
//                        Image("searchIcon")
//                    })
//                }
//                .frame(maxWidth: .infinity)
//            }
        }
        
    }
    
    var followState: some View {
        Text("팔로우")
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
    
    var overlappingTimetable: some View {
        Text("겹치는 시간표 확인")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }
}

#Preview {
    MyPageView()
        .environmentObject(FriendNavigationPathFinder.shared)
}






//#Preview {
//    TimeTableTutorial()
//}

