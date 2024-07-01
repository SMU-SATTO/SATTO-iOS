//
//  Onboarding.swift
//  SATTO
//
//  Created by 황인성 on 6/19/24.
//

import SwiftUI

struct Onboarding: View {
    
//    @StateObject var vm = LogInViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isLoggedIn == true {
                ContentView()
                .onAppear {
                    authViewModel.userInfoInquiry()
                }
        }
        else {
            LoginView()
                .environmentObject(LoginNavigationPathFinder.shared)
                
        }
    }
}

func getToken() -> String? {
    return KeychainHelper.shared.read(forKey: "accessToken")
}

#Preview {
    Onboarding()
}
