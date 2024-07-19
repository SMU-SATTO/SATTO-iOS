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

    func logIn(email: String, password: String) {
        provider.request(.logIn(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        
                        if let result = json["result"] as? [String: Any] {
                            print("result 데이터: \(result)")
                            
                            if let accessToken = result["access_token"] as? String, let refreshToken = result["refresh_token"] as? String {
                                DispatchQueue.main.async {
                                    // 저장 및 출력
                                    print("성공")
                                    print("Access Token: \(accessToken)")
                                    print("Refresh Token: \(refreshToken)")
                                    print("isLoggedIn 이전 값: \(self.isLoggedIn)")
                                    
                                    self.saveToken(accessToken)
                                    self.saveRefreshToken(refreshToken)
                                    self.token = accessToken
                                    self.isLoggedIn = true
                                    
                                    print("isLoggedIn 이후 값: \(self.isLoggedIn)")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.errorMessage = "Failed to parse JSON: Missing tokens"
                                    print(self.errorMessage)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid structure in result"
                                print(self.errorMessage)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid structure"
                            print(self.errorMessage)
                        }
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
    

    
    func logout() {
        
        provider.request(.logOut) { result in
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
    
    func userInfoInquiry(completion: @escaping () -> Void) {
        print("userInfoInquiry 시도")
        provider.request(.userInfoInquiry) { result in
            switch result {
            case .success(let response):
                do {
                    print("userInfoInquiry 시도")
                    
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    // JSON 데이터를 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        if let resultData = json["result"] as? [String: Any] {
                            print("result 데이터: \(resultData)")

                            // JSON 데이터를 User 객체로 디코딩
                            let resultJsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                            let userInfo = try JSONDecoder().decode(User.self, from: resultJsonData)
                            DispatchQueue.main.async {
                                self.user = userInfo
                                print("성공")
                                print(userInfo)
                                completion()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("result 데이터 파싱 실패")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid format"
                            print("JSON 파싱 실패")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print("JSON 파싱 중 오류: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print("요청 실패: \(error)")
                }
            }
        }
    }
    
//    func userInfoInquiry(completion: @escaping () -> Void) {
//        print("userInfoInquiry 시도")
//        provider.request(.userInfoInquiry) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case let .success(response):
//                    print(response)
//                    if let json = try? response.map(UserResponse.self) {
//                        print("매핑 성공")
//                        self.user = json.result
//                    }
//                    else {
//                        print("매핑 실패")
//                    }
//                case .failure:
//                    print("네트워크 요청 실패")
//                }
//            }
//        }
//    }
    
//    func fetchReservationAPI(for date: Date) {
//        self.isLoading = true
//        provider.request(.getReservation(date: date.toDateString())) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case let .success(response):
//                    print(response)
//                    if let reservations = try? response.map([Reservation?].self) {
//                        print("세미나실 매핑 성공🚨")
//                        self.reservations = reservations.compactMap { $0 }
//                    } else {
//                        print("세미나실 매핑 실패🚨")
//                    }
//                case .failure:
//                    print("세미나실 네트워크 요청 실패🚨")
//                }
//            }
//            self.isLoading = false
//        }
//    }

    



    
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



