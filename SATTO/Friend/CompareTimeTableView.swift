//
//  CompareTimeTableView.swift
//  SATTO
//
//  Created by 황인성 on 4/4/24.
//

import SwiftUI

struct CompareTimeTableView: View {
    
    @State var showFriendSheet: Bool = false
    @State var text: String = ""
    @State var compareFriendCount = 0
    @State var showResult: Bool = true
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb16)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
                HStack(spacing: 0) {
                    Image("info.friend")
                        .padding(.trailing, 5)
                    
                    Text("내가 팔로잉하는 친구만 확인 가능합니다.")
                        .font(.m12)
                        .foregroundColor(Color.gray500)
                        .padding(.trailing, 20)
                    if !friendViewModel.compareFriends.isEmpty {
                        Button(action: {
                            showFriendSheet.toggle()
                        }, label: {
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.sattoPurple)
                        })
                    }
                }
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            
            if friendViewModel.compareFriends.isEmpty {
                
                HStack(spacing: 0) {
                    
                    ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                    
                    Circle()
//                        .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.2))
                        .frame(width: 7, height: 7)
                        .padding(.trailing, 7)
                        .padding(.leading, 30)
                    Circle()
//                        .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.5))
                        .frame(width: 7, height: 7)
                        .padding(.trailing, 7)
                    Circle()
//                        .fill(Color(red: 0.26, green: 0.56, blue: 1))
                        .frame(width: 7, height: 7)
                        .padding(.trailing, 30)
                    
                    
                    Button(action: {
                        showFriendSheet.toggle()
                    }, label: {
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color.sattoPurple)
                    })
                }
                .padding(.vertical, 20)
            }
            else {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: 30)
                            
                            ForEach(friendViewModel.compareFriends, id: \.studentId) { friend in
                                VStack(spacing: 0) {
                                    ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                                        .padding(.bottom, 10)
                                    Text("\(friend.name)")
                                        .font(.m12)
                                }
                                .padding(.trailing, 30)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    Button(action: {
                        friendViewModel.postCompareTimeTable(studentIds: friendViewModel.compareFriends.map{ $0.studentId })
                        print(friendViewModel.compareFriends.map{ $0.studentId })
                    }, label: {
                        Text("겹치는 시간표 조회")
                    })
                }
            }
        }
        .background(
            Color.info60
        )
        .sheet(isPresented: $showFriendSheet) {
            CompareFriendSearchView(friendViewModel: friendViewModel)
        }
        
        Spacer()
    }
}

struct CompareFriendSearchView: View {
    
    @State var text = ""
    var TextFieldPlacehold: String = "팔로잉 목록"
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0){
                HStack(spacing: 0) {
//                    CustomBackButton()
//                        .padding(.leading, 20)
                    ClearButtonTextField(placehold: TextFieldPlacehold, text: $text)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                .padding(.top, 20)
                
                Divider()

                ScrollView {
                    // 네트워크 없이 로컬에서 검색
                    // 이름과 학번 모두 검색 가능
                    ForEach(friendViewModel.following.filter {
                        text.isEmpty || $0.name.contains(text) || $0.studentId.contains(text)
                    }, id: \.studentId) { friend in
                        // 마이페이지든 친구페이지든 followingCell로 표시
                        CompareFriendSearchCell(friend: friend, friendViewModel: friendViewModel)
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

struct CompareFriendSearchCell: View {
    
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
            
//            Button(action: {
//                // 내 정보와 일치하는 친구는 친구페이지로 이동 불가
//                if friend == friendViewModel.friend.first { }
//                // friend목록에 추가하고 뷰 이동
//                else {
//                    friendViewModel.friend.append(friend)
//                    navPathFinder.addPath(route: .friend)
//                }
//                
//                friendViewModel.compareFriends.append(friend)
//            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text(friend.name)
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    Text(friend.studentId)
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
//            })
            
            Spacer()
            
            if friendViewModel.compareFriends.contains(friend) {
                Image("Tick Square")
                    .renderingMode(.template)
                    .foregroundStyle(Color.blue)
                    .padding(.trailing, 20)
            }
            else {
                Image("Tick Square")
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray)
                    .padding(.trailing, 20)
            }
        }
        .onTapGesture {
            if friendViewModel.compareFriends.contains(friend) {
                if let index = friendViewModel.compareFriends.firstIndex(of: friend) {
                    friendViewModel.compareFriends.remove(at: index)
                }
            }
            else {
                friendViewModel.compareFriends.append(friend)
            }
        }
    }
}

struct CompareFriendCell: View {
    
    var name: String
    var studentID: Int
    var isFollowing: Bool
    
    
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
                
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    // m16
                    Text("20201499")
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    
                    // m12
                    Text("한민재")
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            
            Spacer()
            
            if isFollowing {
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
            }
            
            else {
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
                
            }
            
            
            
        }
        
    }
}


struct CompareTimeTableResultView: View {
    
//    @State var showFriendSheet: Bool = false
//    @State var text: String = ""
//    @State var compareFriendCount = 0
//    @State var showResult: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb16)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            
//            HStack(spacing: 0) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        
                        ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                        
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.2))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 7)
//                            .padding(.leading, 30)
//
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.5))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 7)
//                        
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 30)
//                        
//                        Image(systemName: "person.badge.plus")
//                            .frame(width: 65, height: 65)
//                            .foregroundStyle(Color.sattoPurple)
                        
                        ForEach(0 ..< 10) { item in
                            ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                                .padding(.trailing, 30)
                        }
                    }
                    .padding(.vertical, 20)
                }
                
//            }
//            .padding(.bottom, 14)

            
        }
        .background(
            Color.info60
        )
        
        Spacer()
    }
}




