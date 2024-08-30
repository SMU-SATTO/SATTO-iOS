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
    case detailProgressEvent
    case uploadEventImage
}

final class NavigationPathFinder: ObservableObject {
    static let shared = NavigationPathFinder()
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

    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject var eventViewModel = EventViewModel()
    
    @EnvironmentObject var navPathFinder: NavigationPathFinder
    
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
                authViewModel.userInfoInquiry {
                    eventViewModel.getEventList()
                }
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
                case .detailProgressEvent:
                    DetailProgressEventView(eventViewModel: eventViewModel)
                case .uploadEventImage:
                    UploadImageView(eventViewModel: eventViewModel)
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


#Preview {
    EventView()
        .environmentObject(NavigationPathFinder.shared)
}

//#Preview {
//    DetailProgressEventView(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!", stackPath: .constant(.detailProgressEvent))
//}



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
                            .fill(selectedPage == .progressEvent ? Color.red : Color.clear)
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
                            .fill(selectedPage == .announcementOfWinners ? Color.red : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(30)
                        
                        ,alignment: .bottom
                    )
                
                Spacer()
            }
            .background(
                SattoDivider()
                    .padding(.bottom, 1),
                alignment: .bottom
            )
            
        }
        .padding(.horizontal, 20)
    }
}
