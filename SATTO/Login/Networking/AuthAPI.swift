//
//  LogInAPI.swift
//  SATTO
//
//  Created by 황인성 on 6/18/24.
//

import Foundation
import Moya
import UIKit

enum AuthAPI {
    
    case sendAuthNumber(studentId: String)
    case checkAuthNumber(certificationNum: String)
    case signUp(user: User)
    case logIn(email: String, password: String)
    case signOut
    case logOut
    case checkEemailDuplicate(studentId: String)
    case userInfoInquiry
    case regenerateToken
    case setAccountPublic
    case setAccountPrivate
    case editProfile(name: String, nickname: String, department: String, grade: Int)
    case editPassword(password: String)
    case resetPassword(studentId: String)
    
    case uploadProfileImage(image: UIImage)
    case deleteProfileImage
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.satto1.shop")!
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
            return "/api/v1/users/inform"
        case .checkEemailDuplicate(let studentId):
            return "/api/v1/users/id/\(studentId)@sangmyung.kr"
        case .regenerateToken:
            return "/api/v1/auth/refresh-token"
        case .setAccountPublic:
            return "/api/v1/users/account/public"
        case .setAccountPrivate:
            return "/api/v1/users/account/private"
        case .editProfile:
            return "/api/v1/users/account/update"
        case .editPassword:
            return "/api/v1/users/account/pw"
        case .resetPassword:
            return "/api/v1/users/id/findPw"
        case .uploadProfileImage:
            return "/api/v1/users/profile/image"
        case .deleteProfileImage:
            return "/api/v1/users/profile/image"
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
        case .regenerateToken:
            return .post
        case .setAccountPublic:
            return .patch
        case .setAccountPrivate:
            return .patch
        case .editProfile:
            return .patch
        case .editPassword:
            return .patch
        case .resetPassword:
            return .post
        case .uploadProfileImage:
            return .patch
        case .deleteProfileImage:
            return .delete
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
            let parameters: [String: Any] = ["studentId": user.studentId, "email": "\(user.studentId)@sangmyung.kr", "password": user.password, "name": user.name, "nickname": user.nickname, "department": user.department, "isPublic": user.isPublic, "grade": user.grade]
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
        case .regenerateToken:
            return .requestPlain
        case .setAccountPublic:
            return .requestPlain
        case .setAccountPrivate:
            return .requestPlain
        case .editProfile(let name, let nickname, let department, let grade):
            let parameters: [String: Any] = ["name": name, "nickname": nickname, "department": department, "grade": grade]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .editPassword(let password):
            let parameters: [String: Any] = ["password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .resetPassword(let studentId):
            let parameters: [String: Any] = ["studentId": studentId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .uploadProfileImage(let image):
            let imageData = image.jpegData(compressionQuality: 0.1)!
            let formData = MultipartFormData(provider: .data(imageData), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case .deleteProfileImage:
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
        case .regenerateToken:
            return ["Authorization": "Bearer \(getRefreshToken() ?? "asd")"]
        case .setAccountPublic:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .setAccountPrivate:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .editProfile:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .editPassword:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .resetPassword:
            return ["Content-type": "application/json"]
        case .uploadProfileImage(image: let image):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .deleteProfileImage:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        }
    }

    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }
    private func getRefreshToken() -> String? {
        return KeychainHelper.shared.read(forKey: "refreshToken")
    }
    
}
