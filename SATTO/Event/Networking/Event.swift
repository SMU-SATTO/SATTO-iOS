//
//  Event.swift
//  SATTO
//
//  Created by 황인성 on 5/12/24.
//

import Foundation

struct FeedResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [Feed]
}



struct Feed: Codable, Hashable {
    
    var contestId: Int
    var name: String
    var studentId: String
    var photo: String
    var likeCount: Int
    var dislikeCount: Int
    var isLiked: Bool
    var isDisliked: Bool
    var createdAt: String
    var updatedAt: String
    
    // 날짜 변환 메서드
    func formattedDate(_ dateString: String) -> String {
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = originalDateFormatter.date(from: dateString) {
            return targetDateFormatter.string(from: date)
        } else {
            return dateString // 변환에 실패하면 원래 문자열 반환
        }
    }
    
    var formattedCreatedAt: String {
        return formattedDate(createdAt)
    }
    
    var formattedUpdatedAt: String {
        return formattedDate(updatedAt)
    }
    
}

struct UserInfo {
    
    let studentID: Int
    let grade: Int
    let name: String
    let isPublicAccount: Bool
    
}


// MARK: - Model
struct EventResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [Event]
}


struct Event: Codable {
    var eventId: Int
    var category: String
    var participantsCount: Int
    var startWhen: String
    var untilWhen: String
    var content: String
    
    // 날짜 변환 메서드
    func formattedDate(_ dateString: String) -> String {
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = originalDateFormatter.date(from: dateString) {
            return targetDateFormatter.string(from: date)
        } else {
            return dateString // 변환에 실패하면 원래 문자열 반환
        }
    }
    
    var formattedStartWhen: String {
        return formattedDate(startWhen)
    }
    
    var formattedUntilWhen: String {
        return formattedDate(untilWhen)
    }
}

