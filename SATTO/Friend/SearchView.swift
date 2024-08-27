//
//  SearchView.swift
//  SATTO
//
//  Created by 황인성 on 3/29/24.
//

import SwiftUI

struct SearchView: View {
    
    var TextFieldPlacehold: String = "친구의 학번을 입력해 주세요"
    @State var text = ""
    
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
                    // 뷰모델의 searchUsers라는 다른 변수 사용
                    ForEach(friendViewModel.searchUsers, id: \.studentId) { friend in
                        FriendCell(friend: friend, friendViewModel: friendViewModel)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                // 네트워크 필요
                friendViewModel.searchUser(studentIdOrName: text)
            }
            .onDisappear {
                // 뷰가 사라질때 searchUsers 비우기
                friendViewModel.searchUsers = []
            }
            .onChange(of: text) { _ in
                // 네트워크 필요
                friendViewModel.searchUser(studentIdOrName: text)
            }
        }
    }
}

struct FriendCell: View {
    
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
                // 내 프로필을 누르면 아무동작도 안함
                if friend == friendViewModel.friend.first { }
                // 내 프로필이랑 다르면 friend배열에 추가하고 뷰 이동
                else {
                    navPathFinder.addPath(route: .friend)
                    friendViewModel.friend.append(friend)
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
            
            // 내가 보고있는 친구가 내 팔로잉 목록에 있으면 언팔로잉 버튼 표시
            if friendViewModel.myFollowing.contains(friend) {
                Button(action: {
                    // 언팔로잉 하면 내 팔로워, 팔로잉 새로고침
                    friendViewModel.unfollowing(studentId: friend.studentId) {
                        friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
                        friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
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
            // 내가 보고있는 친구가 내 정보면 아무 버튼도 표시하지 않음
            else if friend == friendViewModel.friend.first { }
            // 내가 보고있는 친구가 내 팔로잉목록에 없으면 팔로우 버튼 표사
            else if !friendViewModel.myFollowing.contains(friend) {
                Button(action: {
                    friendViewModel.followingRequest(studentId: friend.studentId) {
                        friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
                        friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "friendViewModel.friend 비어있음") { }
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

