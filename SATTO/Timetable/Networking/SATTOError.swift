//
//  SATTOError.swift
//  SATTO
//
//  Created by yeongjoon on 8/26/24.
//

import Foundation
import Moya

// 커스텀 에러 정의
public enum SATTOError: Swift.Error {
    case imageMapping(Response)
    case jsonMapping(Response)
    case stringMapping(Response)
    case objectMapping(Swift.Error, Response)
    case encodableMapping(Swift.Error)
    case statusCode(Response)
    case underlying(Swift.Error, Response?)
    case requestMapping(String)
    case parameterEncoding(Swift.Error)
    case customError(String)
    case unknown
}

public extension SATTOError {
    var response: Response? {
        switch self {
        case .imageMapping(let response): return response
        case .jsonMapping(let response): return response
        case .stringMapping(let response): return response
        case .objectMapping(_, let response): return response
        case .encodableMapping: return nil
        case .statusCode(let response): return response
        case .underlying(_, let response): return response
        case .requestMapping: return nil
        case .parameterEncoding: return nil
        case .customError: return nil
        case .unknown: return nil
        }
    }

    internal var underlyingError: Swift.Error? {
        switch self {
        case .imageMapping: return nil
        case .jsonMapping: return nil
        case .stringMapping: return nil
        case .objectMapping(let error, _): return error
        case .encodableMapping(let error): return error
        case .statusCode: return nil
        case .underlying(let error, _): return error
        case .requestMapping: return nil
        case .parameterEncoding(let error): return error
        case .customError(let message): return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
        case .unknown: return nil
        }
    }
}

// 에러 설명
extension SATTOError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageMapping:
            return "imageMappingError - 데이터를 이미지로 매핑하는 데 실패했습니다."
        case .jsonMapping:
            return "jsonMappingError - 데이터를 JSON으로 매핑하는 데 실패했습니다."
        case .stringMapping:
            return "stringMappingError - 데이터를 문자열로 매핑하는 데 실패했습니다."
        case .objectMapping(_, let response):
            return "Status Code: \(response.statusCode), objectMappingError - 데이터를 디코딩 가능한 객체로 매핑하는 데 실패했습니다."
        case .encodableMapping:
            return "encodableMappingError - Encodable 객체를 데이터로 인코딩하는 데 실패했습니다."
        case .statusCode:
            return "statusCodeError - 상태 코드가 지정된 범위 내에 있지 않습니다."
        case .underlying(let error, _):
            return error.localizedDescription
        case .requestMapping:
            return "requestMappingError - Endpoint를 URLRequest로 매핑하는 데 실패했습니다."
        case .parameterEncoding(let error):
            return "parameterEncodingError - URLRequest의 파라미터를 인코딩하는 데 실패했습니다. \(error.localizedDescription)"
        case .customError(let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

// 에러 사용자 정보 추가
extension SATTOError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}
