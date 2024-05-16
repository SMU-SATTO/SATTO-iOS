//
//  TimetableViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI
import JHTimeTable

class TimetableViewModel: ObservableObject {
    let colorSelectionManager = ColorSelectionManager()
    
    @Published var subjectData = TimetableModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", name: "컴퓨터네트워크", time: "목4 금5 금6")
    @Published var subjectData2 = TimetableModel(sbjDivcls: "HAEA0008-2", sbjNo: "HAEA0008", name: "운영체제", time: "월1 월2 월3")
    @Published var subjectData3 = TimetableModel(sbjDivcls: "HAEA0008-3", sbjNo: "HAEA0008", name: "소프트웨어공학", time: "월4 목3 금4")
    
//    @Published var subjectDetailDataList: [TimetableDetailModel] = []
    @Published var subjectDetailDataList: [TimetableDetailModel] = [
        TimetableDetailModel(major: "전공", sbjDivcls: "ABC-03", sbjNo: "ABC", sbjName: "과목명", prof: "홍길동", time: "화2 화3 화4", enrollmentCapacity: 100, enrolledStudents: 115, yesterdayEnrolledData: 100, threeDaysAgoEnrolledData: 80),
        TimetableDetailModel(major: "전공", sbjDivcls: "DEF-05", sbjNo: "DEF", sbjName: "데이터베이스", prof: "춘향이", time: "월4 월5 월6", enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        TimetableDetailModel(major: "교양", sbjDivcls: "FAS-05", sbjNo: "DEF", sbjName: "운영체제", prof: "가나다", time: "월4 월5 월6", enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        TimetableDetailModel(major: "전공", sbjDivcls: "QWE-01", sbjNo: "DEF", sbjName: "English and Foundations(speaking)", prof: "프란시스 브래넌", time: "월1 월2 월3", enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        TimetableDetailModel(major: "교양", sbjDivcls: "ASD-02", sbjNo: "DEF", sbjName: "데이터마이닝", prof: "아자차카", time: "월4 월5 월6", enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        TimetableDetailModel(major: "전공", sbjDivcls: "ZXC-08", sbjNo: "DEF", sbjName: "컴퓨터수학", prof: "타파하", time: "월4 월5 월6", enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30)
    ]

    
    lazy var timetableData: Datum = {
        return Datum(timetable: [self.subjectData, self.subjectData2, self.subjectData3], totalTime: "a", isPublic: true, isRepresent: true, createdAt: "today")
    }()
    
    
    private let addTime = 8 // 1교시는 9시부터 시작
    
    /// JHTimeTable 모델 형식으로 바꿔주는 함수
    private func convertToLectureModels(from timetableModel: TimetableModel) -> [LectureModel] {
        let components = timetableModel.time.components(separatedBy: " ")
        var lectureModels: [LectureModel] = []
        
        let setRandomColor = colorSelectionManager.randomColor()
        
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
                                            color: setRandomColor,
                                            week: week,
                                            startAt: startTime,
                                            endAt: endTime)
            lectureModels.append(lectureModel)
        }
        
        return mergeAdjacentLectures(lectureModels)
    }
    
    private func parseTime(from timeString: String) -> LectureTableTime? {
        let digits = timeString.filter { $0.isNumber }
        guard let hour = Int(digits) else {
            return nil
        }
        
        return LectureTableTime(hour: hour + addTime, minute: 0)
    }
    
    private func week(for component: String) -> LectureWeeks? {
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
    
    /// 연속된 강의 합치는 함수
    private func mergeAdjacentLectures(_ lectures: [LectureModel]) -> [LectureModel] {
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

    
//    func convertToLectureModels() -> [LectureModel] {
//        return convertToLectureModels(from: subjectData)
//    }
    func convertToLectureModels() -> [LectureModel] {
        return timetableData.timetable.flatMap { convertToLectureModels(from: $0) } // 옵셔널 체이닝 추가
    }
}

class ColorSelectionManager {
    var selectedColors: Set<Color> = []
    
    let colors: [Color] = [.red, .blue, .green, .orange, .yellow, .purple, .pink, .cyan, .teal, .indigo]

    func randomColor() -> Color {
        var availableColors = colors.filter { !selectedColors.contains($0) }
        if availableColors.isEmpty {
            availableColors = colors
            selectedColors.removeAll()
        }
        let randomIndex = Int.random(in: 0..<availableColors.count)
        let selectedColor = availableColors[randomIndex]
        selectedColors.insert(selectedColor)
        return selectedColor
    }
}
