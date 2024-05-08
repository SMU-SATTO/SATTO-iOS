//
//  TimetableViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import Foundation
import JHTimeTable

class TimetableViewModel: ObservableObject {
    @Published var subjectData = TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 금5 금6")
    
    let addTime = 8 // 1교시는 9시부터 시작
    
    func convertToLectureModels(from timetableModel: TimetableModel) -> [LectureModel] {
        let components = timetableModel.time.components(separatedBy: " ")
        var lectureModels: [LectureModel] = []
        
        for component in components {
            guard let week = week(for: component) else {
                continue
            }
            
            guard let startTime = parseTime(from: component) else {
                continue
            }
            
            // 끝나는 시간은 시작 시간에 1시간을 더한 값으로 설정
            let endTime = LectureTableTime(hour: startTime.hour + 1, minute: startTime.minute)
            
            let lectureModel = LectureModel(title: timetableModel.name,
                                            color: "FF0000",
                                            week: week,
                                            startAt: startTime,
                                            endAt: endTime)
            lectureModels.append(lectureModel)
        }
        
        return mergeAdjacentLectures(lectureModels)
    }
    
    func parseTime(from timeString: String) -> LectureTableTime? {
        let digits = timeString.filter { $0.isNumber }
        guard let hour = Int(digits) else {
            return nil
        }
        
        return LectureTableTime(hour: hour + addTime, minute: 0)
    }
    
    func week(for component: String) -> LectureWeeks? {
        let day = component.prefix(1) // 첫 번째 문자 추출
        switch day {
        case "월": return .mon
        case "화": return .tue
        case "수": return .wed
        case "목": return .thu
        case "금": return .fri
        case "토": return .sat
        case "일": return .sun
        default: return nil
        }
    }
    
    func mergeAdjacentLectures(_ lectures: [LectureModel]) -> [LectureModel] {
        var mergedLectures: [LectureModel] = []
        
        // 시작 시간을 기준으로 강의들을 정렬
        let sortedLectures = lectures.sorted { $0.startAt.hour < $1.startAt.hour }
        
        var previousLecture: LectureModel?
        
        // 정렬된 강의들을 순회하며 연속된 시간을 가진 강의들을 합침
        for currentLecture in sortedLectures {
            if let temp = previousLecture {
                // 현재 강의의 시작 시간과 이전 강의의 종료 시간이 같으면 합침
                if currentLecture.startAt.hour == temp.endAt.hour && currentLecture.startAt.minute == temp.endAt.minute &&
                   currentLecture.week == temp.week {
                    // 새로운 강의를 만들어 현재 강의의 종료 시간을 업데이트
                    let mergedLecture = LectureModel(title: temp.title, color: temp.color, week: temp.week, startAt: temp.startAt, endAt: currentLecture.endAt)
                    previousLecture = mergedLecture
                } else {
                    // 연속된 시간을 가진 강의가 아니면 이전 강의를 결과 배열에 추가하고 현재 강의를 업데이트
                    mergedLectures.append(temp)
                    previousLecture = currentLecture
                }
            } else {
                // 첫 번째 강의는 그냥 추가
                previousLecture = currentLecture
            }
        }
        
        // 마지막 강의 추가
        if let lastLecture = previousLecture {
            mergedLectures.append(lastLecture)
        }
        
        return mergedLectures
    }

    
    func convertToLectureModels() -> [LectureModel] {
        return convertToLectureModels(from: subjectData)
    }
}
