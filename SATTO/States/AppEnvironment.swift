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
        let lectureSearchService: LectureSearchServiceProtocol
        let constraintService: ConstraintServiceProtocol
    }
    
    struct WebRepositories {
        let timetableRepository: TimetableRepositoryProtocol
        let lectureSearchRepository: LectureSearchRepositoryProtocol
        let constraintRepository: ConstraintRepositoryProtocol
    }
}

extension AppEnvironment {
    @MainActor static func bootstrap() -> Self {
        let appState = AppState()

        let webRepositories = WebRepositories(
            timetableRepository: TimetableRepository(), 
            lectureSearchRepository: LectureSearchRepository(),
            constraintRepository: ConstraintRepository()
        )

        let services = Services(
            timetableService: TimetableService(appState: appState, webRepositories: webRepositories),
            lectureSearchService: LectureSearchService(appState: appState, webRepositories: webRepositories),
            constraintService: ConstraintService(appState: appState, webRepositories: webRepositories)
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
            .init(timetableService: FakeTimetableService(), lectureSearchService: FakeLectureSearchService(), constraintService: FakeConstraintService())
        }
    }
#endif
