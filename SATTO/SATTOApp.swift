//
//  SATTOApp.swift
//  SATTO
//
//  Created by 김영준 on 12/31/23.
//

import SwiftUI

@main
struct SATTOApp: App {
    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environmentObject(AuthViewModel())
        }
    }
}
