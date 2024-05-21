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
    
    @State var show = false
    @Namespace var namespace
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    
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
                                                Text("12")
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
                                                Text("12")
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
                                    
                                    
                                    Text("한민재 20201499")
                                        .font(.sb16)
                                        .foregroundColor(Color.gray800)
                                        .matchedGeometryEffect(id: "name", in: namespace)
                                        .padding(.bottom, 5)
                                    
                                    Text("컴퓨터과학과")
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
                        
                    }
                    .navigationBarBackButtonHidden()
                    .navigationDestination(for: FriendRoute.self) { route in
                        switch route {
                        case .search:
                            SearchView(TextFieldPlacehold: "친구의 학번을 입력해 주세요")
                        case .followerSearch:
                            SearchView(TextFieldPlacehold: "팔로워 목록")
                        case .followingSearch:
                            SearchView(TextFieldPlacehold: "팔로잉 목록")
                        case .friend:
                            FriendView()
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
    FriendView()
        .environmentObject(FriendNavigationPathFinder.shared)
}

