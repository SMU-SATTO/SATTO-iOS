//
//  DetailProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case like = "좋아요 순"
    case time = "최신순"
    case my = "내가 올린 게시글만"
}

struct DetailProgressEventView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var navPathFinder: EventNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var alreadyParticipatedAlert = false
    @State var isImageZoomed = false
    
    var color: Color
    
    let columns = [
        //        GridItem(.flexible(), spacing: 0),
        //                GridItem(.flexible())
        GridItem(.fixed(165), spacing: 23),
        GridItem(.fixed(165))
    ]
    
    @State var sort: SortOption = .like
    
    //    @State var feedDislikeAlert = false
    //    @State var deleteFeed = false
    
    var body: some View {
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Rectangle()
                            .frame(height: 0)
                        
                        HStack(spacing: 0) {
                            Text("\(eventViewModel.event?.category ?? "category")")
                                .foregroundStyle(Color.black)
                                .font(.m18)
                                .padding(.trailing, 7)
                            
                            EventTimerView(text: "\(eventViewModel.daysFromToday(dateString: eventViewModel.event?.formattedUntilWhen ?? "2024.01.01"))일 남음")
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
                    }
                }
                .padding(.leading, 25)
                .padding(.top, 10)
                .padding(.bottom, 17)
                .background(color)
                
                ZStack(alignment: .bottomTrailing) {
                    
                    Color.background
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            Rectangle()
                                .frame(height: 0)
                            
                            HStack(spacing: 0) {
                                Text("게시물 유형")
                                    .font(.sb12)
                                    .foregroundColor(Color.cellText)
                                    .padding(.top, 10)
                                    .padding(.bottom, 12)
                                
                                Picker(selection: $sort, label: Text("sort")) {
                                    ForEach(SortOption.allCases, id: \.self) { sortOption in
                                        Text(sortOption.rawValue).tag(sortOption)
                                    }
                                }
                                .tint(Color.cellText)
                                .scaleEffect(0.9)
                                
                                Spacer()
                            }
                            
                            // 두개씩 피드 띄우기 코드인데 나중에 다시 잃어봐야함 ?????
                            LazyVGrid(columns: columns, spacing: 18) {
                                ForEach(sortedFeeds(), id: \.contestId.wrappedValue) { $feed in
                                    EventFeedCell(eventViewModel: eventViewModel, feed: $feed, isImageZoomed: $isImageZoomed)
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 사진 추가할때 이미 내가 사진이 올라가 있으면 경고문 띄운다
                    Button(action: {
                        let containsStudentId = eventViewModel.feeds.contains { feed in
                            feed.studentId == authViewModel.user.studentId
                        }
                        
                        if containsStudentId {
                            alreadyParticipatedAlert.toggle()
                        }
                        else {
                            navPathFinder.addPath(route: .uploadEventImage)
                        }
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color(red: 0.28, green: 0.18, blue: 0.89))
                    })
                    .padding(.trailing, 30)
                    .padding(.bottom, 20)
                }
            }// Vstsck
//        }
        .onAppear {
            eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "잘못된 요청")
        }
        .alert("이미 참여하셨습니다.", isPresented: $alreadyParticipatedAlert) {
            Button("확인") { }
        }
        .fullScreenCover(isPresented: $isImageZoomed) {
            ZoomedImageView(isImageZoomed: $isImageZoomed, feed: eventViewModel.feed!)
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
        case .like:
            return $eventViewModel.feeds.sorted(by: { $0.likeCount.wrappedValue > $1.likeCount.wrappedValue })
        case .time:
            return $eventViewModel.feeds.sorted(by: { $0.updatedAt.wrappedValue > $1.updatedAt.wrappedValue })
        case .my:
            return $eventViewModel.feeds.filter { $0.studentId.wrappedValue == authViewModel.user.studentId }
        }
    }
}

struct EventFeedCell: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Binding var feed: Feed
    @Binding var isImageZoomed: Bool
    
    @State var feedDislikeAlert = false
    @State var cancleFeedDislikeAlert = false
    @State var deleteFeedAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            AsyncImage(url: URL(string: feed.photo)) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 165, height: 165)
            .onTapGesture {
                print("클릭")
                eventViewModel.feed = feed
                isImageZoomed.toggle()
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
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
                            // eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "asd")
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
                        // 내가 올린 사진이 있으면 내 사진을 삭제하는 버튼을 띄운다
                        if feed.studentId == authViewModel.user.studentId {
                            Button(action: {
                                deleteFeedAlert.toggle()
                            }, label: {
                                Text("사진 삭제")
                            })
                        }
                        // 내가 올린 사진이 없으면 신고하기 버튼을 띄운다
                        else {
                            // 만약 신고한적이 있으면 신고취소 버튼을 띄운다
                            if feed.isDisliked {
                                Button(action: {
                                    print("신고취소")
                                    eventViewModel.postContestDislike(contestId: feed.contestId) {
                                        feed.isDisliked.toggle()
                                        cancleFeedDislikeAlert.toggle()
                                    }
                                }, label: {
                                    Text("신고 취소하기")
                                        .padding(.horizontal, 30)
                                })
                            }
                            // 만약 신고한적이 없으면 신고하기 버튼을 띄운다
                            else {
                                Button(action: {
                                    print("신고")
                                    eventViewModel.postContestDislike(contestId: feed.contestId) {
                                        feed.isDisliked.toggle()
                                        feedDislikeAlert.toggle()
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
        .alert("신고되었습니다.", isPresented: $feedDislikeAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("신고가 취소되었습니다.", isPresented: $cancleFeedDislikeAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("정말 사진을 삭제하시겠습니까?", isPresented: $deleteFeedAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                eventViewModel.deleteImage(contestId: feed.contestId) {
                    eventViewModel.getEventFeed(category: eventViewModel.event?.category ?? "asd")
                }
            }
        }
    }
}

struct ZoomedImageView: View {
    @Binding var isImageZoomed: Bool
    var feed: Feed
    
    @State private var scale: CGFloat = 1.0
        @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.edgesIgnoringSafeArea(.all) // 전체 화면 배경을 검게 설정
            
            
            AsyncImage(url: URL(string: feed.photo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            // 사용자가 이미지를 확대/축소할 때 실행됩니다.
                                            let delta = value / lastScale
                                            lastScale = value
                                            scale *= delta
                                        }
                                        .onEnded { _ in
                                            // 제스처가 종료되면, 마지막 스케일 값을 업데이트합니다.
                                            lastScale = 1.0
                                        }
                                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
//                    .edgesIgnoringSafeArea(.all)
                
            } placeholder: {
                ProgressView()
            }
            
            Button(action: {
                isImageZoomed = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}
