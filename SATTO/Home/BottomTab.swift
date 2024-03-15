//
//  BottomBar.swift
//  SATTO
//
//  Created by 황인성 on 3/15/24.
//

import SwiftUI

struct BottomTab: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem {
                Image("home")
                Text("홈")
            }.tag(1)
            TimeTableMainView().tabItem {
                Image("timeTable")
                Text("시간표")
            }.tag(2)
            FriendView().tabItem {
                Image("friend")
                Text("친구관리")
            }.tag(3)
            EventView().tabItem {
                Image("event")
                Text("이벤트")
            }.tag(4)
            SettingView().tabItem {
                Image("setting")
                Text("설정")
            }.tag(5)
        }
        .accentColor(Color.blue7)
    }
}

#Preview {
    BottomTab()
}
