//
//  FollwerSearchView.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct FollwerSearchView: View {
    
    var TextFieldPlacehold: String = "팔로워 목록"
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
                    // 네트워크 없이 로컬에서 검색
                    // 이름과 학번 모두 검색 가능
                    ForEach(friendViewModel.follower.filter {
                        text.isEmpty || $0.name.contains(text) || $0.studentId.contains(text)
                    }, id: \.studentId) { friend in
                        
                        // friend목록에 하나만 들어있으면 그건 내 정보니까 follwerCell표시
                        // 이유: 내 팔로워목록은 팔로잉이 아닌 삭제라는 버튼을 표시하기 때문
                        if friendViewModel.friend.count == 1 {
                            MyFollowerFriendCell(friend: friend, friendViewModel: friendViewModel)
                                .padding(.bottom, 15)
                                .padding(.top, 10)
                        }
                        // 아니면 followingCell표시
                        else {
                            FollowingFriendCell(friend: friend, friendViewModel: friendViewModel)
                                .padding(.bottom, 15)
                                .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                // 내가 보고있는 친구의 팔로워 조회
                friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
            }
        }
    }
}


struct MyFollowerFriendCell: View {
    
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
                // friend목록에 추가하고 뷰 이동
                friendViewModel.friend.append(friend)
                navPathFinder.addPath(route: .friend)
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
            
            // 내 팔로워(나를 팔로잉하는 유저) 삭제하는 버튼
            Button(action: {
                // 삭제버튼을 누르면
                friendViewModel.unfollow(studentId: friend.studentId) {
                    // 내 팔로잉, 팔로워 새로고침
                    friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                        // 목록에 즉시 반영
                        friendViewModel.follower = friendViewModel.myFollower
                    }
                    friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                        // 목록에 즉시 반영
                        friendViewModel.following = friendViewModel.myFollowing
                    }
                }
            }, label: {
                Text("삭제")
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
    }
}
