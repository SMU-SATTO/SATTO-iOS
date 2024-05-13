//
//  Event.swift
//  SATTO
//
//  Created by 황인성 on 5/12/24.
//

import Foundation

struct Event {
    
    let id: UUID = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let description: String
    let feeds: [Feed]
    
}

struct Feed {
    
    let id: UUID = UUID()
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
