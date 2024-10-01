//
//  SATTOTimetable.swift
//  SATTO
//
//  Created by yeongjoon on 10/1/24.
//

import SwiftUI

struct SATTOTimetable: View {
    let timetable: TimetableModel
    var config = TimetableConfiguration.defaultConfig
    
    init(timetable: TimetableModel) {
        self.timetable = timetable
        self.config = TimetableConfiguration.defaultConfig
        
        let allWeekdays = extractWeekdays(from: timetable.lectures)
        self.config.weeks = allWeekdays
        
        let timeRange = extractTimeRange(from: timetable.lectures)
        self.config.time = timeRange
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width - config.timebar.width) / CGFloat(config.weeks.count)
            let cellHeight = (geometry.size.height - config.weekbar.height) / CGFloat(config.time.endAt.hour - config.time.startAt.hour)
            ZStack {
                SATTOGrid(weekCount: config.weeks.count, hourCount: config.time.endAt.hour - config.time.startAt.hour, config: config)
                    .stroke(Color(UIColor.quaternaryLabel.withAlphaComponent(0.1)))
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: config.timebar.width)
                        WeekBar(weekdays: config.weeks, totalWidth: config.weekbar.width, cellWidth: cellWidth, height: config.weekbar.height)
                    }
                    HStack(spacing: 0) {
                        TimeBar(startTime: config.time.startAt.hour, endTime: config.time.endAt.hour, totalHeight: config.timebar.height, cellHeight: cellHeight, width: config.timebar.width)
                        
                        TimetableBlock(config: config, lectures: timetable.lectures, containerSize: geometry.size)
                    }
                }
            }
        }
    }
    
    private func extractWeekdays(from lectures: [SubjectModel]) -> [Weekdays] {
        let baseWeekdays: [Weekdays] = [.mon, .tue, .wed, .thu, .fri]
        let fullWeekdays: [Weekdays] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
        
        let dayMap: [Character: Weekdays] = [
            "월": .mon, "화": .tue, "수": .wed, "목": .thu, "금": .fri, "토": .sat, "일": .sun
        ]
        
        for lecture in lectures {
            let timeComponents = lecture.time
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
            
            for component in timeComponents {
                if let firstChar = component.first, let weekday = dayMap[firstChar], (weekday == .sat || weekday == .sun) {
                    return fullWeekdays
                }
            }
        }
        
        return baseWeekdays
    }
    
    private func extractTimeRange(from lectures: [SubjectModel]) -> TimetableConfiguration.TimeConfig {
        var earliestStartHour = 9
        var latestEndHour = 18
        
        for lecture in lectures {
            let timeComponents = lecture.time
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
            
            for component in timeComponents {
                if let hour = Int(component.dropFirst()) {
                    if hour == 0 {
                        earliestStartHour = 8  // 0교시가 포함되면 시작 시간을 8시로 설정
                    } else if hour >= 10 && hour <= 12 {
                        latestEndHour = max(latestEndHour, 21)  // 10, 11, 12교시 포함되면 종료 시간을 21시로 확장
                    } else if hour >= 13 && hour <= 15 {
                        latestEndHour = max(latestEndHour, 24)  // 13, 14, 15교시 포함되면 종료 시간을 24시로 확장
                    }
                }
            }
        }
        
        return TimetableConfiguration.TimeConfig(
            starAt: SATTOTimetableTime(hour: earliestStartHour, minute: 0),
            endAt: SATTOTimetableTime(hour: latestEndHour, minute: 0)
        )
    }
}

extension SATTOTimetable {
    func withWeekdays(_ weeks: Weekdays...) -> SATTOTimetable {
        var new = self
        new.config.weeks = weeks
        return new
    }
    
    func withTimeRange(startAt: Int, endAt: Int) -> SATTOTimetable {
        var new = self
        new.config.time = TimetableConfiguration.TimeConfig(
            starAt: SATTOTimetableTime(hour: startAt, minute: 0),
            endAt: SATTOTimetableTime(hour: endAt, minute: 0)
        )
        return new
    }
}

struct SATTOGrid: Shape {
    var weekCount: Int
    var hourCount: Int
    var config: TimetableConfiguration
    
