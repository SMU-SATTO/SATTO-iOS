//
//  ContentView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = Tab.event
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {

            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(HomeNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.home ? "home.fill" : "home")
                    Text("홈")
                }.tag(Tab.home)
                TimetableMainView().tabItem {
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
                    .environmentObject(NavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.event ? "event.fill" : "event")
                    Text("이벤트")
                }.tag(Tab.event)
                SettingView()
                    .environmentObject(SettingNavigationPathFinder.shared)
                    .tabItem {
                    Image(selectedTab == Tab.setting ? "setting.fill" : "setting")
                    Text("설정")
                            .accentColor(.accentColor)
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
        .environmentObject(NavigationPathFinder.shared)
}
