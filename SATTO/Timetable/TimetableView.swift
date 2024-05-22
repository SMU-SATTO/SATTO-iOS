//
//  TimetableView.swift
//  SATTO
//
//  Created by yeongjoon on 5/2/24.
//

import SwiftUI
import JHTimeTable

struct TimetableView: View {
    let timetableBaseArray: [TimetableBase]
    
    var body: some View {
        JHLectureTable {
            ForEach(convertToLectureModels(from: timetableBaseArray)) { lecture in
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(lecture.color)
                    
                    Text(lecture.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 2, leading: 3, bottom: 0, trailing: 0))
                }
                .lectureTableTime(week: lecture.week,
                                  startAt: lecture.startAt,
                                  endAt: lecture.endAt)
            }
        } timebar: { time in
            // Add customized timebar
            Text("\(time.hour == 12 ? "\(time.hour)pm" : (time.hour > 12 ? "\(time.hour - 12)pm" : "\(time.hour)am"))")
                .font(.r12)
                .padding(.trailing, 3)
            
        } weekbar: { week in
            // week: LectureWeeks enum
            // You can use week.symbol, week.shortSymbol, week.veryShortSymbol
            // Add cusomized weekbar
            Text("\(week)".capitalized)
                .font(.m14)
        } background: {
            // Add background
        }
        .lectureTableWeekdays([.mon, .tue, .wed, .thu, .fri, .sat, .sun])
        .lectureTableTimes(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 22, minute: 0)) // 시작, 끝 시간 설정
        .lectureTableBorder(width: 0.5, radius: 0, color: "#979797") // table 그리드 선 색 변경
        .lectureTableBar(time: .init(height: 0, width: 35), week: .init(height: 30, width: 10)) //날짜, 시간 위치 변경 가능, 시간, 주 크기 변경
        .frame(width: 350, height: 500)
    }
    
    private func convertToLectureModels(from timetableBaseArray: [TimetableBase]) -> [LectureModel] {
        return timetableBaseArray.flatMap { convertToLectureModels(from: $0) }
    }
    
    private func convertToLectureModels(from timetableBase: TimetableBase) -> [LectureModel] {
        let components = timetableBase.time.components(separatedBy: " ")
        var lectureModels: [LectureModel] = []
        
        let setRandomColor = ColorSelectionManager().randomColor()// Assuming a method to generate random colors
        
        for component in components {
            guard let week = week(for: component) else {
                continue
            }
            
            guard let startTime = parseTime(from: component) else {
                continue
            }
            
            let endTime = LectureTableTime(hour: startTime.hour + 1, minute: startTime.minute)
            
            let lectureModel = LectureModel(title: timetableBase.sbjName,
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
        
        return LectureTableTime(hour: hour + 8, minute: 0) // 1교시 9시부터 시작
    }
    
    private func week(for component: String) -> LectureWeeks? {
        let day = component.prefix(1)
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
    
    private func mergeAdjacentLectures(_ lectures: [LectureModel]) -> [LectureModel] {
        var mergedLectures: [LectureModel] = []
        
        let sortedLectures = lectures.sorted { $0.startAt.hour < $1.startAt.hour }
        
        var previousLecture: LectureModel?
        
        for currentLecture in sortedLectures {
            if let temp = previousLecture {
                if currentLecture.startAt.hour == temp.endAt.hour && currentLecture.startAt.minute == temp.endAt.minute &&
                    currentLecture.week == temp.week {
                    let mergedLecture = LectureModel(title: temp.title, color: temp.color, week: temp.week, startAt: temp.startAt, endAt: currentLecture.endAt)
                    previousLecture = mergedLecture
                } else {
                    mergedLectures.append(temp)
                    previousLecture = currentLecture
                }
            } else {
                previousLecture = currentLecture
            }
        }
        
        if let lastLecture = previousLecture {
            mergedLectures.append(lastLecture)
        }
        
        return mergedLectures
    }
}

struct LectureView: View {
    let lecture: LectureModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
            Text(lecture.title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 2, leading: 3, bottom: 0, trailing: 0))
        }
    }
}


#Preview {
    TimetableView(timetableBaseArray: [])
}
