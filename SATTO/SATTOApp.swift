//
//  SATTOApp.swift
//  SATTO
//
//  Created by 김영준 on 12/31/23.
//

import SwiftUI

@main
struct SATTOApp: App {
    let appEnvironment: AppEnvironment
    
    @StateObject var authViewModel = AuthViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        appEnvironment = AppEnvironment.bootstrap()
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn == true {
                ContentView()
                    .preferredColorScheme(isDarkMode ? .dark: .light)
                    .environmentObject(authViewModel)
                    .environment(\.dependencyContainer, appEnvironment.container)
                    .alert("네트워크 오류", isPresented: $authViewModel.networkErrorAlert) {
                        Button("OK", role: .cancel) {
                            // 강제 로그아웃
                            self.deleteToken()
                            self.deleteRefreshToken()
                            authViewModel.isLoggedIn = false
                        }
                    }
            }
            
            else {
                LoginView()
                    .preferredColorScheme(isDarkMode ? .dark: .light)
                    .environmentObject(LoginNavigationPathFinder.shared)
                    .environmentObject(authViewModel)
                    .environment(\.dependencyContainer, appEnvironment.container)
                    .alert("네트워크 오류", isPresented: $authViewModel.networkErrorAlert) {
                        Button("OK", role: .cancel) {
                        }
                    }
            }
        }
    }
    
    private func deleteToken() {
        KeychainHelper.shared.delete(forKey: "accessToken")
    }
    private func deleteRefreshToken() {
        KeychainHelper.shared.delete(forKey: "refreshToken")
    }
}
