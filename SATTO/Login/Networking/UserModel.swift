//
//  UserModel.swift
//  SATTO
//
//  Created by 황인성 on 6/20/24.
//

import Foundation

struct User: Codable {
    
    var studentId: String
//    var email: String?
    var password: String
    var name: String
    var nickname: String
    var department: String
    var grade: Int
    var isPublic: Bool
    
}

//"studentId": "201910914",
// "name": "황인성",
// "nickname": "insung",
// "department": "컴퓨터과학과",
// "grade": 0,
// "public": false



struct Model: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserInfo2
//    let result: User
    
}

// MARK: - Result
struct UserInfo2: Codable {
    var userID: String?
    var email: String?
    var password: String?
    var name: String?
    var nickname: String?
    var department: String?
    var grade: Int?
    var resultPublic: Bool?
}
