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

struct EventView: View {
    
    @State private var selectedPage: EventTab = .progressEvent
    @Namespace var namespace
    
    var body: some View {
        
        VStack(spacing: 0) {
            
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
            
            TabView(selection: $selectedPage) {
                
                ScrollView {
                    
                    VStack(spacing: 0){

                        ProgressEventCell(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!")
                            .padding(.top, 27)
                        
                        
                        
                                            }
            
                        
                    }
                    .padding(.horizontal, 20)
                    .tag(EventTab.progressEvent)
                    
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0){
                        AnnouncementOfWinnersCell(announcementOfWinnersTitle: "개강맞이 시간표 경진대회 당첨자 발표", adminProfile: "Avatar", postDate: "Someone  글쓴이・3일 전 ")
                            
                    }
                    .padding(.top, 27)
                
                    
                }
                .padding(.horizontal, 20)
                .tag(EventTab.announcementOfWinners)
                
                
                
                
                
            }
            .tabViewStyle(PageTabViewStyle())
        }
        
    }
}

struct AnnouncementOfWinnersCell: View {
    
    var announcementOfWinnersTitle: String
    var adminProfile: String
    var postDate: String
    
    var body: some View {
        Group {
            HStack(spacing: 0){
                
                Circle().frame(width: 5)
                    .padding(.trailing, 7)
                
                Text(announcementOfWinnersTitle)
                    .font(.m14)
                
            }
            .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                
                Image(adminProfile)
                    .padding(.trailing, 12)
                
                Text(postDate)
                    .font(.m14)
            }
            .padding(.leading, 12)
            .padding(.bottom, 24)
            
            SattoDivider()
                .padding(.bottom, 24)
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

struct ProgressEventCell: View {
    
    var eventName: String
    var eventPeriod: String
    var eventImage: String
    var eventDeadLine: String
    var eventNumberOfParticipants: String
    var eventDescription: String
    
    var body: some View {
        Rectangle()
            .frame(height: 180)
            .overlay(
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(red: 0.98, green: 0.93, blue: 0.79))
                        .frame(height: 100)
                        .overlay(
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(eventName)
                                        .font(.m18)
                                        .padding(.bottom, 10)
                                    
                                    Text(eventPeriod)
                                        .font(.m17)
                                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                }
                                .padding(.leading, 24)
                                .padding(.trailing, 27)
                                
                                Image(eventImage)
                            }
                            ,alignment: .leading
                        )
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 80)
                        .overlay(
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(eventDeadLine)
                                        .font(.m12)
                                        .foregroundColor(Color(red: 0.84, green: 0.36, blue: 0.34))
                                        .padding(.horizontal, 11)
                                        .padding(.vertical, 1)
                                        .background(
                                            Rectangle()
                                                .fill(Color(red: 0.98, green: 0.93, blue: 0.94))
                                                .cornerRadius(5)
                                        )
                                    
                                    Spacer()
                                    
                                    Text(eventNumberOfParticipants)
                                        .font(.m12)
                                    
                                }
                                .padding(.bottom, 8)
                                
                                Text(eventDescription)
                                    .font(.m14)
                                
                                
                            }
                                .padding(.horizontal, 24)
                        )
                }
            )
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.bottom, 37)
    }
}

#Preview {
    EventView()
}

