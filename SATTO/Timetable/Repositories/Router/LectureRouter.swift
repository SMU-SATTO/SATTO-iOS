//
//  LectureRouter.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation
import Moya

enum LectureRouter {
    case searchCurrentLectures(request: CurrentLectureListRequest, page: Int)
}

extension LectureRouter: TargetType {
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
        case .searchCurrentLectures:
            return "/current-lecture/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchCurrentLectures:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchCurrentLectures(let request, let page):
            let parameters: [String: Any] = [
                "lectName": request.searchText,
                "grade": request.grade,
                "elective": request.elective,
                "normal": request.normal,
                "essential": request.essential,
                "humanity": request.humanity,
                "society": request.society,
                "nature": request.nature,
                "engineering": request.engineering,
                "art": request.art,
                "isCyber": request.isCyber,
                "timeZone": request.timeZone
            ]
            let queryStringParameters: [String: Any] = [
                "page": page
            ]
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: queryStringParameters)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer \(getToken() ?? "")"
        ]
    }
    
    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }
    
    var sampleData: Data {
        return Data()
    }
}
