//
//  ContentView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = Tab.setting
    @State private var stackPath: [Route] = []
    
    var body: some View {

//        NavigationStack(path: $stackPath){
            TabView(selection: $selectedTab) {
                HomeView().tabItem {
                    Image(selectedTab == Tab.home ? "home.fill" : "home")
                    Text("홈")
                }.tag(Tab.home)
                TimetableMainView(stackPath: $stackPath).tabItem {
                    Image(selectedTab == Tab.timeTable ? "timeTable.fill" : "timeTable")
                    Text("시간표")
                }.tag(Tab.timeTable)
                FriendView()
                    .environmentObject(FriendNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.friend ? "friend.fill" : "friend")
                    Text("친구관리")
                }.tag(Tab.friend)
                EventView()
                    .environmentObject(NavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.event ? "event.fill" : "event")
                    Text("이벤트")
                }.tag(Tab.event)
                SettingView().tabItem {
                    Image(selectedTab == Tab.setting ? "setting.fill" : "setting")
                    Text("설정")
                }.tag(Tab.setting)
            }
            .accentColor(Color.blue7)
            .navigationDestination(for: Route.self) { route in
                switch route {
//                case .search:
//                    SearchView(stackPath: $stackPath, TextFieldPlacehold: "친구의 학번을 입력해 주세요")
//                case .followerSearch:
//                    SearchView(stackPath: $stackPath, TextFieldPlacehold: "팔로워 목록")
//                case .followingSearch:
//                    SearchView(stackPath: $stackPath, TextFieldPlacehold: "팔로잉 목록")
//                case .friend:
//                    FriendView(stackPath: $stackPath)
                case .timetableMake:
                    TimetableMakeView(stackPath: $stackPath)
                case .timetableOption:
                    TimetableOptionView(stackPath: $stackPath)
                case .timetableCustom:
                    TimetableCustom(stackPath: $stackPath)
//                case .event:
//                    EventView(stackPath: $stackPath)
//                case .progressEvent:
//                    ProgressEventView(stackPath: $stackPath)
//                case .announcementEvent:
//                    AnnouncementEventView(stackPath: $stackPath)
                default:
                    EmptyView()
                }
            }
//        }
    }
}

enum Route: Hashable {
//    case search
//    case followerSearch
//    case followingSearch
//    case friend
    case timetableMake
    case timetableOption
    case timetableCustom
//    case event
//    case progressEvent
//    case announcementEvent
//    case detailProgressEvent
}

enum Tab: String {
    case home = "home"
    case timeTable = "timeTable"
    case friend = "friend"
    case event = "event"
    case setting = "setting"
}

#Preview {
    ContentView()
        .environmentObject(NavigationPathFinder.shared)
}
