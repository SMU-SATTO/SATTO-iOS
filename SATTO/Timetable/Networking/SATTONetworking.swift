//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation
import Moya

//TODO: async await 공부
class SATTONetworking {
    static let shared = SATTONetworking()
    
    private init() {}
    
    let provider = MoyaProvider<TimetableRouter>()
    
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping (Result<MajorCombResponseDto, Error>) -> Void) {
        provider.request(.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone)) { result in
            switch result {
            case .success(let response):
                do {
                    let majorCombResponseDto = try response.map(MajorCombResponseDto.self)
                    completion(.success(majorCombResponseDto))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<FinalTimetableListResponseDto, Error>) -> Void) {
        provider.request(.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList)) { result in
            switch result {
            case .success(let response):
                do {
                    let finalTimetableListResponse = try response.map(FinalTimetableListResponseDto.self)
                    completion(.success(finalTimetableListResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTimetableList(completion: @escaping(Result<TimetableListResponseDto, Error>) -> Void) {
        provider.request(.getTimetableList) { result in
            switch result {
            case .success(let response):
                do {
                    let timetableListResponse = try response.map(TimetableListResponseDto.self)
                    completion(.success(timetableListResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserTimetable(id: Int, completion: @escaping(Result<UserTimetableResponseDto, Error>) -> Void) {
        provider.request(.getUserTimetable(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let userTimetableResponse = try response.map(UserTimetableResponseDto.self)
                    completion(.success(userTimetableResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
