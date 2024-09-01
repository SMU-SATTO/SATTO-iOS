//
//  HomeView.swift
//  SATTO
//
//  Created by 황인성 on 7/7/24.
//

import SwiftUI


enum HomedRoute: Hashable {
    case academicNotice
}

final class HomeNavigationPathFinder: ObservableObject {
    static let shared = HomeNavigationPathFinder()
    private init() { }
    
    @Published var path: [HomedRoute] = []
    
    func addPath(route: HomedRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}

struct HomeView: View {
    
    @State var showSafari = false
    @State var urlString = "https://www.smu.ac.kr/kor/life/notice.do"
    
    @EnvironmentObject var navPathFinder: HomeNavigationPathFinder
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject var friendViewModel = FriendViewModel()
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
//                    HStack(spacing: 0) {
//                        Image("menu")
//                        
//                        Spacer()
//                        
//                        Image("alarm")
//                            .padding(.trailing, 20)
//                        
//                        Image("account")
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 13)
                    
                    
                    
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ProfileImageCell(inCircleSize: 58, outCircleSize: 61)
                                .padding(.bottom, 3)
                            
                            Text(authViewModel.user.name)
                                .font(.m10)
                                .foregroundColor(Color(red: 0.27, green: 0.3, blue: 0.33))
                        }
                        .padding(.trailing, 21)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // m12
                            Text("오늘은")
                                .font(.m12)
                            
                            Text("\(todayDateString()) 이에요!")
                                .font(.m12)
                            
                        }
                        
                        Image("st_home")
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(Color(red: 0.73, green: 0.83, blue: 0.98))
                        
                    )
                    
//                    TimeTableTutorial(friendViewModel: friendViewModel)
                    
                    CircularProgressView()
                        .frame(width: 100)
                        .padding(.bottom, 38)
                        .padding(.leading, 20)
                    
                    // b14
                    Text("중요한 정보 모아 보기")
                        .font(.b14)
                        .padding(.leading, 20)
                        .padding(.bottom, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                showSafari = true
//                                navPathFinder.addPath(route: .academicNotice)
                            }, label: {
                                HStack(alignment: .top, spacing: 0) {
                                    Text("학사 공지")
                                        .font(.sb14)
                                    
                                    Image("st_noti 1")
                                }
                                .padding(.vertical, 12)
                                .padding(.leading, 12)
                                .background(
                                    Rectangle()
                                        .fill(Color(red: 0.91, green: 0.94, blue: 0.98))
                                        .frame(width: 150, height: 100)
                                        .cornerRadius(10)
                                )
                                
                            })
                            .padding(.leading, 20)
                            
                            
                            HStack(alignment: .top, spacing: 0) {
                                Text("이벤트")
                                    .font(.sb14)
                                
                                Image("st_event1 1")
                            }
                            .padding(.vertical, 12)
                            .padding(.leading, 12)
                            .background(
                                Rectangle()
                                    .fill(Color(red: 0.98, green: 0.94, blue: 0.84))
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(10)
                            )
                            .padding(.leading, 20)
                            
                            HStack(alignment: .top, spacing: 0) {
                                Text("버스 정보")
                                    .font(.sb14)
                                
                                Image("st_noti 1")
                            }
                            .padding(.vertical, 12)
                            .padding(.leading, 12)
                            .background(
                                Rectangle()
                                    .fill(Color(red: 0.99, green: 0.93, blue: 0.99))
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(10)
                            )
                            .padding(.leading, 20)
                            
                            Spacer()
                                .frame(width: 20)
                        }
                        
                        
                        
                    }
                    .padding(.bottom, 38)
                    
                    // b14
                    Text("친구들 시간표 보러 가기")
                        .font(.b14)
                        .padding(.bottom, 16)
                        .padding(.leading, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            ForEach(friendViewModel.following, id: \.studentId) { friend in
                                VStack(spacing: 0) {
                                    Circle()
                                        .frame(width: 60)
                                        .padding(.bottom, 7)
                                    
                                    Text(friend.name)
                                        .font(.m10)
                                }
                                .padding(.leading, 20)
                            }
                            Spacer()
                                .frame(width: 20)
                        }
                    }
                    
                }
            }
            .onAppear {
                authViewModel.userInfoInquiry {
                    friendViewModel.fetchMyFollowingList(studentId: authViewModel.user.studentId ?? "asd") {
                        friendViewModel.following = friendViewModel.myFollowing
                    }
                }
            }
            .fullScreenCover(isPresented: $showSafari) {
                SafariView(url:URL(string: self.urlString)!)
            }
            .navigationDestination(for: HomedRoute.self) { route in
                switch route {
                case .academicNotice:
                    SafariView(url:URL(string: self.urlString)!)
                    
                }
            }
        }
    }
    
    func todayDateString() -> String {
        // 현재 날짜 가져오기
        let today = Date()

        // DateFormatter 생성
        let dateFormatter = DateFormatter()

        // 한국어로 지역 설정
        dateFormatter.locale = Locale(identifier: "ko_KR")

        // 월, 일, 요일 형식 설정
        dateFormatter.dateFormat = "M월 d일 EEEE"

        // 날짜를 문자열로 변환
        let dateString = dateFormatter.string(from: today)
        
        return dateString
    }
}

struct CircularProgressView: View {
    
    let progress_1: Int = 60
    let progress_2: Int = 33
    let total: Int = 130
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(red: 0.96, green: 0.96, blue: 0.96),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: Double(progress_1 + progress_2) / Double(total))
                .stroke(
                    Color(red: 0.39, green: 0.52, blue: 0),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
            //                .animation(.easeOut, value: progress)
            
            Circle()
                .trim(from: 0, to: Double(progress_1) / Double(total))
                .stroke(
                    Color(red: 0.39, green: 0.52, blue: 1),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
            //                .animation(.easeOut, value: progress)
            VStack(spacing: 0) {
                Text("Uncompleted")
                    .font(.m10)
                    .foregroundColor(Color.gray800)
                
                Text("\(progress_1 + progress_2) / \(total)")
            }
            
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeNavigationPathFinder.shared)
}
