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
    case getEventFeed(category: String)
    case postContestLike(contestId: Int)
    case postContestDislike(contestId: Int)
    case uploadImage(image: UIImage, category: String)
    case deleteImage(contestId: Int)
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
        case .getEventFeed(let category):
            return "/api/v1/event/\(category)"
        case .postContestLike(let contestId):
            return "/api/v1/event/\(contestId)/like"
        case .postContestDislike(let contestId):
            return "/api/v1/event/\(contestId)/dislike"
        case .uploadImage:
            return "/api/v1/event"
        case .deleteImage(let contestId):
            return "/api/v1/event/\(contestId)"


        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getEventList:
            return .get
            
        case .uploadTimeTableImage:
            return .post
        case .getEventFeed:
            return .get
        case .postContestLike:
            return .post
        case .postContestDislike:
            return .post
        case .uploadImage:
            return .post
        case .deleteImage:
            return .delete
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
        case .getEventFeed:
            return .requestPlain
        case .postContestLike:
            return .requestPlain
        case .postContestDislike:
            return .requestPlain
        case .uploadImage(let image, let category):
            let imageData = image.jpegData(compressionQuality: 0.1)!
            let formData = MultipartFormData(provider: .data(imageData), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
//            return .uploadMultipart([formData])
            let queryParameters = ["category": category]
            return .uploadCompositeMultipart([formData], urlParameters: queryParameters)

        case .deleteImage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .getEventList:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .uploadTimeTableImage:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .getEventFeed:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .postContestLike:
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .postContestDislike(contestId: let contestId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .uploadImage(image: let image, category: let category):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        case .deleteImage(contestId: let contestId):
            return ["Authorization": "Bearer \(getToken() ?? "asd")"]
        }
    }
    
    
    private func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "accessToken")
    }
}
