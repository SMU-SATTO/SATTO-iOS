//
//  EventView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

enum EventTab {
    case progressEvent
    case announcementOfWinners
}


enum EventRoute: Hashable {
    case progressEvent
    case announcementEvent
    // progressEvent에서 컬러를 전달받기 위해 변수 설정
    case detailProgressEvent(color: Color)
    case uploadEventImage
    case detailAnnouncementEvent
}

final class EventNavigationPathFinder: ObservableObject {
    static let shared = EventNavigationPathFinder()
    private init() { }
    
    @Published var path: [EventRoute] = []
    
    func addPath(route: EventRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}

struct EventView: View {
    
    @State private var selectedPage: EventTab = .progressEvent
    
    @StateObject var eventViewModel = EventViewModel()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    
    var body: some View {
        
        NavigationStack(path: $navPathFinder.path) {
            VStack(spacing: 0) {
                
                EventTopTabBar(selectedPage: $selectedPage)
                
                TabView(selection: $selectedPage) {
                    ProgressEventView(eventViewModel: eventViewModel)
                        .tag(EventTab.progressEvent)
                    
                    AnnouncementEventView(eventViewModel: eventViewModel)
                        .tag(EventTab.announcementOfWinners)
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .onAppear {
                print("이벤트뷰 생성")
                // 내 정보를 가져오면서 이벤트 리스트 가져오기
                authViewModel.userInfoInquiry {
                    eventViewModel.getEventList()
                }
                // 다시 이벤트뷰로 돌아올때 내가 보고있는 이벤트 비우기
                eventViewModel.event = nil
            }
            .onDisappear {
                print("이벤트뷰 사라짐")
            }
            .navigationDestination(for: EventRoute.self) { route in
                switch route {
                case .progressEvent:
                    ProgressEventView(eventViewModel: eventViewModel)
                case .announcementEvent:
                    AnnouncementEventView(eventViewModel: eventViewModel)
                case .detailProgressEvent(let color):
                    DetailProgressEventView(eventViewModel: eventViewModel, color: color)
                case .uploadEventImage:
                    UploadImageView(eventViewModel: eventViewModel)
                case .detailAnnouncementEvent:
                    DetailAnnouncementEventView(eventViewModel: eventViewModel)
                }
            }
        }
        
    }
}




struct SattoDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color(red: 0.42, green: 0.4, blue: 0.52).opacity(0.2))
            .frame(height: 1)
        
    }
}

struct EventTopTabBar: View {
    
    @Binding var selectedPage: EventTab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("진행 중인 이벤트")
                    .font(.b14)
                    .foregroundColor(selectedPage == .progressEvent ? .black : .gray)
                    .onTapGesture {
                        withAnimation {
                            selectedPage = .progressEvent
                        }
                    }
                    .padding(.bottom, 19)
                    .background(
                        Rectangle()
                            .fill(selectedPage == .progressEvent ? Color.sattoPurple : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(30)
                        ,alignment: .bottom
                    )
                    .padding(.trailing, 24)
                
                Text("당첨자 발표")
                    .font(.system(size: 14))
                    .foregroundColor(selectedPage == .announcementOfWinners ? .black : .gray)
                    .onTapGesture {
                        withAnimation {
                            selectedPage = .announcementOfWinners
                        }
                    }
                    .padding(.bottom, 19)
                    .background(
                        Rectangle()
                            .fill(selectedPage == .announcementOfWinners ? Color.sattoPurple : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(30)
                        ,alignment: .bottom
                    )
                Spacer()
            }
            .background(
                SattoDivider()
                    .padding(.bottom, 1)
                ,alignment: .bottom
            )
        }
        .padding(.horizontal, 20)
    }
}
