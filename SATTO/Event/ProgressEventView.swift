//
//  ProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct ProgressEventView: View {
    @State private var selectedPage: EventTab = .progressEvent
    @Namespace var namespace
    
//    @Binding var stackPath: [Route]
    @ObservedObject var eventViewModel: EventViewModel
    @EnvironmentObject var navPathFinder: NavigationPathFinder
    
    var body: some View {
        
        VStack(spacing: 0) {
            
                ScrollView {
                    
                    VStack(spacing: 0){
                        
                        Spacer()
                            .frame(height: 27)
                        
                        ForEach(eventViewModel.eventList, id: \.eventId) { event in
                            
                            Button(action: {
                                navPathFinder.addPath(route: .detailProgressEvent)
                                eventViewModel.event = event
                            }, label: {
                                ProgressEventCell(event: event)
                            })
                            .disabled(eventViewModel.이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .yet || eventViewModel.이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .end)
                            
                            Spacer()
                                .frame(height: 37)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    
                }
                
        }
        
    }
}

struct ProgressEventCell: View {
    
    var event: Event
    
    var body: some View {
        
        ZStack {
            
            if 이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .yet {
                Color.gray
                    .opacity(0.5)
                    .cornerRadius(10)
                    .overlay {
                        Text("Coming Soon")
                            .font(.title)
                    }
                    .zIndex(1)
            }
            else if 이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .end {
                Color.gray
                    .opacity(0.5)
                    .cornerRadius(10)
                    .overlay {
                        Text("종료된 이벤트")
                            .font(.title)
                    }
                    .zIndex(1)
            }
            
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
                                        
                                        Text(event.category)
                                            .font(.m18)
                                            .padding(.bottom, 10)
                                        
                                        Text("\(event.formattedStartWhen) - \(event.formattedUntilWhen)")
                                            .font(.m17)
                                            .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                    }
                                    .padding(.leading, 24)
                                    .padding(.trailing, 27)
                                    
                                    Image("sb")
                                    
                                }
                                ,alignment: .leading
                            )
                        
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 80)
                            .overlay(
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        
                                        if 이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .yet {
                                            Text("시작까지 \(오늘날짜와의간격(dateString: event.formattedStartWhen))일 남음")
                                                .font(.m12)
                                                .foregroundColor(Color(red: 0.84, green: 0.36, blue: 0.34))
                                                .padding(.horizontal, 11)
                                                .padding(.vertical, 1)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color(red: 0.98, green: 0.93, blue: 0.94))
                                                        .cornerRadius(5)
                                                )
                                        }
                                        else if 이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .end {
                                            Text("종료")
                                                .font(.m12)
                                                .foregroundColor(Color(red: 0.84, green: 0.36, blue: 0.34))
                                                .padding(.horizontal, 11)
                                                .padding(.vertical, 1)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color(red: 0.98, green: 0.93, blue: 0.94))
                                                        .cornerRadius(5)
                                                )
                                        }
                                        else if 이벤트상태출력(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .progress {
                                            Text("\(오늘날짜와의간격(dateString: event.formattedUntilWhen))일 남음")
                                                .font(.m12)
                                                .foregroundColor(Color(red: 0.84, green: 0.36, blue: 0.34))
                                                .padding(.horizontal, 11)
                                                .padding(.vertical, 1)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color(red: 0.98, green: 0.93, blue: 0.94))
                                                        .cornerRadius(5)
                                                )
                                        }
                                        
                                            
                                        
                                        Spacer()
                                        
                                        Text("\(event.participantsCount)명 참여")
                                            .font(.m12)
                                        
                                    }
                                    .padding(.bottom, 8)
                                    
                                    Text(event.content)
                                        .font(.m14)
                                    
                                    
                                }
                                    .padding(.horizontal, 24)
                            )
                    }
                )
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
    
    func 오늘날짜와의간격(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let today = Date()
        
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("Invalid date format")
        }
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: today, to: date)
        
        if let days = components.day {
            print("Number of days between dates: \(days)")
            return days
        }
        else {
            return 99
        }
    }
    
    func 이벤트상태출력(startDate: String, endDate: String) -> EventState {
        if 오늘날짜와의간격(dateString: startDate) < 0 && 오늘날짜와의간격(dateString: endDate) < 0 {
            return .end
        }
        else if 오늘날짜와의간격(dateString: startDate) <= 0 && 오늘날짜와의간격(dateString: endDate) >= 0 {
            return .progress
        }
        else if 오늘날짜와의간격(dateString: startDate) > 0 {
            return .yet
        }
        else {
            return .error
        }
    }
}



#Preview {
    ProgressEventView(eventViewModel: EventViewModel())
}
