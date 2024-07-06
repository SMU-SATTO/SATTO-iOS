//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

class TimetableRepository {
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping(Result<[MajorComb], Error>) -> Void) {
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
                completion(.failure(error))
            }
        }
    }
    
    func postFinalTimetableList(isRaw: Bool, GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<[[SubjectModel]], Error>) -> Void) {
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
                completion(.failure(error))
            }
        }
    }
    
    func getTimetableList(completion: @escaping (Result<[TimetableListModel], Error>) -> Void) {
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
                completion(.failure(error))
            }
        }
    }
    
    func getUserTimetable(id: Int?, completion: @escaping (Result<TimetableMainInfoModel, Error>) -> Void) {
        SATTONetworking.shared.getUserTimetable(id: id) { result in
            switch result {
            case .success(let userTimetableDto):
                guard let lects = userTimetableDto.result?.lects else {
                    completion(.success(TimetableMainInfoModel(subjectModels: [], semesterYear: nil, timeTableName: nil)))
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
                
                let result = TimetableMainInfoModel(subjectModels: subjectModels,
                                                 semesterYear: userTimetableDto.result?.semesterYear,
                                                 timeTableName: userTimetableDto.result?.timeTableName)
                completion(.success(result))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    //MARK: - SubjectDetailModel에 이전 수강 인원 누락되어있음 + 담은인원 + 옵셔널 처리 체크
    func postCurrentLectureList(request: CurrentLectureListRequest, page: Int, completion: @escaping(Result<([SubjectDetailModel], Int?), Error>) -> Void) {
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
                completion(.failure(error))
            }
        }
    }
}
