//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

class TimetableRepository {
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping(Result<[MajorComb], SATTOError>) -> Void) {
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
    
    func getTimetableList(completion: @escaping (Result<[TimetableListModel], SATTOError>) -> Void) {
        SATTONetworking.shared.getTimetableList() { result in
            switch result {
            case .success(let dto):
                let timetableListModels: [TimetableListModel] = dto.result.map { timetable in
                    TimetableListModel(
                        id: timetable.timeTableId,
                        timetableName: timetable.timeTableName,
                        semesterYear: timetable.semesterYear,
                        isPublic: timetable.isPublic,
                        isRepresent: timetable.isRepresent
                    )
                }
                completion(.success(timetableListModels))
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
    }
    
    func getUserTimetable(id: Int?, completion: @escaping (Result<TimetableMainInfoModel, SATTOError>) -> Void) {
        SATTONetworking.shared.getUserTimetable(id: id) { result in
            switch result {
            case .success(let userTimetableDto):
                guard let lects = userTimetableDto.result?.lects else {
                    completion(.success(TimetableMainInfoModel(timetableId: nil, subjectModels: [], semesterYear: nil, timeTableName: nil)))
                    return
                }
                
                let subjectModels = lects.compactMap { lect -> SubjectModel? in
                    guard let sbjDivcls = lect.codeSection,
                          let sbjNo = lect.code,
                          let sbjName = lect.lectName,
                          let time = lect.lectTime else {
                        return nil
                    }
                    return SubjectModel(sbjDivcls: sbjDivcls, sbjNo: sbjNo, sbjName: sbjName, time: time)
                }
                
                let result = TimetableMainInfoModel(
                    timetableId: userTimetableDto.result?.timeTableId,
                    subjectModels: subjectModels,
                    semesterYear: userTimetableDto.result?.semesterYear,
                    timeTableName: userTimetableDto.result?.timeTableName)
                completion(.success(result))
            case .failure(let error):
                self.handleSATTOError(error, completion: completion)
            }
        }
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
