//
//  FollwerSearchView.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct FollwerSearchView: View {
    
    @State var text = ""
    //    @Binding var stackPath: [Route]
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    var TextFieldPlacehold: String
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack(spacing: 0) {
                
                Button(action: {
                    navPathFinder.path.popLast()
                }, label: {
                    Image("Classic")
                })
                .padding(.leading, 20)
                
                ClearButtonTextField(placehold: TextFieldPlacehold, text: $text)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 10)
            
            Divider()
            
            ScrollView {
                ForEach(friendViewModel.follower, id: \.studentId) { friend in
                    
                    if friendViewModel.friend.count == 1 {
                        MyFollowerFriendCell(friend: friend, friendViewModel: friendViewModel)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                    else {
                        FollowerFriendCell(friend: friend, friendViewModel: friendViewModel)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                }
            }
            
            Button(action: {
                print(friendViewModel.follower)
            }, label: {
                Text("팔로워 조회")
            })
            Button(action: {
                print(friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "123"))
            }, label: {
                Text("패치팔로워")
            })
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
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
                navPathFinder.addPath(route: .friend)
                friendViewModel.friend.append(friend)
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    // m16
                    Text(friend.name)
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    
                    // m12
                    Text(friend.studentId)
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            
            Spacer()
            
            Button(action: {
                friendViewModel.unfollow(studentId: friend.studentId) {
                    friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019")
                    friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019")
                    
                    friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                        
                    }
                    friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                        
                    }
                    
                }
            }, label: {
                Text("삭제")
                    .font(.m12)
                    .foregroundColor(Color.blue7)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue7, lineWidth: 1)
                        
                    )
                    .padding(.trailing, 20)
                
            })
        }
    }
}

struct FollowerFriendCell: View {
    
    @State var isFollowing = true
    
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
                navPathFinder.addPath(route: .friend)
                friendViewModel.friend.append(friend)
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    // m16
                    Text(friend.name)
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    
                    // m12
                    Text(friend.studentId)
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            
            Spacer()
            
            if isFollowing {
                
                Button(action: {
                    friendViewModel.unfollow(studentId: friend.studentId) {
                        friendViewModel.fetchFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019")
                        friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019")
                    }
                    isFollowing.toggle()
                }, label: {
                    Text("팔로잉")
                        .font(.m12)
                        .foregroundColor(Color.blue7)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 26)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue7, lineWidth: 1)
                            
                        )
                        .padding(.trailing, 20)
                    
                })
                
            }
            
            else {
                
                Button(action: {
                    friendViewModel.followingRequest(studentId: friend.studentId) {
                        friendViewModel.fetchMyFollowerList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                            
                        }
                        friendViewModel.fetchMyFollowingList(studentId: friendViewModel.friend.first?.studentId ?? "2019") {
                            
                        }
                    }
                    isFollowing.toggle()
                }, label: {
                    Text("팔로우")
                        .font(.m12)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 26)
                        .background(
                            Rectangle()
                                .fill(Color.blue7)
                                .cornerRadius(10)
                        )
                        .padding(.trailing, 20)
                })
                
                
            }
            
            
            
        }
        
    }
}
