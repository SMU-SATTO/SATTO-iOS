//
//  LogInViewModel.swift
//  SATTO
//
//  Created by 황인성 on 6/18/24.
//

import Foundation
import Moya
import Combine

enum checkEmail: String {
    case duplicate = "존재하는 아이디 입니다."
    case unique = "해당 아이디를 사용할 수 있습니다."
}

enum checkAuthNum: String {
    case wrong = "인증번호가 일치하지 않습니다."
    case pass = "인증번호가 일치합니다."
}

enum checkSignUp: String {
//    case fail = "
    case success = "회원가입 성공"
}

//enum checkLogIn: String {
//    case fail = "아이디 또는 비밀번호가 틀렸습니다."
//    case success = "성공입니다."
//}

class AuthViewModel: ObservableObject {
    private let provider = MoyaProvider<AuthAPI>()
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    @Published var token: String? = nil
    @Published var isLoggedIn: Bool = false
    
    @Published var EmailDuplicateMessage: String = ""
    
    @Published var isCheckedEmailDuplicate = false
    @Published var isCheckedsendAuthNumber = true
    @Published var isCheckedAuthNumber = true
    
    @Published var isCheckedsendAuthNumberLoading = false
    
    @Published var studentIdDuplicateAlert = false
    @Published var authNumIsWrongAlert = false
    @Published var LogInFailAlert = false
    
    
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"

    init() {
        print("authViewModel init")
        self.token = self.getToken()
        self.isLoggedIn = (self.token != nil)
        user = User(studentId: "", email: "", password: "", name: "", nickname: "", department: "", grade: 1, isPublic: true)
        print(self.user)
    }
    
    func checkEmailDuplicate(studentId: String) {
        provider.request(.checkEemailDuplicate(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let checkEmailDuplicateResponse = try? response.map(CheckDuplicateResponse.self) {
                        
                        if checkEmailDuplicateResponse.result == checkEmail.unique.rawValue {
                            self.isCheckedEmailDuplicate = true
                            self.isCheckedsendAuthNumber = false
                        }
                        else {
                            self.studentIdDuplicateAlert = true
                        }
                        
                        print("fetchFollowerList매핑 성공🚨")
                    }
                    else {
                        print("fetchFollowerList매핑 실패🚨")
                    }
                case .failure(let error):
                    print("fetchFollowerList네트워크 요청 실패🚨")
                }
            }
        }
    }

    func sendAuthNumber(studentId: String) {
        self.isCheckedsendAuthNumberLoading = true
        provider.request(.sendAuthNumber(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("sendAuthNumber매핑 성공🚨")
                    self.isCheckedsendAuthNumber = true
                    self.isCheckedAuthNumber = false
                    
                    self.isCheckedsendAuthNumberLoading = false
                case .failure(let error):
                    print("sendAuthNumber네트워크 요청 실패🚨")
//                    self.isCheckedsendAuthNumberLoading = false
                }
            }
        }
    }
    
    func reSendAuthNumber(studentId: String) {
        provider.request(.sendAuthNumber(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("reSendAuthNumber매핑 성공🚨")
//                    self.isCheckedsendAuthNumber = true
//                    self.isCheckedAuthNumber = false
                case .failure(let error):
                    print("reSendAuthNumber네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func checkAuthNumber(certificationNum: String) {
        provider.request(.checkAuthNumber(certificationNum: certificationNum)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let checkAuthNumberResponse = try? response.map(CheckDuplicateResponse.self) {
                        
                        if checkAuthNumberResponse.result == checkAuthNum.pass.rawValue {
                            self.isCheckedAuthNumber = true
                        }
                        else {
                            self.authNumIsWrongAlert = true
                        }
                        
                        print("fetchFollowerList매핑 성공🚨")
                    }
                    else {
                        print("fetchFollowerList매핑 실패🚨")
                    }
                case .failure(let error):
                    print("reSendAuthNumber네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    func signUp(user: User, completion: @escaping () -> Void) {
        provider.request(.signUp(user: user)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("signUp매핑 성공🚨")
                    completion()
                case .failure(let error):
                    print("signUp네트워크 요청 실패🚨")
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
                        self.LogInFailAlert = true
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



