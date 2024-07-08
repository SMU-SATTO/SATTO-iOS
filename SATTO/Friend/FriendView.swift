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



struct MyPageView: View {
    
    @State var show = false
    @Namespace var namespace
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject var friendViewModel = FriendViewModel()
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack {
            
                    Color(red: 0.92, green: 0.93, blue: 0.94)
                        .ignoresSafeArea(.all)
                    
                ScrollView {
                    VStack(spacing: 0) {
                        
                        navigationBar
                        .padding(.bottom, 53)
                        
                        
                        if !show {

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
                                            .matchedGeometryEffect(id: "profile", in: namespace)
                                        
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
                                    
                                    
                                    Text("\(authViewModel.user?.name ?? "name") \(authViewModel.user?.studentId ?? "studentId")")
                                        .font(.sb16)
                                        .foregroundColor(Color.gray800)
                                        .matchedGeometryEffect(id: "name", in: namespace)
                                        .padding(.bottom, 5)
                                    
                                    Text("\(authViewModel.user?.department ?? "department")")
                                        .font(.m14)
                                        .foregroundColor(Color.gray600)
                                        .padding(.bottom, 23)
                                        .matchedGeometryEffect(id: "major", in: namespace)
                                    
                                    HStack(spacing: 0) {
                                            checkGraduation
                                            
                                            modifyTimetable
                                    }
                                }
                            }
                        }
                        else {
                            GraduationRequirementsView(namespace: namespace, show: $show)
                        }
                        
                        Button(action: {
                            friendViewModel.fetchFollowerList(studentId: authViewModel.user?.studentId ?? "asd")
                        }, label: {
                            Text("팔로워 조회")
                        })
                        Button(action: {
                            friendViewModel.fetchFollowingList(studentId: authViewModel.user?.studentId ?? "asd")
                        }, label: {
                            Text("팔로잉 조회")
                        })
                        Button(action: {
                            friendViewModel.timetableList(studentId: "201910914")
                        }, label: {
                            Text("시간표 조회")
                        })
                        Button(action: {
                            friendViewModel.myTimetableList()
                        }, label: {
                            Text("내시간표 조회")
                        })
                        
                        TimetableView(timetableBaseArray: friendViewModel.timetableInfo)
                        
                    }
                    .onAppear {
                        friendViewModel.fetchFollowerList(studentId: authViewModel.user?.studentId ?? "asd")
                        friendViewModel.fetchFollowingList(studentId: authViewModel.user?.studentId ?? "asd")
                    }
                    .navigationBarBackButtonHidden()
                    .navigationDestination(for: FriendRoute.self) { route in
                        switch route {
                        case .search:
                            SearchView(TextFieldPlacehold: "친구의 학번을 입력해 주세요")
                        case .followerSearch:
                            FollwerSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로워 목록")
                        case .followingSearch:
                            FollwingSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로잉 목록")
                        case .friend:
                            FriendView(friendViewModel: friendViewModel)
                        }
                    }
                }
            }
            
        }
    }
    
    var checkGraduation: some View {
        Text("졸업요건 확인")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.31, blue: 1.0))
                    .cornerRadius(10)
            )
            .padding(.trailing, 32)
            .onTapGesture {
                withAnimation(.spring()){
                    show.toggle()
                }
            }
    }
    
    var modifyTimetable: some View {
        Text("시간표 과목수정")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }
    
    var navigationBar: some View {
        HStack(spacing: 0) {
            if !navPathFinder.path.isEmpty {
                Button(action: {
                    navPathFinder.path.popLast()
                }, label: {
                    Image("Classic")
                })
                .padding(.trailing, 10)
            }
            
            Text("친구관리")
                .font(.b20)
                .foregroundColor(Color.gray900)
            
            Spacer()
            
            if navPathFinder.path.isEmpty {
                Button(action: {
                    navPathFinder.addPath(route: .search)
                }, label: {
                    Image("searchIcon")
                })
            }
        }
        .padding(.horizontal, 20)
    }
}


struct FriendView: View {
    
