//
//  UserModel.swift
//  SATTO
//
//  Created by 황인성 on 6/20/24.
//

import Foundation

struct User {
    
    var studentId: String
//    var email: String?
    var password: String
    var name: String
    var nickname: String
    var department: String
    var grade: Int
    var isPublic: Bool
    
}

struct Model: Encodable, Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: UserInfo2
}

// MARK: - Result
struct UserInfo2: Codable {
//    let createdAt, updatedAt: String?
//    let userID: Int?
//    let profileImg: JSONNull?
//    let name, nickname, department: String?
//    let studentID: Int?
//    let email, password, role: String?
//    let grade: Int?
//    let photoContest: JSONNull?
//    let likeList, dislikeList, courseList: [JSONAny]
//    let resultPublic, enabled: Bool?
//    let username: String?
//    let authorities: [Authority]
//    let accountNonExpired, accountNonLocked, credentialsNonExpired: Bool?
    
    
    var userID: String?
    var email: String?
    var password: String?
    var name: String?
    var nickname: String?
    var department: String?
    var grade: Int?
    var resultPublic: Bool?
}
