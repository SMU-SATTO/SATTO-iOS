//
//  SATTOApp.swift
//  SATTO
//
//  Created by 김영준 on 12/31/23.
//

import SwiftUI

@main
struct SATTOApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
//            Onboarding()
//                .environmentObject(authViewModel)
            if authViewModel.isLoggedIn == true {
                    ContentView()
                    .environmentObject(authViewModel)
            }
            else {
                LoginView()
                    .environmentObject(LoginNavigationPathFinder.shared)
                    .environmentObject(authViewModel)
                    
            }
        }
    }
}
