//
//  DetailAnnouncementEventView.swift
//  SATTO
//
//  Created by 황인성 on 8/31/24.
//

import SwiftUI

struct DetailAnnouncementEventView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .frame(height: 0)
                    
                    HStack(spacing: 0) {
                        Text("\(eventViewModel.event?.category ?? "category")")
                            .font(.m18)
                            .padding(.trailing, 7)
                        
                        EventTimerView(text: "종료")
                    }
                    .padding(.bottom, 6)
                    
                    Text("\(eventViewModel.event?.formattedStartWhen ?? "2024.01.01") - \(eventViewModel.event?.formattedUntilWhen ?? "2024.01.01")")
                        .font(.m17)
                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                        .padding(.bottom, 5)
                    
                    Text("\(eventViewModel.event?.participantsCount ?? 999)명이 참여했어요!")
                        .font(Font.custom("Pretendard", size: 12))
                        .foregroundColor(Color(red: 0.72, green: 0.25, blue: 0.25))
                        .padding(.bottom, 10)
                }
            }
            .padding(.leading, 25)
            .padding(.top, 10)
            .padding(.bottom, 17)
            .background(Color(red: 0.91, green: 0.95, blue: 1))
            
                ScrollView {
                    // 젤 위에만 20 뛰우고
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(spacing: 0){
                        Rectangle()
                            .frame(height: 0)

                        // 피드배열에서 앞에서 3개의 인덱스 추출
                        // 만약 3개보다 적으면 그 개수만 추출
                        ForEach(eventViewModel.feeds.prefix(3).indices, id: \.self) { index in
                            
                            // 추출한 인덱스로 좋아요수로 정렬된 피드 배열에서 피드를 저장
                            let feed = eventViewModel.feeds.sorted(by: { $0.likeCount > $1.likeCount }).prefix(3)[index]
                            // 메달 색은 최대 3개
                            let color = eventViewModel.medalColors[index]
                            
                            EndEventFeedCell(eventViewModel: eventViewModel, feed: feed, color: color)
                            
                            // 그 다음부터는 밑에 40씩 뛰운다
                            Spacer()
                                .frame(height: 40)
                        }
                    }
                    .padding(.horizontal, 60)
                }
        }// Vstsck
        .onAppear {
            eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "잘못된 요청")
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 0) {
                    CustomBackButton()
                    CustomNavigationTitle(title: "당첨자 발표")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct EndEventFeedCell: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var feed: Feed
    // 메달 색깔
    var color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "medal.fill")
                    .resizable()
                    .frame(width: 33, height: 33)
                    .padding(.trailing, 7)
                    .padding(.bottom, 3)
                    .foregroundStyle(color)
                
                Text("\(feed.studentId) \(feed.name)")
                    .font(.sb18)
                
                Spacer()
            }
            
            ZStack(alignment: .bottom){
                AsyncImage(url: URL(string: feed.photo)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 266, height: 266)
                
                ZStack {
                    Rectangle()
                        .frame(width: 266, height: 28)
                    HStack(spacing: 0) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(feed.isLiked ? .red : .white)
                            .padding(.trailing, 12)
                        
                        Text("\(feed.likeCount)")
                            .font(.m12)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .frame(width: 266)
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}

