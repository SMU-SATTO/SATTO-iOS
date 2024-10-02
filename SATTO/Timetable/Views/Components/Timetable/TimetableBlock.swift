//
//  TimetableBlock.swift
//  SATTO
//
//  Created by yeongjoon on 10/1/24.
//

import SwiftUI

struct TimetableBlock: View {
    let config: TimetableConfiguration
    let lectures: [LectureModel]
    let blockRadius: CGFloat = 8
    let containerSize: CGSize

    var body: some View {
        ZStack {
            Spacer()
            ForEach(lectures, id: \.sbjDivcls) { lecture in
                let times = parseTimeString(lecture.time)
                ForEach(times.indices, id: \.self) { index in
                    let time = times[index]
                    if let position = calculatePosition(for: time, in: containerSize) {
                        VStack(spacing: 2) {
                            if config.visibilityOptions.contains(.lectureTitle) {
                                Text(lecture.sbjName)
                                    .font(.system(size: 10))
                                    .bold()
                                    .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                            }
                            if config.visibilityOptions.contains(.place) {
                                Text(lecture.sbjDivcls)
                                    .font(.system(size: 10))
                            }
                            if config.visibilityOptions.contains(.lectureNumber) {
                                Text(lecture.sbjNo)
                                    .font(.system(size: 10))
                            }
                        }
                        .frame(width: calculateWidth(for: containerSize), height: position.height, alignment: .top)
                        .padding(.top, 2)
                        .background(.lectureBlue)
                        .cornerRadius(blockRadius)
                        .position(x: position.x, y: position.y)
                        .minimumScaleFactor(0.8)
                    }
                }
            }
        }
    }
    
    func parseTimeString(_ time: String) -> [(weekday: Weekdays, startHour: Int, endHour: Int)] {
        let components = time
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
        var parsedTimes: [(weekday: Weekdays, startHour: Int, endHour: Int)] = []
        
        let dayMap: [Character: Weekdays] = [
            "월": .mon, "화": .tue, "수": .wed, "목": .thu, "금": .fri, "토": .sat, "일": .sun
        ]
        
        for component in components {
            guard let day = dayMap[component.first!],
                  let hour = Int(component.dropFirst()) else { continue }

            let startHour = 9 + (hour - 1)
            let endHour = startHour + 1

            parsedTimes.append((day, startHour, endHour))
        }

        parsedTimes.sort {
            if $0.weekday == $1.weekday {
                return $0.startHour < $1.startHour
            }
            return $0.weekday.rawValue < $1.weekday.rawValue
        }
        
        // 연속된 시간대를 합치는 로직
        var result: [(weekday: Weekdays, startHour: Int, endHour: Int)] = []
        var currentDay: Weekdays?
        var currentStartHour: Int?
        var currentEndHour: Int?
        
        for time in parsedTimes {
            let day = time.weekday
            let startHour = time.startHour
            let endHour = time.endHour
            
            if currentDay == day, let lastEndHour = currentEndHour, startHour == lastEndHour {
                currentEndHour = endHour
            } else {
                if let day = currentDay, let startHour = currentStartHour, let endHour = currentEndHour {
                    result.append((day, startHour, endHour))
                }
                currentDay = day
                currentStartHour = startHour
                currentEndHour = endHour
            }
        }
        
        if let day = currentDay, let startHour = currentStartHour, let endHour = currentEndHour {
            result.append((day, startHour, endHour))
        }
        
        return result
    }

    
    private func calculatePosition(for time: (weekday: Weekdays, startHour: Int, endHour: Int), in containerSize: CGSize) -> (x: CGFloat, y: CGFloat, height: CGFloat)? {
        guard let dayIndex = config.weeks.firstIndex(of: time.weekday) else {
            return nil
        }
        
        let startHourRange = config.time.startAt.hour
        let lectureStart = CGFloat(time.startHour)
        let lectureEnd = CGFloat(time.endHour)
        
        let cellWidth = (containerSize.width - config.timebar.width) / CGFloat(config.weeks.count)
        let cellHeight = (containerSize.height - config.weekbar.height) / CGFloat(config.time.endAt.hour - config.time.startAt.hour)
        
        let xPosition = CGFloat(dayIndex) * cellWidth
        let yPosition = ((lectureStart - CGFloat(startHourRange)) * cellHeight)
        let blockHeight = (lectureEnd - lectureStart) * cellHeight
        
        return (x: xPosition + cellWidth / 2, y: yPosition + blockHeight / 2, height: blockHeight)
    }
    
    private func calculateWidth(for containerSize: CGSize) -> CGFloat {
        let weekCount = config.weeks.count
        return (containerSize.width - config.timebar.width) / CGFloat(weekCount)
    }
}

#Preview {
    let sampleLectures = [
        LectureModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "컴퓨터네트워크", time: "목0 목5 금7", prof: "교수명", major: "전공", credit: 3),
        LectureModel(sbjDivcls: "MATH001-1", sbjNo: "MATH001", sbjName: "수학", time: "일1 월3 월4", prof: "교수명", major: "전공", credit: 3),
    ]
    
    let timetableModel = TimetableModel(
        id: 1,
        semester: "2024 Fall",
        name: "My Timetable",
        lectures: sampleLectures,
        isPublic: false,
        isRepresented: false
    )

    TimetableView(timetable: timetableModel)
        .withWeekdays(.mon, .tue, .wed, .thu, .fri)
        .withTimeRange(startAt: 8, endAt: 20)
        .aspectRatio(7/10, contentMode: .fit)
        .frame(maxWidth: 350, maxHeight: 500)
}