    @State var show = false
    @Namespace var namespace
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
            ZStack {
            
                    Color(red: 0.92, green: 0.93, blue: 0.94)
                        .ignoresSafeArea(.all)
                    
                ScrollView {
                    VStack(spacing: 0) {
                        
                        navigationBar
                        .padding(.bottom, 53)
                        
                        
                        if !show {

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
                                            .matchedGeometryEffect(id: "profile", in: namespace)
                                        
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
                                    
                                    
                                    Text("\(friendViewModel.friend?.name ?? "name") \(friendViewModel.friend?.studentId ?? "studentId")")
                                        .font(.sb16)
                                        .foregroundColor(Color.gray800)
                                        .matchedGeometryEffect(id: "name", in: namespace)
                                        .padding(.bottom, 5)
                                    
                                    Text("\(friendViewModel.friend?.department ?? "department")")
                                        .font(.m14)
                                        .foregroundColor(Color.gray600)
                                        .padding(.bottom, 23)
                                        .matchedGeometryEffect(id: "major", in: namespace)
                                    
                                    HStack(spacing: 0) {
                                            checkGraduation
                                            
                                            modifyTimetable
                                    }
                                }
                            }
                        }
                        else {
                            GraduationRequirementsView(namespace: namespace, show: $show)
                        }
                        
                        Button(action: {
                            friendViewModel.fetchFollowerList(studentId: friendViewModel.friend?.studentId ?? "asd")
                        }, label: {
                            Text("팔로워 조회")
                        })
                        Button(action: {
                            friendViewModel.fetchFollowingList(studentId: friendViewModel.friend?.studentId ?? "asd")
                        }, label: {
                            Text("팔로잉 조회")
                        })
                        Button(action: {
                            friendViewModel.timetableList(studentId: "201910914")
                        }, label: {
                            Text("시간표 조회")
                        })
                        Button(action: {
                            friendViewModel.myTimetableList()
                        }, label: {
                            Text("내시간표 조회")
                        })
                        
                    }
                    .navigationBarBackButtonHidden()
            }
        }
            .onAppear {
                friendViewModel.fetchFollowerList(studentId: friendViewModel.friend?.studentId ?? "asd")
                friendViewModel.fetchFollowingList(studentId: friendViewModel.friend?.studentId ?? "asd")
            }
    }
    
    var checkGraduation: some View {
        Text("졸업요건 확인")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.31, blue: 1.0))
                    .cornerRadius(10)
            )
            .padding(.trailing, 32)
            .onTapGesture {
                withAnimation(.spring()){
                    show.toggle()
                }
            }
    }
    
    var modifyTimetable: some View {
        Text("시간표 과목수정")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }
    
    var navigationBar: some View {
        HStack(spacing: 0) {
            if !navPathFinder.path.isEmpty {
                Button(action: {
                    navPathFinder.path.popLast()
                }, label: {
                    Image("Classic")
                })
                .padding(.trailing, 10)
            }
            
            Text("친구관리")
                .font(.b20)
                .foregroundColor(Color.gray900)
            
            Spacer()
            
            if navPathFinder.path.isEmpty {
                Button(action: {
                    navPathFinder.addPath(route: .search)
                }, label: {
                    Image("searchIcon")
                })
            }
        }
        .padding(.horizontal, 20)
    }
}

struct GraduationRequirementsView: View {
    
    var namespace: Namespace.ID
    @Binding var show: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ProfileImageCell(inCircleSize: 67, outCircleSize: 70)
                    .shadow(radius: 15, x: 0, y: 10)
                    .padding(.leading, 10)
                    .matchedGeometryEffect(id: "profile", in: namespace)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("한민재 20201499")
                        .font(.sb16)
                        .foregroundColor(Color.gray800)
                        .matchedGeometryEffect(id: "name", in: namespace)
                    
                    Text("컴퓨터과학과")
                        .font(.m14)
                        .foregroundColor(Color.gray600)
                        .matchedGeometryEffect(id: "major", in: namespace)
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                
                Text("공학인증 확인")
                    .font(.sb14)
                    .foregroundColor(.white)
                    .padding(.leading, 38)
                
                Image("VectorTrailing")
                    .padding(.trailing, 32)
            }
            .padding(.vertical,7)
            .background(
                Rectangle()
                    .cornerRadius(20)
            )
            .padding(.bottom, 14)
            
            Text("공식 홈페이지에 있는 공학인증 링크로 연결")
                .font(Font.custom("Inter", size: 8))
                .onTapGesture {
                    withAnimation(.spring()){
                        show.toggle()
                    }
                }
            
            Spacer()
            
            CircularProgressView()
                .frame(width: 116, height: 116)
            
        }
        .padding(.horizontal, 20)
        
    }
}




struct ProfileImageCell: View {
    
    var inCircleSize: CGFloat
    var outCircleSize: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: outCircleSize, height: outCircleSize)
            .overlay(
                Circle()
                    .frame(width: inCircleSize, height: inCircleSize)
            )
            .shadow(radius: 15, x: 0, y: 10)
    }
}



