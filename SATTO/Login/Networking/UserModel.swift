//
//  UserModel.swift
//  SATTO
//
//  Created by 황인성 on 6/20/24.
//

import Foundation

struct CheckResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: String
}


struct User: Codable {
    
    var studentId: String
    var profileImg: String?
    var email: String
    var password: String
    var name: String
    var nickname: String
    var department: String
    var grade: Int
    var isPublic: Bool
}

struct UserResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: User
}


struct LoginResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: Token
}

struct Token: Codable {
    var access_token: String
    var refresh_token: String
}

