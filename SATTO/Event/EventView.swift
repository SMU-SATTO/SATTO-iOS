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
    
    @StateObject var eventViewModel = EventViewModel()
    
    @State private var selectedPage: EventTab = .progressEvent
//    @Namespace var namespace
    
    @Binding var stackPath: [Route]
    
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
                
                ProgressEventView(eventViewModel: eventViewModel, stackPath: $stackPath)
                    .tag(EventTab.progressEvent)
                
                
                AnnouncementEventView(stackPath: $stackPath, eventViewModel: eventViewModel)
                    .tag(EventTab.announcementOfWinners)
                
            }
            .tabViewStyle(PageTabViewStyle())
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
    EventView(stackPath: .constant([.event]))
}

//#Preview {
//    DetailProgressEventView(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!", stackPath: .constant(.detailProgressEvent))
//}


