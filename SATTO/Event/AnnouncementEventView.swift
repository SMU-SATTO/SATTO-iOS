//
//  AnnouncementEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct AnnouncementEventView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0){
                Rectangle()
                    .frame(height: 0)

                ForEach(eventViewModel.eventList.filter { eventViewModel.이벤트상태출력(startDate: $0.formattedStartWhen, endDate: $0.formattedUntilWhen) == .progress }, id: \.eventId) { endEvent in
                    
                    Button(action: {
                        eventViewModel.event = endEvent
                        navPathFinder.addPath(route: .detailAnnouncementEvent)
                        
                    }, label: {
                        AnnouncementEventCell(eventViewModel: eventViewModel, event: endEvent)
                    })
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct AnnouncementEventCell: View {

    @ObservedObject var eventViewModel: EventViewModel
    
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0){
                Circle().frame(width: 5)
                    .padding(.trailing, 7)
                
                Text("\(event.category) 당첨자 발표")
                    .font(.m14)
            }
            .padding(.bottom, 20)
            
            Text("\(eventViewModel.오늘날짜와의간격(dateString: event.formattedUntilWhen) * -1)일 전에 종료됨")
                .font(.m14)
                .padding(.leading, 12)
                .padding(.bottom, 24)
            
            SattoDivider()
        }
        .padding(.top, 24)
    }
}

#Preview {
    AnnouncementEventView(eventViewModel: EventViewModel())
}
