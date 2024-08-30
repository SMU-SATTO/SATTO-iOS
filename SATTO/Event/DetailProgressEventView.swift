//
//  DetailProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct DetailProgressEventView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: NavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    let columns = [
        //        GridItem(.flexible(), spacing: 0),
        //                GridItem(.flexible())
        GridItem(.fixed(165), spacing: 23),
        GridItem(.fixed(165))
    ]
    
    @State var sort = "좋아요 순"
    
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
                        
                        Text("\(eventViewModel.오늘날짜와의간격(dateString: eventViewModel.event?.formattedUntilWhen ?? "2024.01.01"))일 남음")
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
                    .padding(.bottom, 6)
                    
                    Text("\(eventViewModel.event?.formattedStartWhen ?? "2024.01.01") - \(eventViewModel.event?.formattedUntilWhen ?? "2024.01.01")")
                        .font(.m17)
                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                        .padding(.bottom, 5)
                    
                    Text("마음에 드는 사진에 좋아요를 눌러 주세요!")
                        .font(Font.custom("Pretendard", size: 12))
                        .foregroundColor(Color(red: 0.72, green: 0.25, blue: 0.25))
                        .padding(.bottom, 10)
                    
                    
                    HStack(spacing: 0) {
                        
                        Text("내 사진 자랑하기")
                            .font(.sb14)
                            .foregroundColor(Color(red: 0.28, green: 0.18, blue: 0.89))
                            .padding(.leading, 27)
                        
                        Image("VectorTrailing.blue")
                            .padding(.trailing, 16)
                    }
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(30)
                    )
                }
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Image("eventImage")
                        .resizable()
                        .frame(width: 127, height: 127)
                }
                
            }
            .padding(.leading, 25)
            .padding(.top, 22)
            .padding(.bottom, 17)
            .background(Color(red: 0.91, green: 0.95, blue: 1))
            
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 0)
                        
                        HStack(spacing: 0) {
                            Text("게시물 유형")
                                .font(.sb12)
                                .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                                .padding(.top, 10)
                                .padding(.bottom, 12)
                            
                            Picker(selection: $sort, label: Text("sort")) {
                                Text("좋아요 순").tag("좋아요 순")
                                Text("최신순").tag("최신순")
                                Text("내가 올린 게시글만").tag("내가 올린 게시글만")
                            }
                            
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(sortedFeeds(), id: \.contestId.wrappedValue) { $feed in
                                EventFeedCell(eventViewModel: eventViewModel, feed: $feed)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    //                .background(Color.blue)
                }
                
                Button(action: {
                    navPathFinder.addPath(route: .uploadEventImage)
                }, label: {
                    Circle()
                        .fill(Color(red: 0.28, green: 0.18, blue: 0.89))
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 30)
                })
                
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
                    CustomNavigationTitle(title: "이벤트")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // 선택된 정렬 기준에 따라 feeds를 정렬하는 함수
    func sortedFeeds() -> [Binding<Feed>] {
        switch sort {
        case "좋아요 순":
            return $eventViewModel.feeds.sorted(by: { $0.likeCount.wrappedValue > $1.likeCount.wrappedValue })
        case "최신순":
            return $eventViewModel.feeds.sorted(by: { $0.updatedAt.wrappedValue > $1.updatedAt.wrappedValue })
        case "내가 올린 게시글만":
            return $eventViewModel.feeds.filter { $0.studentId.wrappedValue == authViewModel.user.studentId }
        default:
            return $eventViewModel.feeds.map { $0 }
        }
    }

}

struct EventFeedCell: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var feed: Feed
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            AsyncImage(url: URL(string: feed.photo)) { image in
                        image
                            .resizable()
//                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 165, height: 165)
            
            ZStack {
                Rectangle()
                    .frame(width: 165, height: 28)
                HStack(spacing: 0) {
                    Button(action: {
                        eventViewModel.postContestLike(contestId: feed.contestId) {
                            // api요청 아끼는법
                            if feed.isLiked == true {
                                feed.isLiked = false
                                feed.likeCount -= 1
                            }
                            else {
                                feed.isLiked = true
                                feed.likeCount += 1
                            }
                            // 피드 새로고침 api사용
//                            eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "asd")
                        }
                    }, label: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(feed.isLiked ? .red : .white)
                            .padding(.trailing, 12)
                    })
                    
                    Text("\(feed.likeCount)")
                        .font(.m12)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Menu {
                        if feed.studentId == authViewModel.user.studentId {
                            Button(action: {
                                eventViewModel.deleteImage(contestId: feed.contestId) {
                                    eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "asd")
                                }
                            }, label: {
                                Text("사진 삭제")
                            })
                        }
                        else {
                            if feed.isDisliked {
                                Button(action: {
                                    print("신고취소")
                                    eventViewModel.postContestDislike(contestId: feed.contestId) {
                                        feed.isDisliked.toggle()
                                    }
                                }, label: {
                                    Text("신고 취소하기")
                                        .padding(.horizontal, 30)
                                })
                            }
                            else {
                                Button(action: {
                                    print("신고")
                                    eventViewModel.postContestDislike(contestId: feed.contestId) {
                                        feed.isDisliked.toggle()
                                    }
                                }, label: {
                                    Text("신고하기")
                                        .padding(.horizontal, 30)
                                })
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.white)
                    }
                    
                }
                .padding(.horizontal, 12)
                .frame(width: 165)
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

//#Preview {
//    DetailProgressEventView(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!", eventViewModel: EventViewModel())
//}
