//
//  ContentView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = Tab.home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem {
                Image(selectedTab == Tab.home ? "home.fill" : "home")
                Text("홈")
            }.tag(Tab.home)
            TimeTableMainView().tabItem {
                Image(selectedTab == Tab.timeTable ? "timeTable.fill" : "timeTable")
                Text("시간표")
            }.tag(Tab.timeTable)
            FriendView().tabItem {
                Image(selectedTab == Tab.friend ? "friend.fill" : "friend")
                Text("친구관리")
            }.tag(Tab.friend)
            EventView().tabItem {
                Image(selectedTab == Tab.event ? "event.fill" : "event")
                Text("이벤트")
            }.tag(Tab.event)
            SettingView().tabItem {
                Image(selectedTab == Tab.setting ? "setting.fill" : "setting")
                Text("설정")
            }.tag(Tab.setting)
        }
        .accentColor(Color.blue7)
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
}
