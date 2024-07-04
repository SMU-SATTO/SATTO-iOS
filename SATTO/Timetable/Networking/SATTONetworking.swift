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
        provider.request(.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList)) { result in
            switch result {
            case .success(let response):
                do {
                    let finalTimetableListResponse = try response.map(FinalTimetableListResponseDto.self)
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
                do {
                    let timetableListResponse = try response.map(TimetableListResponseDto.self)
                    completion(.success(timetableListResponse))
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
    
    func getUserTimetable(id: Int?, completion: @escaping(Result<UserTimetableResponseDto, Error>) -> Void) {
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
    
    func postTimetableSelect(
        codeSectionList: [String],
        semesterYear: String,
        timeTableName: String,
        isPublic: Bool,
        isRepresented: Bool,
        completion: @escaping(Result<TimetableSelectResponseDto, Error>) -> Void
    ) {
        provider.request(.postTimetableSelect(codeSectionList: codeSectionList, semesterYear: semesterYear, timeTableName: timeTableName, isPublic: isPublic, isRepresented: isRepresented)) { result in
            switch result {
            case .success(let response):
                do {
                    let timetableSelectResponse = try response.map(TimetableSelectResponseDto.self)
                    completion(.success(timetableSelectResponse))
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
    
    func getCurrentLectureList(request: CurrentLectureListRequest, completion: @escaping(Result<CurrentLectureResponseDto, Error>) -> Void) {
        provider.request(.getCurrentLectureList(request: request)) { result in
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
                        let currentLectureResponse = try response.map(CurrentLectureResponseDto.self)
                        completion(.success(currentLectureResponse))
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
    
    func patchTimetablePrivate(timetableId: Int, isPublic: Bool, completion: @escaping(Result<PatchTimetablePrivateResponseDto, Error>) -> Void) {
        print("\(timetableId) , \(isPublic)")
        provider.request(.patchTimetablePrivate(timetableId: timetableId, isPublic: isPublic)) { result in
            switch result {
            case .success(let response):
                do {
                    let patchTimetablePrivateResponse = try response.map(PatchTimetablePrivateResponseDto.self)
                    print("\(patchTimetablePrivateResponse)")
                    if patchTimetablePrivateResponse.isSuccess {
                        completion(.success(patchTimetablePrivateResponse))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: patchTimetablePrivateResponse.message])
                        completion(.failure(error))
                    }
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
    
    func patchTimetableName(timetableId: Int, timetableName: String, completion: @escaping(Result<PatchTimetableNameResponseDto, Error>) -> Void) {
        provider.request(.patchTimetableName(timetableId: timetableId, timetableName: timetableName)) { result in
            switch result {
            case .success(let response):
                do {
                    let patchTimetableNameResponseDto = try response.map(PatchTimetableNameResponseDto.self)
                    completion(.success(patchTimetableNameResponseDto))
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
    
    func deleteTimetable(timetableId: Int, completion: @escaping(Result<DeleteTimetableResponseDto, Error>) -> Void) {
        provider.request(.deleteTimetable(timetableId: timetableId)) { result in
            switch result {
            case .success(let response):
                do {
                    let deleteTimetableResponse = try response.map(DeleteTimetableResponseDto.self)
                    completion(.success(deleteTimetableResponse))
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
}
