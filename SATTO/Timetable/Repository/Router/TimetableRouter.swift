//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation
import Moya

enum TimetableRouter {
    case postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String)
    case postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]])
    case getTimetableList
    case getUserTimetable(id: Int)
}

extension TimetableRouter: TargetType {
    var baseURL: URL {
        guard let path = Bundle.main.path(forResource: "secret", ofType: "plist") else {
            fatalError("secret.plist 파일을 찾을 수 없습니다.")
        }
        guard let data = FileManager.default.contents(atPath: path) else {
            fatalError("secret.plist 파일을 읽어올 수 없습니다.")
        }
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            fatalError("secret.plist를 NSDictionary로 변환할 수 없습니다.")
        }
        if let baseURLString = plistDictionary["BaseURL"] as? String,
           let url = URL(string: baseURLString) {
            return url
        } else {
            fatalError("BaseURL을 찾을 수 없거나 유효하지 않습니다.")
        }
    }
    
    var path: String {
        switch self {
        case .postMajorComb:
            return "/timetable"
        case .postFinalTimetableList:
            return "/timetable/auto"
        case .getTimetableList:
            return "/timetable/list"
        case .getUserTimetable:
            return "/timetable/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postMajorComb:
            return .post
        case .postFinalTimetableList:
            return .post
        case .getTimetableList:
            return .get
        case .getUserTimetable:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .postMajorComb(let GPA, let requiredLect, let majorCount, let cyberCount, let impossibleTimeZone):
            return .requestParameters(parameters: [
                "GPA": GPA,
                "requiredLect": requiredLect,
                "majorCount": majorCount,
                "cyberCount": cyberCount,
                "impossibleTimeZone": impossibleTimeZone
            ], encoding: JSONEncoding.prettyPrinted)
        case .postFinalTimetableList(let GPA, let requiredLect, let majorCount, let cyberCount, let impossibleTimeZone, let majorList):
            return .requestParameters(parameters: [
                "GPA": GPA,
                "requiredLect": requiredLect,
                "majorCount": majorCount,
                "cyberCount": cyberCount,
                "impossibleTimeZone": impossibleTimeZone,
                "majorList": majorList
            ], encoding: JSONEncoding.prettyPrinted)
        case .getTimetableList:
            return .requestPlain
        case .getUserTimetable(let id):
            return .requestParameters(parameters: [
                "id": id
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

