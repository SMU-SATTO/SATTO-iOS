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
    // 지금 보고있는 이벤트
    @Published var event: Event?
    @Published var feeds: [Feed] = []
    
    // 이미지를 확대해서볼 피드
    @Published var feed: Feed?
    
    var colors: [Color] = [.lectureBlue, .lectureGreen, .lectureMint, .lectureOrange, .lecturePink, .lecturePurple, .lectureRed, .lectureSkyblue, .lectureYellow]
    var medalColors: [Color] = [.yellow, .gray, .brown]
    
    init() {
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
    
    func daysFromToday(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let today = Date()
        
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("Invalid date format")
        }
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: today, to: date)
        
        if let days = components.day {
            return days
        }
        else {
            return 99
        }
    }
    
    func getEventStatus(startDate: String, endDate: String) -> EventState {
        if daysFromToday(dateString: startDate) < 0 && daysFromToday(dateString: endDate) < 0 {
            return .end
        }
        else if daysFromToday(dateString: startDate) <= 0 && daysFromToday(dateString: endDate) >= 0 {
            return .progress
        }
        else if daysFromToday(dateString: startDate) > 0 {
            return .yet
        }
        else {
            return .error
        }
    }
    
}

