//
//  LogInViewModel.swift
//  SATTO
//
//  Created by 황인성 on 6/18/24.
//

import Foundation
import Moya
import Combine
import UIKit

enum checkEmail: String {
    case fail = "존재하는 아이디 입니다."
    case success = "해당 아이디를 사용할 수 있습니다."
}

enum checkAuthNum: String {
    case fail = "인증번호가 일치하지 않습니다."
    case success = "인증번호가 일치합니다."
}

enum checkSignUp: String {
    case fail = ""
    case success = "회원가입 성공"
}

class AuthViewModel: ObservableObject {
    
    private var provider: MoyaProvider<AuthAPI>!
    
    // 회원정보
    @Published var user: User
    
    // 로그인 여부
    @Published var isLoggedIn: Bool = false
    
    // 인증번호 전송화면 버튼 활성화 표시
    @Published var isCheckedEmailDuplicate = false
    @Published var isCheckedsendAuthNumber = true
    @Published var isCheckedAuthNumber = true
    
    // 로딩 여부
    @Published var isLoading = false
    
    // 오류 메세지 띄우는 변수
    @Published var studentIdDuplicateAlert = false
    @Published var authNumIsWrongAlert = false
    @Published var LogInFailAlert = false
    
    // 네트워크 에러 띄우는 변수
    @Published var networkError = false
    @Published var networkErrorAlert = false
    
    // 토근 찾는 키값
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"

    init() {
        print("authViewModel init")
        // 사용자 정보 초기화
        user = User(studentId: "", email: "", password: "", name: "", nickname: "", department: "", grade: 0, isPublic: true)
        // 플러그인 주입
        let authPlugin = AuthPlugin(viewModel: self)
        self.provider = MoyaProvider<AuthAPI>(plugins: [authPlugin])
        // 로그인 여부 확인
        self.isLoggedIn = (self.getToken() != nil)
    }
    
