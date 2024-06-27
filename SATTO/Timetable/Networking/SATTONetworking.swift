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
        print("Requesting with parameters:")
        print("GPA: \(GPA)")
        print("Required Lectures: \(requiredLect)")
        print("Major Count: \(majorCount)")
        print("Cyber Count: \(cyberCount)")
        print("Impossible Time Zone: \(impossibleTimeZone)")
        provider.request(.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone)) { result in
            switch result {
            case .success(let response):
                print("HTTP Status Code: \(response.statusCode)")
                print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "nil")")
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("Response JSON: \(jsonObject)")
                    }
                    let majorCombResponseDto = try response.map(MajorCombResponseDto.self)
                    print("Response JSON: \(majorCombResponseDto)")
                    completion(.success(majorCombResponseDto))
                } catch {
                    print("Error mapping response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<FinalTimetableListResponseDto, Error>) -> Void) {
        print("GPA: \(GPA)")
        print("requiredLect: \(requiredLect)")
        print("majorCount: \(majorCount)")
        print("cyberCount: \(cyberCount)")
        print("impossibleTimeZone: \(impossibleTimeZone)")
        print("majorList: \(majorList)")
        provider.request(.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList)) { result in
            switch result {
            case .success(let response):
                print("HTTP Status Code: \(response.statusCode)")
                print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "nil")")
                
                do {
                    let finalTimetableListResponse = try response.map(FinalTimetableListResponseDto.self)
                    print("Response JSON: \(finalTimetableListResponse)")
                    completion(.success(finalTimetableListResponse))
                } catch {
                    print("Error mapping response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getTimetableList(completion: @escaping(Result<TimetableListResponseDto, Error>) -> Void) {
        provider.request(.getTimetableList) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 403 {
                    print("Access forbidden: \(response)")
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response Body: \(responseString)")
                    }
                }
                else {
                    do {
                        let timetableListResponse = try response.map(TimetableListResponseDto.self)
                        print("Response JSON: \(timetableListResponse)")
                        completion(.success(timetableListResponse))
                    } catch {
                        print("Error mapping response: \(error)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
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
