//
//  LogInAPI.swift
//  SATTO
//
//  Created by 황인성 on 6/18/24.
//

import Foundation
import Moya

enum AuthAPI {
    
    case sendAuthNumber(studentId: String)
    case checkAuthNumber(certificationNum: String)
    //    case checkPasswordCondition
    //    case checkNickName
    case signUp(user: User)
    case logIn(email: String, password: String)
    case signOut
    case logOut
    case checkEemailDuplicate(studentId: String)
    
    case userInfoInquiry
    
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.37.93.59:8080")!
    }
    
    var path: String {
        switch self {
        case .sendAuthNumber:
            return "/api/v1/users/id/mail/check"
        case .checkAuthNumber:
            return "/api/v1/users/id/mail/authentication"
        case .signUp:
            return "/api/v1/auth/register"
        case .logIn:
            return "/api/v1/auth/authenticate"
        case .logOut:
            return "/api/v1/auth/logout"
        case .signOut:
            return "/api/v1/users/account/withdrawal"
        case .userInfoInquiry:
            return "/api/v1/users"
        case .checkEemailDuplicate(let studentId):
            return "/api/v1/users/id/\(studentId)@sangmyung.kr"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendAuthNumber:
            return .post
        case .checkAuthNumber:
            return .post
        case .signUp:
            return .post
        case .logIn:
            return .post
        case .logOut:
            return .post
        case .signOut:
            return .delete
        case .userInfoInquiry:
            return .get
        case .checkEemailDuplicate:
            return.get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sendAuthNumber(let studentId):
            let parameters: [String: Any] = ["studentId": studentId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .checkAuthNumber(let certificationNum):
            let parameters: [String: Any] = ["certificationNum": certificationNum]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signUp(let user):
            let parameters: [String: Any] = ["studentId": user.studentId, "email": "\(user.studentId)@sangmyung.kr", "password": user.password, "name": user.name, "nickname": user.nickname, "department": user.department, "isPublic": user.isPublic]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .logIn(let email, let password):
            let parameters: [String: Any] = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .logOut:
            return .requestPlain
        case .signOut:
            return .requestPlain
        case .userInfoInquiry:
            return .requestPlain
        case .checkEemailDuplicate:
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        switch self {
        case .sendAuthNumber:
            return ["Content-type": "application/json"]
        case .checkAuthNumber:
            return ["Content-type": "application/json"]
        case .signUp:
            return ["Content-type": "application/json"]
        case .logIn:
            return ["Content-type": "application/json"]
        case .logOut:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .signOut:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .userInfoInquiry:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .checkEemailDuplicate:
            return ["Content-type": "application/json"]
        }
    }
    
//    private func saveToken(_ token: String) {
//        KeychainHelper.shared.save(token, forKey: accessTokenKey)
//    }

    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }

//    private func deleteToken() {
//        KeychainHelper.shared.delete(forKey: accessTokenKey)
//    }
//
//    private func saveRefreshToken(_ token: String) {
//        KeychainHelper.shared.save(token, forKey: refreshTokenKey)
//    }
//
//    private func getRefreshToken() -> String? {
//        return KeychainHelper.shared.read(forKey: refreshTokenKey)
//    }
//
//    private func deleteRefreshToken() {
//        KeychainHelper.shared.delete(forKey: refreshTokenKey)
//    }
}
