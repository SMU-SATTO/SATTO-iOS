//
//  FriendAPI.swift
//  SATTO
//
//  Created by 황인성 on 6/26/24.
//

import Foundation
import Moya

enum FriendAPI {
    
    case followRequest(studentId: String)
    case followAccept(studentId: String)
    case followingList(studentId: String)
    case followerList(studentId: String)
    case unfollwing(studentId: String)
    case unfollow(studentId: String)
    case timetableList(studentId: String)
    case myTimeTableList
}


extension FriendAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.satto1.shop")!
    }
    
    var path: String {
        switch self {
        case .followRequest(let studentId):
            return "/api/v1/follow/request/\(studentId)"
        case .followAccept(let studentId):
            return "/api/v1/follow/accept/\(studentId)"
        case .followingList(let studentId):
            return "/api/v1/follow/\(studentId)/followingList"
        case .followerList(let studentId):
            return "/api/v1/follow/\(studentId)/followerList"
        case .unfollwing(let studentId):
            return "/api/v1/follow/unfollowing/\(studentId)"
        case .unfollow(let studentId):
            return "/api/v1/follow/unfollow/\(studentId)"
        case .timetableList(let studentId):
            return "/api/v1/timetable/\(studentId)/timetable"
        case .myTimeTableList:
            return "/api/v1/timetable/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .followRequest:
            return .post
        case .followAccept:
            return .post
        case .followingList:
            return .get
        case .followerList:
            return .get
        case .unfollwing:
            return .delete
        case .unfollow:
            return .delete
        case .timetableList:
            return .get
        case .myTimeTableList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .followRequest:
            return .requestPlain
        case .followAccept:
            return .requestPlain
        case .followingList:
            return .requestPlain
        case .followerList:
            return .requestPlain
        case .unfollwing:
            return .requestPlain
        case .unfollow:
            return .requestPlain
        case .timetableList:
            return .requestPlain
        case .myTimeTableList:
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        switch self {
        case .followRequest(studentId: let studentId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .followAccept(studentId: let studentId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .followingList:
            return ["Content-type": "application/json"]
        case .followerList:
            return ["Content-type": "application/json"]
        case .unfollwing(studentId: let studentId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .unfollow(studentId: let studentId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .timetableList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .myTimeTableList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        }
    }

    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }

}
