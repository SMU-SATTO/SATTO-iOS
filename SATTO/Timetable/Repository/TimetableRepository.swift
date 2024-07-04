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
    
    func postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<[[SubjectModel]], Error>) -> Void) {
        SATTONetworking.shared.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList) { result in
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
    
    func getUserTimetable(id: Int?, completion: @escaping (Result<[SubjectModel], Error>) -> Void) {
        SATTONetworking.shared.getUserTimetable(id: id) { result in
            switch result {
            case .success(let userTimetableDto):
                if let lects = userTimetableDto.result?.lects {
                    let subjectModels = lects.compactMap { lect -> SubjectModel? in
                        guard let sbjDivcls = lect.codeSection,
                              let sbjNo = lect.code,
                              let sbjName = lect.lectName,
                              let time = lect.lectTime else {
                            return nil
                        }
                        return SubjectModel(sbjDivcls: sbjDivcls, sbjNo: sbjNo, sbjName: sbjName, time: time)
                    }
                    completion(.success(subjectModels))
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //TODO: - SubjectDetailModel에 이전 수강 인원 누락되어있음 + 담은인원 + 옵셔널 처리 체크
    func getCurrentLectureList(request: CurrentLectureListRequest, completion: @escaping(Result<[SubjectDetailModel], Error>) -> Void) {
        SATTONetworking.shared.getCurrentLectureList(request: request) { result in
            switch result {
            case .success(let dto):
                let subjectDetailModels = dto.result?.currentLectureResponseDTOList.map {
                    SubjectDetailModel(major: $0.cmpDiv ?? "Error",
                                       sbjDivcls: $0.codeSection ?? "Error",
                                       sbjNo: $0.code ?? "Error",
                                       sbjName: $0.lectName ?? "Error",
                                       prof: $0.professor ?? "Error",
                                       time: $0.lectTime ?? "일10 ",
                                       credit: $0.credit ?? 0,
                                       enrollmentCapacity: 0,
                                       enrolledStudents: 0,
                                       yesterdayEnrolledData: 0,
                                       threeDaysAgoEnrolledData: 0)
                }
                completion(.success(subjectDetailModels ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
