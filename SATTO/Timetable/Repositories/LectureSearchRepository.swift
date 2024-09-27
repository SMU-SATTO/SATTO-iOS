//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 9/27/24.
//

import Foundation
import Moya

protocol LectureSearchRepositoryProtocol {
    func fetchCurrentLectureList(request: CurrentLectureListRequest, page: Int) async throws -> CurrentLectureResponseDto
}

class LectureSearchRepository: LectureSearchRepositoryProtocol {
    private let provider = MoyaProvider<LectureRouter>()
    
    ///현재 학기 강의 조회
    func fetchCurrentLectureList(request: CurrentLectureListRequest, page: Int) async throws -> CurrentLectureResponseDto {
        return try await provider
            .request(.searchCurrentLectures(request: request, page: page))
            .filterSuccessfulStatusCodes()
            .map(CurrentLectureResponseDto.self)
    }
}
