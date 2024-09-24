//
//  BaseViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import Foundation

@MainActor
protocol BaseViewModelProtocol: Sendable {
    var container: DIContainer { get set }
    var appState: AppState { get }
    var services: AppEnvironment.Services { get }
}

class BaseViewModel: NSObject, BaseViewModelProtocol {
    var container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    var appState: AppState {
        container.appState
    }

    var services: AppEnvironment.Services {
        container.services
    }
}
