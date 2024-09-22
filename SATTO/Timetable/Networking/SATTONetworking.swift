//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//
//MARK: -  삭제 예정 파일

import Foundation
import Moya

class SATTONetworking {
    static let shared = SATTONetworking()
    
    private init() {}
    
    let provider = MoyaProvider<TimetableRouter>()
    
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping (Result<MajorCombResponseDto, SATTOError>) -> Void) {
        provider.request(.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone)) { result in
            switch result {
            case .success(let response):
                do {
                    let majorCombResponseDto = try response.map(MajorCombResponseDto.self)
                    completion(.success(majorCombResponseDto))
                } catch {
                    self.handleSATTOError(error, response: response, completion: completion)
                }
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func postFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<FinalTimetableListResponseDto, SATTOError>) -> Void) {
        provider.request(.postFinalTimetableList(isRaw: isRaw, GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList)) { result in
            switch result {
            case .success(let response):
                do {
                    let finalTimetableListResponse = try response.map(FinalTimetableListResponseDto.self)
                    completion(.success(finalTimetableListResponse))
                } catch {
                    self.handleSATTOError(error, response: response, completion: completion)
                }
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func postTimetableSelect(
        codeSectionList: [String],
        semesterYear: String,
        timeTableName: String,
        isPublic: Bool,
        isRepresented: Bool,
        completion: @escaping(Result<TimetableSelectResponseDto, SATTOError>) -> Void
    ) {
        provider.request(.postTimetableSelect(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)) { result in
            switch result {
            case .success(let response):
                do {
                    let timetableSelectResponse = try response.map(TimetableSelectResponseDto.self)
                    completion(.success(timetableSelectResponse))
                } catch {
                    self.handleSATTOError(error, response: response, completion: completion)
                }
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func postCurrentLectureList(request: CurrentLectureListRequest, page: Int, completion: @escaping(Result<CurrentLectureResponseDto, SATTOError>) -> Void) {
        provider.request(.postCurrentLectureList(request: request, page: page)) { result in
            switch result {
            case .success(let response):
                do {
                    let currentLectureResponse = try response.map(CurrentLectureResponseDto.self)
                    completion(.success(currentLectureResponse))
                } catch {
                    self.handleSATTOError(error, response: response, completion: completion)
                }
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    private func handleSATTOError<T>(_ error: Error, response: Response? = nil, completion: @escaping (Result<T, SATTOError>) -> Void) {
        let customError: SATTOError

        if let moyaError = error as? MoyaError {
            // MoyaError라면
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
            // MoyaError가 아닌 일반 Swift Error의 경우
            customError = .underlying(error, response)
        }
        print("SATTONetworking Error occurred. \(customError.localizedDescription)")
        completion(.failure(customError))
    }
}
