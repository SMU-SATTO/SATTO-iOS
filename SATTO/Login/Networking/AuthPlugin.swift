//
//  AuthPlugin.swift
//  SATTO
//
//  Created by 황인성 on 8/26/24.
//

import Foundation
import Moya

final class AuthPlugin: PluginType {
    
    
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"
    
    private let provider = MoyaProvider<AuthAPI>()
    
    weak var viewModel: AuthViewModel?
        
        init(viewModel: AuthViewModel?) {
            self.viewModel = viewModel
        }
    
    
    
    // 요청이 시작될 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        print("요청을 보냅니다: \(request.request?.url?.absoluteString ?? "")")
    }
    
    // 응답을 받은 후 호출
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            print("응답을 받았습니다: \(response.statusCode)")
            
            if response.statusCode == 403 {
                regenerateToken { [weak self] success in
                    guard let self = self else { return }
                    if success {
                        // 토큰 재발급 성공 시 원래 요청을 다시 시도할 수 있습니다.
                        self.retryOriginalRequest(target: target)
                    } else {
                        // 토큰 재발급 실패 시 로그아웃 처리
                        self.forceLogout()
                    }
                }
            }
            
            
        case .failure(let error):
            print("오류가 발생했습니다: \(error.localizedDescription)")
            
            viewModel?.networkErrorAlert = true
            
            // 실패 했을떄 리프레쉬 토큰으로 엑세스 토큰 재발급후 다시 시도
            // 그 요청이 실패하면 강제 로그아웃
            
            // 네트워크 오류도 고려
        }
    }
    
    
    // 토큰 재발급 메서드
        private func regenerateToken(completion: @escaping (Bool) -> Void) {
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
                    
                }
            }
        }
        
        // 원래 요청을 다시 시도하는 메서드
        private func retryOriginalRequest(target: TargetType) {
            guard let target = target as? AuthAPI else { return }
            
            // MoyaProvider의 재요청 메커니즘
            let retryProvider = MoyaProvider<AuthAPI>()
            retryProvider.request(target) { result in
                // 재요청 결과 처리
            }
        }
        
        // 로그아웃 처리 메서드
        private func forceLogout() {
            // 로그아웃 처리 (예: 사용자 세션 종료, UI 업데이트 등)
            print("강제 로그아웃")
            viewModel?.isLoggedIn = false
            self.deleteToken()
            self.deleteRefreshToken()
            
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