struct GraduationRequirementsView2: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                    Button(action: {
                        navPathFinder.path.popLast()
                    }, label: {
                        Image("Classic")
                    })
                    .padding(.trailing, 10)
                    .padding(.leading, 20)
                
                
                Text("졸업 요건 확인하기")
                    .font(.b20)
                    .foregroundColor(Color.gray900)
                
                Spacer()
            }
            
            Spacer()
            
            Image("GraduationRequirement")
                .padding(.bottom, 26)
            
            // m16
            Text("들었던 과목이 존재하지 않아 \n졸업 요건을 확인할 수 없어요.")
                .font(.m16)
                .lineSpacing(4)
              .foregroundColor(Color.gray400)
              .padding(.bottom, 57)
            
            // sb14
            Text("들었던 과목 선택하기")
                .font(.sb14)
                .foregroundColor(Color.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 75)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue7)
                )
            
            Spacer()
            Spacer()
        }
    }
}

struct SelectCompletedSubjectsView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @State var selection = 1
    @State var text = ""
    
    var body: some View {
        ZStack {
            
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                        Button(action: {
                            navPathFinder.path.popLast()
                        }, label: {
                            Image("Classic")
                        })
                        .padding(.trailing, 10)
                    
                    
                    Text("졸업 요건 확인하기")
                        .font(.b20)
                        .foregroundColor(Color.gray900)
                    
                    Spacer()
                }
                .padding(.bottom, 25)
                
                Picker(selection: $selection, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("24학년도 1학기 시간표")
                      .tag(1)
                    Text("1").tag(2)
                    Text("2").tag(3)
                }
                .tint(Color.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
                
                ClearButtonTextField2(placehold: "들었던 과목을 입력해 주세요", text: $text)
                    .padding(.bottom, 20)
                
                
                LectureTable()
                
                Spacer()
                
                
                // sb14
                Text("들었던 과목 저장하기")
                    .font(.sb14)
                  .foregroundColor(Color.white)
                  .padding(.vertical, 13)
                  .frame(maxWidth: .infinity)
                  .background(
                    RoundedRectangle(cornerRadius: 8)
                      .fill(Color.blue7)
                      .padding(.horizontal, 40)
                  )
                  .padding(.bottom, 20)
                
                Text("해당 학기 시간표 수정하기")
                    .font(.sb14)
                  .foregroundColor(Color.blue7)
                  .padding(.vertical, 13)
                  .frame(maxWidth: .infinity)
                  .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue7, lineWidth: 1)
                        .padding(.horizontal, 40)
                  )
                
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ClearButtonTextField2: View {
    
    var placehold: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            
            Image("searchIcon")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.50))
                .frame(width: 24, height: 24)
                .padding(.leading, 12)
                .padding(.trailing, 6)
            
            TextField(placehold, text: $text)
            
            Spacer()
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image("Icon")
                        .padding(.trailing, 10)
                }
            }
            
        }
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(Color(red: 0.91, green: 0.92, blue: 0.93))
                .cornerRadius(30)
        )
    }
}


#Preview {
    MyPageView()
        .environmentObject(FriendNavigationPathFinder.shared)
}

#Preview {
    GraduationRequirementsView2()
        .environmentObject(FriendNavigationPathFinder.shared)
}

#Preview {
    SelectCompletedSubjectsView()
        .environmentObject(FriendNavigationPathFinder.shared)
}

struct LectureTable: View {
    var body: some View {
        
        
        ScrollView(showsIndicators: true) {
            ZStack(alignment: .top) {
                
                
                    Text("\u{200B}")
                        .font(.m11)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.89, green: 0.91, blue: 1.00)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 10,
                                    topTrailingRadius: 10
                                )
                        ))

                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("학수번호-분반")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("HAAC0012-1")
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.leading, 18)
                    
                    
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학년")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("3")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("교과목명")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("경제학의이해")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("이수구분")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("1전심")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학점")
                            .padding(.vertical, 8)
                            .padding(.trailing, 29)

                        ForEach(0..<100){_ in
                            HStack(spacing: 0) {
                                Text("3")
                                    .padding(.vertical, 8)
                                    .padding(.trailing, 15)
                                
                                Image(systemName: "plus.circle.dashed")
                                    .frame(width: 14, height: 14)
                                
                            }
                        }
                    }
                }
                .font(.m11)
            }
        }
    }
}
