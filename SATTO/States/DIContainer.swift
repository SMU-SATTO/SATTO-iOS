//
//  DIContainer.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import Foundation

struct DIContainer {
    let appState: AppState
    let services: AppEnvironment.Services

    init(appState: AppState, services: AppEnvironment.Services) {
        self.appState = appState
        self.services = services
    }
}
