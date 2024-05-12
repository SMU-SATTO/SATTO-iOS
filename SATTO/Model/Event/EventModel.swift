//
//  EventModel.swift
//  SATTO
//
//  Created by 황인성 on 5/10/24.
//

import Foundation

struct Event {
    
    let id: UUID = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let description: String
    let evnetFeed: [EventFeed]
    
}

struct EventFeed {
    
    let imageURL: URL
    let uploadDate: Date
    let like: Int
    let userInfo: UserInfo
    let isMyLike: Bool
    
}

struct UserInfo {
    
    let studentID: Int
    let grade: Int
    let name: String
    let isPublicAccount: Bool
    
}
