//
//  EventViewModel.swift
//  SATTO
//
//  Created by 황인성 on 5/12/24.
//

import Foundation
import Moya
import UIKit
import SwiftUI

enum EventState: Int {
    
    case progress = 0
    case yet = 1
    case end = 2
    case error = 99
    
}

class EventViewModel: ObservableObject {
    
    private let provider = MoyaProvider<EventAPI>()
    
    @Published var eventList: [Event] = []
    
//    @Published var events: [Event] = []
    
    @Published var event: Event?
    
    @Published var feeds: [Feed] = []
    
    @Published var feed: Feed?
    
    @Published var feedDislikeAlert = false
    @Published var cancleFeedDislikeAlert = false
    @Published var deleteFeedAlert = false
    
    var colors: [Color] = [.lectureBlue, .lectureGreen, .lectureMint, .lectureOrange, .lecturePink, .lecturePurple, .lectureRed, .lectureSkyblue, .lectureYellow]
    var medalColors: [Color] = [.yellow, .gray, .brown]
    
    init() {
        var userInfo1 = UserInfo(studentID: 201910914, grade: 4, name: "황인성", isPublicAccount: true)


    }
    
    // 날짜를 문자열로 변환하는 함수
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    // 날짜 기간을 문자열로 변환하는 함수
    //    func durationString(from event: EventModel) -> String {
    //        let duration = event.duration
    //        let hours = Int(duration / 3600)
    //        let minutes = Int(duration.truncatingRemainder(dividingBy: 3600) / 60)
    //        return "\(hours)시간 \(minutes)분"
    //    }
    
    func eventUnwrapping() {
        guard let unwrappedEvent = event else { return }
    }
    
    func getEventList() {
        provider.request(.getEventList) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let eventResponse = try? response.map(EventResponse.self) {
                        self.eventList = eventResponse.result
                        print(self.eventList)
                        print("getEventList매핑 성공🚨")
                    }
                    else {
                        print("getEventList매핑 실패🚨")
                    }
                case .failure:
                    print("getEventList네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func uploadTimeTableImage(UIImage: UIImage) {
        provider.request(.uploadTimeTableImage(image: UIImage)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response Data: \(responseString)")
                    }
                    print("uploadTimeTableImage네트워크 요청 성공🚨")
                    
                case .failure(let error):
                    
                    if let response = error.response {
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            print("Error Response Data: \(responseString)")
                        }
                    }
                    print("uploadTimeTableImage네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func getEventFeed(category: String) {
        provider.request(.getEventFeed(category: category)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    
                    if let eventFeedResponse = try? response.map(FeedResponse.self) {
                        self.feeds = eventFeedResponse.result
                        print("getEventFeed매핑 성공🚨")
                        print(self.feeds)
                    }
                    else {
                        print("getEventFeed매핑 실패🚨")
                    }
                case .failure(let error):
                    print("getEventFeed네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 좋아요 누르기 취소도됨
    func postContestLike(contestId: Int, completion: @escaping () -> Void) {
        provider.request(.postContestLike(contestId: contestId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("postContestLike네트워크 요청 성공🚨")
                    completion()
                case .failure(let error):
                    print("postContestLike네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func postContestDislike(contestId: Int, completion: @escaping () -> Void) {
        provider.request(.postContestDislike(contestId: contestId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("postContestDislike네트워크 요청 성공🚨")
                    completion()
                case .failure(let error):
                    print("postContestDislike네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func uploadImage(UIImage: UIImage, category: String, completion: @escaping () -> Void) {
        provider.request(.uploadImage(image: UIImage, category: category)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response Data: \(responseString)")
                    }
                    print("uploadTimeTableImage네트워크 요청 성공🚨")
                    completion()
                    
                case .failure(let error):
                    
                    if let response = error.response {
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            print("Error Response Data: \(responseString)")
                        }
                    }
                    print("uploadTimeTableImage네트워크 요청 실패🚨")
                }
            }
        }
    }
    func deleteImage(contestId: Int, completion: @escaping () -> Void) {
        provider.request(.deleteImage(contestId: contestId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let deleteResponse = try? response.map(CheckResponse.self) {
                        if deleteResponse.result == "삭제되었습니다." {
                            print("deleteImage매핑 성공🚨")
                            print("삭제 성공🚨")
                            completion()
                        }
                        else {
                            print("deleteImage매핑 성공🚨")
                            print("삭제 실패🚨")
                            
                            if let responseString = String(data: response.data, encoding: .utf8) {
                                print("Response Data: \(responseString)")
                            }
                        }
                    }
                    else {
                        print("deleteImage매핑 실패🚨")
                    }
                case .failure(let error):
                    print("deleteImage네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func 두날짜사이간격(startDateString: String, endDateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            fatalError("Invalid date format")
        }
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let days = components.day {
            print("Number of days between dates: \(days)") // 출력: 13
            return days
        }
        else {
            return 99
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
    
    // 문자열을 Date 객체로 변환하는 함수
    func dateFromCustomString(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.date(from: dateString)
    }

    // Date 객체를 문자열로 변환하는 함수
    func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    
    func sortingFeed(sort: String) {
        if sort == "좋아요 순" {
            feeds.sort { $0.likeCount < $1.likeCount }
        }
        else if sort == "최신순" {
            feeds.sort { $0.formattedUpdatedAt < $1.formattedUpdatedAt }
        }
    }
    
}

