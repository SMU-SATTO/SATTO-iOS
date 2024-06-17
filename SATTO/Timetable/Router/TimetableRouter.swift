//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation
import Moya

enum TimetableRouter {
    case getMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String)
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
        case .getMajorComb:
            return "/timetable/auto"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMajorComb:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getMajorComb(let GPA, let requiredLect, let majorCount, let cyberCount, let impossibleTimeZone):
            return .requestParameters(parameters: [
                "GPA": GPA,
                "requiredLect": requiredLect,
                "majorCount": majorCount,
                "cyberCount": cyberCount,
                "impossibleTimeZone": impossibleTimeZone
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

