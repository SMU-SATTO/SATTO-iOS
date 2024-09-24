//
//  ContentView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = Tab.friend
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dependencyContainer) var container: DIContainer?
    
    var body: some View {
        let container = container ?? DIContainer(appState: AppState(), services: AppEnvironment.Services.preview(appState: AppState()))

            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .environmentObject(HomeNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.home ? "home.fill" : "home")
                    Text("홈")
                }.tag(Tab.home)
                TimetableMainView(timetableMainViewModel: TimetableMainViewModel(container: container)).tabItem {
                    Image(selectedTab == Tab.timeTable ? "timeTable.fill" : "timeTable")
                    Text("시간표")
                }.tag(Tab.timeTable)
                MyPageView()
                    .environmentObject(FriendNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.friend ? "friend.fill" : "friend")
                    Text("친구관리")
                }.tag(Tab.friend)
                EventView()
                    .environmentObject(EventNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.event ? "event.fill" : "event")
                    Text("이벤트")
                }.tag(Tab.event)
                SettingView()
                    .environmentObject(SettingNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.setting ? "setting.fill" : "setting")
                    Text("설정")
                }.tag(Tab.setting)
            }
    }
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
        .environmentObject(EventNavigationPathFinder.shared)
}
