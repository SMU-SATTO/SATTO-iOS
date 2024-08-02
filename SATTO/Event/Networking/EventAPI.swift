//
//  EventAPI.swift
//  SATTO
//
//  Created by 황인성 on 8/1/24.
//

import Foundation
import Moya

enum EventAPI {
    case getEventList
}

extension EventAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.satto1.shop")!
    }
    
    var path: String {
        switch self {
            
        case .getEventList:
            return "/api/v1/event"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getEventList:
            return .get
            
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getEventList:
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .getEventList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
            
        }
    }
    
    
    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }
}
