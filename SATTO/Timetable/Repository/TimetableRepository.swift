//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import Foundation
import Moya

class TimetableRepository {
    private let network = SATTONetworking()
    
    func postMajorComb(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, completion: @escaping(Result<[MajorCombModel], Error>) -> Void) {
        network.postMajorComb(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone) { result in
            switch result {
            case .success(let majorCombResponseDto):
                let majorCombModels = majorCombResponseDto.result.map { MajorCombModel(lec: $0.combination) }
                completion(.success(majorCombModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postFinalTimetableList(GPA: Int, requiredLect: [String], majorCount: Int, cyberCount: Int, impossibleTimeZone: String, majorList: [[String]], completion: @escaping(Result<[SubjectModel], Error>) -> Void) {
        network.postFinalTimetableList(GPA: GPA, requiredLect: requiredLect, majorCount: majorCount, cyberCount: cyberCount, impossibleTimeZone: impossibleTimeZone, majorList: majorList) { result in
            switch result {
            case .success(let finalTimetableListDto):
                let subjectModels = finalTimetableListDto.data.flatMap { $0.timetable.map { SubjectModel(sbjDivcls: $0.sbjDivcls, sbjNo: $0.sbjNo, sbjName: $0.sbjName, time: $0.time) } }
                completion(.success(subjectModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