    // 학번 중복확인
    // 중복일때, 중복아닐때 분기처리 해놓음
    // response로 확인해야해서 다음버튼 활성화 조건 포함
    func checkEmailDuplicate(studentId: String) {
        provider.request(.checkEemailDuplicate(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let checkEmailDuplicateResponse = try? response.map(CheckResponse.self) {
                        
                        if checkEmailDuplicateResponse.result == checkEmail.success.rawValue {
                            self.isCheckedEmailDuplicate = true
                            self.isCheckedsendAuthNumber = false
                        }
                        else {
                            self.studentIdDuplicateAlert = true
                        }
                        print("checkEmailDuplicate매핑 성공🚨")
                    }
                    else {
                        print("checkEmailDuplicate매핑 실패🚨")
                    }
                case .failure(let error):
                    print("checkEmailDuplicate네트워크 요청 실패🚨")
                }
            }
        }
    }

    // 인증번호 전송
    // 로딩표시
    // response로 확인해야해서 다음버튼 활성화 조건 포함
    func sendAuthNumber(studentId: String) {
        self.isLoading = true
        provider.request(.sendAuthNumber(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("sendAuthNumber매핑 성공🚨")
                    self.isCheckedsendAuthNumber = true
                    self.isCheckedAuthNumber = false
                    
                    self.isLoading = false
                case .failure(let error):
                    print("sendAuthNumber네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 인증번호 재전송
    // 아직 사용안함
    func reSendAuthNumber(studentId: String) {
        provider.request(.sendAuthNumber(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("reSendAuthNumber매핑 성공🚨")
                case .failure(let error):
                    print("reSendAuthNumber네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 인증번호 확인
    // response로 확인해야해서 다음버튼 활성화 조건 포함
    func checkAuthNumber(certificationNum: String) {
        provider.request(.checkAuthNumber(certificationNum: certificationNum)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let checkAuthNumberResponse = try? response.map(CheckResponse.self) {
                        
                        if checkAuthNumberResponse.result == checkAuthNum.success.rawValue {
                            self.isCheckedAuthNumber = true
                        }
                        else {
                            self.authNumIsWrongAlert = true
                        }
                        print("checkAuthNumber매핑 성공🚨")
                    }
                    else {
                        print("checkAuthNumber매핑 실패🚨")
                    }
                case .failure(let error):
                    print("checkAuthNumber네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 회원가입
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

    // 로그인
    // 엑세스토근, 리프레쉬토큰 키체인으로 저장
    // 로그인 여부 변경
    func logIn(email: String, password: String) {
        provider.request(.logIn(email: email, password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let loginResponse = try? response.map(LoginResponse.self) {
                        print("logIn매핑 성공🚨")
                        print("Access Token: \(loginResponse.result.access_token)")
                        print("Refresh Token: \(loginResponse.result.refresh_token)")
                        
                        self.saveToken(loginResponse.result.access_token)
                        self.saveRefreshToken(loginResponse.result.refresh_token)
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

    // 로그아웃
    // 엑세스토근, 리프레쉬토큰 키체인에서 삭제
    // 로그인 여부 변경
    func logout() {
        provider.request(.logOut) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                        print("logout매핑 성공🚨")
                        self.deleteToken()
                        self.deleteRefreshToken()
                        self.isLoggedIn = false
                case .failure:
                    print("logout네트워크 요청 실패🚨")
                    
                }
            }
        }
    }
    
    // 회원탈퇴
    // 엑세스토근, 리프레쉬토큰 키체인에서 삭제
    // 로그인 여부 변경
    func signOut() {
        provider.request(.signOut) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    print("signOut매핑 성공🚨")
                    self.deleteToken()
                    self.deleteRefreshToken()
                    self.isLoggedIn = false
                case .failure:
                    print("signOut매핑 실패🚨")
                }
            }
        }
    }
    
    // 내 정보 조회
    // user에 내 정보 저장
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
    
    // 토큰 재발급
    private func regenerateToken() {
        provider.request(.regenerateToken) { result in
            switch result {
            case .success(let response):
                print(response)
                if let tokenResponse = try? response.map(Token.self) {
                    print("regenerateToken매핑 성공🚨")
                    print("재발급Access Token: \(tokenResponse.access_token)")
                    print("재발급Refresh Token: \(tokenResponse.refresh_token)")
                    
                    self.saveToken(tokenResponse.access_token)
                    self.saveRefreshToken(tokenResponse.refresh_token)
                }
                else {
                    print("regenerateToken매핑 실패🚨")
                }
            case .failure:
                print("regenerateToken요청 실패🚨")
                self.isLoggedIn = false
            }
        }
    }
    
    // 계정 공개로 변경후 내정보 새로고침
    func setAccountPublic() {
        provider.request(.setAccountPublic) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    print("setAccountPublic네트워크 요청 성공🚨")
                    self.userInfoInquiry { }
                case .failure:
                    print("setAccountPublic네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 계정 비공개로 변경후 내정보 새로고침
    func setAccountPrivate() {
        provider.request(.setAccountPrivate) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    print("setAccountPrivate네트워크 요청 성공🚨")
                    self.userInfoInquiry { }
                case .failure:
                    print("setAccountPrivate네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 개인정보 수정
    // 뒤로가기 하려고 completion
    func editProfile(user: User, completion: @escaping () -> Void) {
        provider.request(.editProfile(name: user.name, nickname: user.nickname, department: user.department, grade: user.grade)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    print("editProfile네트워크 요청 성공🚨")
                    completion()
                case .failure:
                    print("editProfile네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 비밀번호 수정
    // 뒤로가기 하려고 completion
    func editPassword(password: String, completion: @escaping () -> Void) {
        provider.request(.editPassword(password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    print("editPassword네트워크 요청 성공🚨")
                    completion()
                case .failure:
                    print("editPassword네트워크 요청 실패🚨")
                }
            }
        }
    }
    
    // 토큰관리 메소드
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



