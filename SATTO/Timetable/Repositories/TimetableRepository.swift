//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

private struct Empty: Decodable {}

/// 비즈니스 로직이 아닌 데이터 소스와의 상호작용을 담당. 네트워크에서 받은 DTO 반환
protocol TimetableRepositoryProtocol {
    func getUserTimetable(id: Int?) async throws -> UserTimetableResponseDto
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws
    func patchTimetableName(timetableId: Int, timetableName: String) async throws
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws
    func deleteTimetable(timetableId: Int) async throws
    func getTimetableList() async throws -> TimetableListResponseDto
}

class TimetableRepository: TimetableRepositoryProtocol {
    private let provider = MoyaProvider<TimetableRouter>()
    
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool) async throws {
        let _ = try await provider
            .request(.patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableRepresent(timetableId: Int, isRepresent: Bool) async throws {
        let _ = try await provider
            .request(.patchTimetableRepresent(timetableId: timetableId, isRepresent: isRepresent))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableName(timetableId: Int, timetableName: String) async throws {
        let _ = try await provider
            .request(.patchTimetableName(timetableId: timetableId, timetableName: timetableName))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func patchTimetableInfo(timetableId: Int, codeSectionList: [String]) async throws {
        let _ = try await provider
            .request(.patchTimetableInfo(timetableId: timetableId, codeSectionList: codeSectionList))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func deleteTimetable(timetableId: Int) async throws {
        let _ = try await provider
            .request(.deleteTimetable(timetableId: timetableId))
            .filterSuccessfulStatusCodes()
            .map(Empty.self)
    }
    
    func getTimetableList() async throws -> TimetableListResponseDto {
        return try await provider
            .request(.getTimetableList)
            .filterSuccessfulStatusCodes()
            .map(TimetableListResponseDto.self)
    }
    
    func fetchMajorCombinations(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping(Result<[MajorComb], SATTOError>) -> Void) {
        SATTONetworking.shared.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { result in
            switch result {
            case .success(let majorCombResponseDto):
                let majorCombModel = majorCombResponseDto.result.map { dto in
                    MajorComb(combination: dto.combination.map { combinationDto in
                        Combination(lectName: combinationDto.lectName, code: combinationDto.code)
                    })
                }
                completion(.success(majorCombModel))
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func postFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<[[SubjectModel]], SATTOError>) -> Void) {
        SATTONetworking.shared.postFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList) { result in
            switch result {
            case .success(let finalTimetableListResponseDto):
                let subjectModels: [[SubjectModel]] = finalTimetableListResponseDto.result.map { finalTimetableListDto in
                    finalTimetableListDto.timeTable.map { finalTimetableDto in
                        SubjectModel(
                            sbjDivcls: finalTimetableDto.codeSection,
                            sbjNo: finalTimetableDto.code,
                            sbjName: finalTimetableDto.lectName,
                            time: finalTimetableDto.lectTime
                        )
                    }
                }
                completion(.success(subjectModels))
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func getUserTimetable(id: Int?) async throws -> UserTimetableResponseDto {
        return try await provider
            .request(.getUserTimetable(id: id))
            .filterSuccessfulStatusCodes()
            .map(UserTimetableResponseDto.self)
    }

    //MARK: - SubjectDetailModel에 이전 수강 인원 누락되어있음 + 담은인원 + 옵셔널 처리 체크
    func postCurrentLectureList(request: CurrentLectureListRequest, page: Int, completion: @escaping(Result<([SubjectDetailModel], Int?), SATTOError>) -> Void) {
        SATTONetworking.shared.postCurrentLectureList(request: request, page: page) { result in
            switch result {
            case .success(let dto):
                let subjectDetailModels = dto.result?.currentLectureResponseDTOList.map {
                    SubjectDetailModel(major: $0.cmpDiv ?? "Error",
                                       sbjDivcls: $0.codeSection ?? "Error",
                                       sbjNo: $0.code ?? "Error",
                                       sbjName: $0.lectName ?? "Error",
                                       prof: $0.professor ?? "Error",
                                       time: $0.lectTime?.trimmingCharacters(in: .whitespaces) ?? "일10",
                                       credit: $0.credit ?? 0,
                                       enrollmentCapacity: 0,
                                       enrolledStudents: 0,
                                       yesterdayEnrolledData: 0,
                                       threeDaysAgoEnrolledData: 0)
                }
                let totalPage = dto.result?.totalPage
                completion(.success((subjectDetailModels ?? [], totalPage)))
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    private func handleSATTOError<T>(_ error: Error, completion: @escaping (Result<T, SATTOError>) -> Void) {
        let customError: SATTOError
        
        if let moyaError = error as? MoyaError {
            // MoyaError를 SATTOError로 변환
            switch moyaError {
            case .imageMapping(let response):
                customError = .imageMapping(response)
            case .jsonMapping(let response):
                customError = .jsonMapping(response)
            case .stringMapping(let response):
                customError = .stringMapping(response)
            case .objectMapping(let error, let response):
                customError = .objectMapping(error, response)
            case .encodableMapping(let error):
                customError = .encodableMapping(error)
            case .statusCode(let response):
                customError = .statusCode(response)
            case .underlying(let error, let response):
                customError = .underlying(error, response)
            case .requestMapping(let string):
                customError = .requestMapping(string)
            case .parameterEncoding(let error):
                customError = .parameterEncoding(error)
            }
        } else {
            // MoyaError가 아닌 일반 Swift 에러의 경우
            customError = .underlying(error, nil)
        }
        print("TimetableRepository Error occurred: \(customError.localizedDescription)")
        completion(.failure(customError))
    }
}
