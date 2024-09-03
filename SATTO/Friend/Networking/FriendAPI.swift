//
//  FriendAPI.swift
//  SATTO
//
//  Created by 황인성 on 6/26/24.
//

import Foundation
import Moya

enum FriendAPI {
    
    case followingRequest(studentId: String)
    case followAccept(studentId: String)
    case followingList(studentId: String)
    case followerList(studentId: String)
    case unfollwing(studentId: String)
    case unfollow(studentId: String)
    case friendTimetableList(studentId: String)
    case myTimeTableList
    
    case fetchTimeTableInfo(timeTableId: Int)
    case searchUser(studentIdOrName: String)
    
    case compareTimeTable(studentIds: [String])
    case compareTimeTableGap(studentIds: [String])
}


extension FriendAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.satto1.shop")!
    }
    
    var path: String {
        switch self {
        case .followingRequest(let studentId):
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
        case .friendTimetableList(let studentId):
            return "/api/v1/timetable/\(studentId)/timetable"
        case .myTimeTableList:
            return "/api/v1/timetable/list"
        case .fetchTimeTableInfo(let timeTableId):
            return "/api/v1/timetable/\(timeTableId)"
        case .searchUser:
            return "/api/v1/users/search"
        case .compareTimeTable:
            return "/api/v1/timetable/compare/lect"
        case .compareTimeTableGap:
            return "/api/v1/timetable/compare/gap"
         
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .followingRequest:
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
        case .friendTimetableList:
            return .get
        case .myTimeTableList:
            return .get
        case .fetchTimeTableInfo:
            return .get
        case .searchUser:
            return .get
        case .compareTimeTable:
            return .post
        case .compareTimeTableGap:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .followingRequest:
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
        case .friendTimetableList:
            return .requestPlain
        case .myTimeTableList:
            return .requestPlain
        case .fetchTimeTableInfo:
            return .requestPlain
        case .searchUser(let studentIdOrName):
            return .requestParameters(parameters: ["query": studentIdOrName], encoding: URLEncoding.queryString)
        case .compareTimeTable(let studentIds):
            return .requestParameters(parameters: ["studentIds": studentIds], encoding: JSONEncoding.default)
        case .compareTimeTableGap(studentIds: let studentIds):
            return .requestParameters(parameters: ["studentIds": studentIds], encoding: JSONEncoding.default)
        }
    }
    
    
    var headers: [String : String]? {
        switch self {
        case .followingRequest:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .followAccept:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .followingList:
            return ["Content-type": "application/json"]
        case .followerList:
            return ["Content-type": "application/json"]
        case .unfollwing:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .unfollow:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .friendTimetableList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .myTimeTableList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .fetchTimeTableInfo:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .searchUser:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .compareTimeTable:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .compareTimeTableGap(studentIds: let studentIds):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        }
    }

    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }

}
