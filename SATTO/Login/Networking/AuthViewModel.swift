//
//  LogInViewModel.swift
//  SATTO
//
//  Created by 황인성 on 6/18/24.
//

import Foundation
import Moya
import Combine


class AuthViewModel: ObservableObject {
    private let provider = MoyaProvider<AuthAPI>()
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    @Published var token: String? = nil
    @Published var isLoggedIn: Bool = false
    
    @Published var EmailDuplicateMessage: String = ""
    
//    @Published var userInfo2 = UserInfo2()
    
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"

    init() {
        print("authViewModel init")
        self.token = self.getToken()
        self.isLoggedIn = (self.token != nil)
        print(self.user)
//        self.user = User(studentId: "studentId", email: "email", password: "password", name: "name", nickname: "nickname", department: "department", grade: 5, isPublic: true)
    }
    
    func checkEmailDuplicate(studentId: String) {
            provider.request(.checkEemailDuplicate(studentId: studentId)) { result in
                switch result {
                case .success(let response):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                           let resultMessage = json["result"] as? String {
                            DispatchQueue.main.async {
                                self.EmailDuplicateMessage = resultMessage
                                print("성공")
                                print(self.EmailDuplicateMessage)
                                self.user?.studentId = studentId
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print(self.errorMessage ?? "Unknown error")
                            }
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: \(error)"
                            print(self.errorMessage ?? "Unknown error")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(error)"
                        print(self.errorMessage ?? "Unknown error")
                    }
                }
            }
        }

    func sendAuthNumber(studentId: String) {
        provider.request(.sendAuthNumber(studentId: studentId)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
//                        self.user = json
                        print("성공")
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print(self.errorMessage!)
                }
            }
        }
    }
    
    func checkAuthNumber(certificationNum: String) {
        provider.request(.checkAuthNumber(certificationNum: certificationNum)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
//                        self.user = json
                        print("성공")
                        print(type(of: json!))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print(self.errorMessage!)
                }
            }
        }
    }
    
    func signUp(user: User) {
        provider.request(.signUp(user: user)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
//                        self.user = json
                        print("성공")
                        print(json)
                        print(user)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print(self.errorMessage)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print(self.errorMessage!)
                }
            }
        }
    }

    // 변경완료
    func logIn(email: String, password: String) {
        provider.request(.logIn(email: email, password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
//                    print(response)
                    if let loginResponse = try? response.map(LoginResponse.self) {
                        print("logIn매핑 성공🚨")
                        print("Access Token: \(loginResponse.result.access_token)")
                        print("Refresh Token: \(loginResponse.result.refresh_token)")
                        
                        self.saveToken(loginResponse.result.access_token)
                        self.saveRefreshToken(loginResponse.result.refresh_token)
                        self.token = loginResponse.result.access_token
                        self.isLoggedIn = true
                    }
                    else {
                        print("logIn매핑 실패🚨")
                    }
                case .failure:
                    print("logIn네트워크 요청 실패🚨")
                }
            }
        }
    }

    
    func logout() {
        provider.request(.logOut) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
//                    if let logoutResponse = try? response.map(LogoutResponse.self) {
                        print("logout매핑 성공🚨")
                        self.deleteToken()
                        self.deleteRefreshToken()
                        self.token = nil
                        self.isLoggedIn = false
//                    }
//                    else {
//                        print("logout매핑 실패🚨")
//                    }
                case .failure:
                    print("logout네트워크 요청 실패🚨")
                    
                }
            }
        }
    }
    
    func signOut() {
        
        provider.request(.signOut) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
//                        self.user = json
                        print("성공")
                        print(json)
                        
                        self.deleteToken()
                        self.deleteRefreshToken()
                        self.token = nil
                        self.isLoggedIn = false
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print(self.errorMessage!)
                }
            }
        }
        
        
    }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = self.getRefreshToken() else {
            completion(false)
            return
        }

        // 실제로는 서버와 통신하여 리프레시 토큰을 사용해 새로운 엑세스 토큰을 받아야 합니다.
        // 여기에 더미 리프레시 로직을 추가합니다.
        let newAccessToken = "newAccessToken789"
        self.saveToken(newAccessToken)
        self.token = newAccessToken
        completion(true)
    }
    
    
    // 변경완료
    func userInfoInquiry(completion: @escaping () -> Void) {
        print("userInfoInquiry 시도")
        provider.request(.userInfoInquiry) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    if let userResponse = try? response.map(UserResponse.self) {
                        print("userInfoInquiry매핑 성공🚨")
                        self.user = userResponse.result
                        completion()
                    }
                    else {
                        print("userInfoInquiry매핑 실패🚨")
                    }
                case .failure:
                    print("userInfoInquiry네트워크 요청 실패🚨")
                }
            }
        }
    }
    

    



    
//    func sendAuthNumber(studentId: String) {
//        provider.request(.sendAuthNumber(studentId: studentId)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
//                    DispatchQueue.main.async {
////                        self.user = json
//                        print("성공")
//                    }
//                } catch let error {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Failed to parse JSON: \(error)"
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error: \(error)"
//                    print(self.errorMessage!)
//                }
//            }
//        }
//    }
    
    
    
    private func saveToken(_ token: String) {
        KeychainHelper.shared.save(token, forKey: accessTokenKey)
    }

    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: accessTokenKey)
    }

    private func deleteToken() {
        KeychainHelper.shared.delete(forKey: accessTokenKey)
    }

    private func saveRefreshToken(_ token: String) {
        KeychainHelper.shared.save(token, forKey: refreshTokenKey)
    }

    private func getRefreshToken() -> String? {
        return KeychainHelper.shared.read(forKey: refreshTokenKey)
    }

    private func deleteRefreshToken() {
        KeychainHelper.shared.delete(forKey: refreshTokenKey)
    }

}



