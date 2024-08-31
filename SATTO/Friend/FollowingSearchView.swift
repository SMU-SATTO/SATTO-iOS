//
//  FollowingSearchView.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct FollowingSearchView: View {
    
    @State var text = ""
    var TextFieldPlacehold: String = "팔로잉 목록"
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    CustomBackButton()
                        .padding(.leading, 20)
                    ClearButtonTextField(placehold: TextFieldPlacehold, text: $text)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                Divider()

                ScrollView {
                    // 네트워크 없이 로컬에서 검색
                    // 이름과 학번 모두 검색 가능
                    ForEach(friendViewModel.following.filter {
                        text.isEmpty || $0.name.contains(text) || $0.studentId.contains(text)
                    }, id: \.studentId) { friend in
                        // 마이페이지든 친구페이지든 followingCell로 표시
                        FollowingFriendCell(friend: friend, friendViewModel: friendViewModel)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                // 내가 보고있는 친구의 팔로잉 조회
                friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
            }
        }
    }
}

struct FollowingFriendCell: View {
    
    var friend: Friend
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 63, height: 63)
                )
                .shadow(radius: 5, x: 0, y: 5)
                .padding(.trailing, 14)
                .padding(.leading, 20)
            
            Button(action: {
                // 내 정보와 일치하는 친구는 친구페이지로 이동 불가
                if friend == friendViewModel.friend.first { }
                // friend목록에 추가하고 뷰 이동
                else {
                    friendViewModel.friend.append(friend)
                    navPathFinder.addPath(route: .friend)
                }
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text(friend.name)
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    Text(friend.studentId)
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            Spacer()
            
            // 내가 보고있는 친구가 내 팔로잉 목록에 있으면
            if friendViewModel.myFollowing.contains(friend) {
                // 언팔로잉 버튼 표시
                Button(action: {
                    // 언팔로잉 버튼 누르면 내 팔로잉 팔로워 새로고침, 단 보고있는 목록은 새로고침 하지 않음(인스타처럼)
                    friendViewModel.unfollowing(studentId: friend.studentId) {
                        friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                        friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                    }
                }, label: {
                    Text("팔로잉")
                        .font(.m12)
                        .foregroundColor(Color.sattoPurple)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 26)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.sattoPurple, lineWidth: 1)
                        )
                        .padding(.trailing, 20)
                })
            }
            // 내가 보고있는 친구가 내 정보면 버튼 표시하지 않음
            else if friend == friendViewModel.friend.first { }
            // 내가 보고있는 친구가 내 팔로잉 목록에 없으면 팔로잉 버튼 표시
            else if !friendViewModel.myFollowing.contains(friend) {
                Button(action: {
                    // 팔로잉 버튼 누르면 내 팔로잉 팔로워 새로고침, 단 보고있는 목록은 새로고침 하지 않음(인스타처럼)
                    friendViewModel.followingRequest(studentId: friend.studentId) {
                        friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                        friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") { }
                    }
                }, label: {
                    Text("팔로우")
                        .font(.m12)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 26)
                        .background(
                            Rectangle()
                                .fill(Color.sattoPurple)
                                .cornerRadius(10)
                        )
                        .padding(.trailing, 20)
                })
            }
        }
    }
}
