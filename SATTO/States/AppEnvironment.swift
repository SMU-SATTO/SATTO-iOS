//
//  AppEnvironment.swift
//  SATTO
//
//  Created by yeongjoon on 9/25/24.
//

import SwiftUI

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    struct Services: Sendable {
        let timetableService: TimetableServiceProtocol
    }
    
    struct WebRepositories {
        let timetableRepository: TimetableRepositoryProtocol
    }
}

extension AppEnvironment {
    @MainActor static func bootstrap() -> Self {
        let appState = AppState()

        let webRepositories = WebRepositories(
            timetableRepository: TimetableRepository()
        )

        let services = Services(
            timetableService: TimetableService(timetableRepository: webRepositories.timetableRepository)
        )

        let container = DIContainer(appState: appState, services: services)
        return AppEnvironment(container: container)
    }
}

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer? = nil
}

extension EnvironmentValues {
    var dependencyContainer: DIContainer? {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}

#if DEBUG
    extension AppEnvironment.Services {
        @MainActor static func preview(appState: AppState) -> Self {
            .init(timetableService: FakeTimetableService())
        }
    }
#endif
