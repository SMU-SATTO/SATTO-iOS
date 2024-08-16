//
//  EventAPI.swift
//  SATTO
//
//  Created by 황인성 on 8/1/24.
//

import Foundation
import Moya
import UIKit

enum EventAPI {
    case getEventList
    case uploadTimeTableImage(image: UIImage)
}

extension EventAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.satto1.shop")!
    }
    
    var path: String {
        switch self {
            
        case .getEventList:
            return "/api/v1/event"
            
        case .uploadTimeTableImage:
            return "/api/v1/event/timetable-contest"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getEventList:
            return .get
            
        case .uploadTimeTableImage:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getEventList:
            return .requestPlain
            
        case .uploadTimeTableImage(let image):
            let imageData = image.jpegData(compressionQuality: 0.1)!
            let formData = MultipartFormData(provider: .data(imageData), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .getEventList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
            
        case .uploadTimeTableImage:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        }
    }
    
    
    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }
}
