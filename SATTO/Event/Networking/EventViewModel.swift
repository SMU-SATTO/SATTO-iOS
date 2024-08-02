//
//  EventViewModel.swift
//  SATTO
//
//  Created by 황인성 on 5/12/24.
//

import Foundation
import Moya

class EventViewModel: ObservableObject {
    
    private let provider = MoyaProvider<EventAPI>()
    
    @Published var eventList: [EventCategoryResponseDto] = []
    
    
    @Published var events: [Event] = []
    
    @Published var event: Event?
    
//    var userInfo1: UserInfo
//    var event1: Event
//    var eventFeed1: [EventFeed]
    
    
    init() {
        var userInfo1 = UserInfo(studentID: 201910914, grade: 4, name: "황인성", isPublicAccount: true)
        
        var eventFeed1 = [
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 8)!, like: 12, userInfo: userInfo1, isMyLike: true),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false),
            Feed(imageURL: URL(string: "https://www.example.com")!, uploadDate: Date(y: 2024, m: 5, d: 10)!, like: 9, userInfo: userInfo1, isMyLike: false)
        ]
        var event1 = Event(title: "개강맞이 시간표 경진대회", startDate: Date(y: 2024, m: 5, d: 1)!, endDate: Date(y: 2024, m: 6, d: 1)!, description: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!", feeds: eventFeed1)
        
        
        var event2 = Event(title: "학교 사진 콘테스트", startDate: Date(y: 2024, m: 5, d: 5)!, endDate: Date(y: 2024, m: 6, d: 5)!, description: "꽃이 활짝 핀 캠퍼스 사진을 찍고 자랑해 보세요!", feeds: eventFeed1)
        
        // 이제 event1을 events 배열에 추가할 수 있습니다.
        events.append(event1)
        events.append(event2)
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
                        self.eventList = eventResponse.result.eventCategoryResponseDtoList
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
    
}

extension Date {
    // 구조체 실패가능 생성자로 구현
    init?(y year: Int, m month: Int, d day: Int) {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil  // 날짜 생성할 수 없다면 nil리턴
        }
        
        self = date      //구조체이기 때문에, self에 새로운 인스턴스를 할당하는 방식으로 초기화가능
    }
}
