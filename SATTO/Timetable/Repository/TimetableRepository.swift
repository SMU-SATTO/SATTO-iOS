//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

class TimetableRepository {
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping(Result<[MajorCombModel], Error>) -> Void) {
        SATTONetworking.shared.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { result in
            switch result {
            case .success(let majorCombResponseDto):
                let majorCombModels = majorCombResponseDto.result.map { majorCombDto in
                    let combinations = majorCombDto.combination.map { ($0.lectName, $0.code) }
                    return MajorCombModel(combinations: combinations)
                }
                completion(.success(majorCombModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<[SubjectModel], Error>) -> Void) {
        SATTONetworking.shared.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList) { result in
            switch result {
            case .success(let finalTimetableListDto):
                let subjectModels = finalTimetableListDto.result.flatMap { $0.timetable.map { SubjectModel(sbjDivcls: $0.codeSection, sbjNo: $0.code, sbjName: $0.lectName, time: $0.lectTime) } }
                completion(.success(subjectModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserTimetable(id: Int, completion: @escaping(Result<[SubjectModel], Error>) -> Void) {
        SATTONetworking.shared.getUserTimetable(id: id) { result in
            switch result {
            case .success(let userTimetableDto):
                let subjectModels = userTimetableDto.result.lects.map {
                    SubjectModel(sbjDivcls: $0.code, sbjNo: $0.code, sbjName: $0.lectName, time: $0.lectTime)
                }
                completion(.success(subjectModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //TODO: - SubjectDetailModel에 이전 수강 인원 누락되어있음 + 담은인원 + 옵셔널 처리 체크
    func getCurrentLectureList(completion: @escaping(Result<[SubjectDetailModel], Error>) -> Void) {
        SATTONetworking.shared.getCurrentLectureList() { result in
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
