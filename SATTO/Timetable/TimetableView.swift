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
                LectureView(lecture: lecture)
                .lectureTableTime(week: lecture.week,
                                  startAt: lecture.startAt,
                                  endAt: lecture.endAt)
            }
        } timebar: { time in
            Text(formatTime(time))
                .font(.r12)
                .padding(.trailing, 3)
            
        } weekbar: { week in
            // You can use week.symbol, week.shortSymbol, week.veryShortSymbol
            Text("\(week)".capitalized)
                .font(.m14)
        } background: {
            // Add background
        }
        .lectureTableWeekdays(getWeeks(from: timetableBaseArray))
        .lectureTableTimes(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 21, minute: 0)) // 시작, 끝 시간 설정
        .lectureTableBorder(width: 0.5, radius: 0, color: "#979797") // table 그리드 선 색 변경
        .lectureTableBar(time: .init(height: 0, width: 35), week: .init(height: 30, width: 10)) //날짜, 시간 위치 변경 가능, 시간, 주 크기 변경
        .aspectRatio(7/10, contentMode: .fit)
        .frame(maxWidth: 350, maxHeight: 500)
    }
    
    private func convertToLectureModels(from timetableBaseArray: [TimetableBase]) -> [LectureModel] {
        return timetableBaseArray.flatMap { convertToLectureModels(from: $0) }
    }
    
    private func convertToLectureModels(from timetableBase: TimetableBase) -> [LectureModel] {
        let components = timetableBase.time.components(separatedBy: " ")
        let color = ColorSelectionManager().randomColor()
        let lectureModels = components.compactMap { component -> LectureModel? in
            guard let week = week(for: component), let startTime = parseTime(from: component) else { return nil }
            let endTime = LectureTableTime(hour: startTime.hour + 1, minute: startTime.minute)
            return LectureModel(title: timetableBase.sbjName,
                                color: color, week: week,
                                startAt: startTime,
                                endAt: endTime
            )
        }
        
        return mergeAdjacentLectures(lectureModels)
    }
    
    private func parseTime(from timeString: String) -> LectureTableTime? {
        guard let hour = Int(timeString.filter { $0.isNumber }) else { return nil }
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
    
    private func getWeeks(from timetableBaseArray: [TimetableBase]) -> [LectureWeeks] {
        let weeks: [LectureWeeks] = [.mon, .tue, .wed, .thu, .fri]
        
        for timetable in timetableBaseArray {
            if timetable.time.contains("토") || timetable.time.contains("일") {
                return [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
            }
        }
        
        return weeks
    }
    
    private func getEndTime(from timetableBaseArray: [TimetableBase]) -> Int {
        for endTime in timetableBaseArray {
            if endTime.time.contains("10") || endTime.time.contains("11") {
                return 24
            }
        }
        return 21
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
    
    private func formatTime(_ time: LectureTableTime) -> String {
        let hour = time.hour
        let period = hour >= 12 ? "pm" : "am"
        let formattedHour = hour == 12 ? 12 : hour > 12 ? hour - 12 : hour
        return "\(formattedHour)\(period)"
    }
}

struct LectureView: View {
    let lecture: LectureModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundStyle(lecture.color)
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
