//
//  ProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct ProgressEventView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0){
                    Spacer()
                        .frame(height: 27)
                    
                    ForEach(eventViewModel.eventList.indices, id: \.self) { index in
                        
                        // foreach문을 이벤트 리스트 개수로 반복하면서
                        // 이벤트 리스트 인덱스로 찾기
                        let event = eventViewModel.eventList.sorted(by: { eventViewModel.getEventStatus(startDate: $0.formattedStartWhen, endDate: $0.formattedUntilWhen).rawValue < eventViewModel.getEventStatus(startDate: $1.formattedStartWhen, endDate: $1.formattedUntilWhen).rawValue })[index]
                        // 각 이벤트 리스트마다 색을 부여
                        // 많으면 색을 순회한다
                        let color = eventViewModel.colors[index % eventViewModel.colors.count]
                        
                        Button(action: {
                            navPathFinder.addPath(route: .detailProgressEvent(color: color))
                            eventViewModel.event = event
                        }, label: {
                            ProgressEventCell(eventViewModel: eventViewModel, event: event, color: color)
                        })
                        .disabled(eventViewModel.getEventStatus(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .yet || eventViewModel.getEventStatus(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .end)
                        
                        // 패딩을 주면 빈공간을 눌러도 버튼이 작동한다
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
    
    @ObservedObject var eventViewModel: EventViewModel
    
    var event: Event
    var color: Color
    
    var height: CGFloat = 180
    
    var body: some View {
        ZStack {
            // 종료된 이벤트와 시작안한 이벤트는 앞에 표시
            if eventViewModel.getEventStatus(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .yet {
                Color.gray
                    .opacity(0.5)
                    .cornerRadius(10)
                    .overlay {
                        Text("Coming Soon")
                            .font(.title)
                    }
                    .zIndex(1)
            }
            else if eventViewModel.getEventStatus(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) == .end {
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
                .frame(minHeight: height)
                .overlay(
                    VStack(spacing: 0) {
                        // 윗부분 색깔있는 사각형
                        Rectangle()
                            .fill(color)
                            .frame(height: height * 0.56)
                        // 윗부분 색깔있는 사각형의 내용
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
                        // 아랫부분 흰색 사격형
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: height * 0.44)
                            .overlay(
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        
                                        // 이벤트 시작까지 남은기간 표시
                                        switch eventViewModel.getEventStatus(startDate: event.formattedStartWhen, endDate: event.formattedUntilWhen) {
                                        case .yet:
                                            EventTimerView(text: "시작까지 \(eventViewModel.daysFromToday(dateString: event.formattedStartWhen))일 남음")
                                        case .end:
                                            EventTimerView(text: "종료")
                                        case .progress:
                                            EventTimerView(text: "\(eventViewModel.daysFromToday(dateString: event.formattedUntilWhen))일 남음")
                                        case .error:
                                            EventTimerView(text: "에러")
                                        }
                                        
                                        Spacer()
                                        
                                        // 참여자 수
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
}

struct EventTimerView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
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
}



#Preview {
    ProgressEventView(eventViewModel: EventViewModel())
}