    func path(in rect: CGRect) -> Path {
        let cellWidth = (rect.width - config.timebar.width) / CGFloat(weekCount)
        let cellHeight = (rect.height - config.weekbar.height) / CGFloat(hourCount)
        
        let gridEndXPos = cellWidth * CGFloat(weekCount) + config.timebar.width
        let gridEndYPos = cellHeight * CGFloat(hourCount) + config.weekbar.height
        
        return Path { path in
            // Draw vertical lines
            path.move(to: CGPoint(x: 0, y: config.weekbar.height))
            path.addLine(to: CGPoint(x: 0, y: gridEndYPos - config.weekbar.height))
            for i in 0...weekCount {
                let x = CGFloat(i) * (cellWidth)
                path.move(to: CGPoint(x: x + config.weekbar.height, y: (i == weekCount ? config.weekbar.height : 0)))
                path.addLine(to: CGPoint(x: x + config.weekbar.height, y: gridEndYPos - config.weekbar.height + (i == weekCount ? 0 : config.weekbar.height)))
            }
            
            // Draw horizontal lines
            path.move(to: CGPoint(x: config.timebar.width, y: 0))
            path.addLine(to: CGPoint(x: gridEndXPos - config.timebar.width, y: 0))
            for i in 0...hourCount {
                let y = CGFloat(i) * (cellHeight)
                path.move(to: CGPoint(x: (i == hourCount ? config.timebar.width : 0), y: y + config.timebar.width))
                path.addLine(to: CGPoint(x: gridEndXPos - config.timebar.width + (i == hourCount ? CGFloat(0) : config.timebar.width), y: y + config.timebar.width))
            }
            
            // Add corner curves
            path.move(to: CGPoint(x: 0, y: config.weekbar.height))
            path.addQuadCurve(to: CGPoint(x: config.timebar.width, y: 0), control: .zero)
            
            path.move(to: CGPoint(x: 0, y: gridEndYPos - config.weekbar.height))
            path.addQuadCurve(to: CGPoint(x: config.timebar.width, y: gridEndYPos), control: CGPoint(x: .zero, y: gridEndYPos))
            
            path.move(to: CGPoint(x: gridEndXPos - config.timebar.width, y: 0))
            path.addQuadCurve(to: CGPoint(x: gridEndXPos, y: config.weekbar.height), control: CGPoint(x: gridEndXPos, y: .zero))
            
            path.move(to: CGPoint(x: gridEndXPos - config.timebar.width, y: gridEndYPos))
            path.addQuadCurve(
                to: CGPoint(x: gridEndXPos, y: gridEndYPos - config.weekbar.height),
                control: CGPoint(x: gridEndXPos, y: gridEndYPos)
            )
        }
    }
}

struct WeekBar: View {
    let weekdays: [Weekdays]
    let totalWidth: CGFloat
    let cellWidth: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday.shortSymbolKor)
                    .frame(width: cellWidth, height: height)
                    .font(.r12)
            }
        }
        .frame(width: totalWidth, height: height)
    }
}

struct TimeBar: View {
    let startTime: Int
    let endTime: Int
    let totalHeight: CGFloat
    let cellHeight: CGFloat
    let width: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            ForEach(startTime..<endTime, id: \.self) { hour in
                Text(String(hour))
                    .font(.r12)
                    .padding(.bottom, cellHeight / 2)
                    .foregroundStyle(.blackWhite)
                    .frame(width: width, height: cellHeight)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(width: width, height: totalHeight)
    }
}

#Preview {
    let sampleLectures = [
        SubjectModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "컴퓨터네트워크", time: "목0 목5 금7"),
        SubjectModel(sbjDivcls: "MATH001-1", sbjNo: "MATH001", sbjName: "수학", time: "일1 월3 월4"),
        SubjectModel(sbjDivcls: "SCI001-2", sbjNo: "MATH002", sbjName: "과학", time: "월2 월13 화10")
    ]
    
    let timetableModel = TimetableModel(
        id: 1,
        semester: "2024 Fall",
        name: "My Timetable",
        lectures: sampleLectures,
        isPublic: false,
        isRepresented: false
    )

    SATTOTimetable(timetable: timetableModel)
        .aspectRatio(7/10, contentMode: .fit)
        .frame(maxWidth: 350, maxHeight: 500)
}
