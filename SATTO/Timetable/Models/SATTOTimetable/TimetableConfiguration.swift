//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 10/1/24.
//

import Foundation

struct TimetableConfiguration: Codable {
    public var weeks: [Weekdays]
    public var time: TimeConfig
    public var timebar: BarConfig
    public var weekbar: BarConfig
    
    public var visibilityOptions: VisibilityOptions
    
    public struct TimeConfig: Codable, Sendable {
        public var startAt: SATTOTimetableTime
        public var endAt: SATTOTimetableTime
        
        public init(starAt: SATTOTimetableTime = .init(hour: 9, minute: 0),
                    endAt: SATTOTimetableTime = .init(hour: 18, minute: 0)) {
            self.startAt = starAt
            self.endAt = endAt
        }
    }
    
    public struct BarConfig: Codable, Sendable {
        public var height: CGFloat
        public var width: CGFloat
        
        public init(height: CGFloat = 0, width: CGFloat = 0) {
            self.height = height
            self.width = width
        }
    }
    
    public struct VisibilityOptions: Codable, OptionSet {
        public var rawValue: Int8
        
        public static let lectureTitle = VisibilityOptions(rawValue: 1 << 0)
        public static let place = VisibilityOptions(rawValue: 1 << 1)
        public static let lectureNumber = VisibilityOptions(rawValue: 1 << 2)
        public static let instructor = VisibilityOptions(rawValue: 1 << 3)
        
        public static let `default`: VisibilityOptions = [.lectureTitle, .place]
    }
    
    public init(weeks: [Weekdays] = [.mon, .tue, .wed, .thu, .fri],
                time: TimeConfig = TimeConfig(),
                timebar: BarConfig = BarConfig(width: 20),
                weekbar: BarConfig = BarConfig(height: 20),
                visibilityOptions: VisibilityOptions = .default) {
        self.weeks = weeks
        self.time = time
        self.timebar = timebar
        self.weekbar = weekbar
        self.visibilityOptions = visibilityOptions
    }
}

extension TimetableConfiguration {
    static let defaultConfig = TimetableConfiguration()
    static let timeSelectConfig = TimetableConfiguration(
        weeks: [.mon, .tue, .wed, .thu, .fri, .sat, .sun],
        time: TimeConfig(starAt: SATTOTimetableTime(hour: 8, minute: 0), endAt: SATTOTimetableTime(hour: 22, minute: 0)),
        timebar: BarConfig(width: 20),
        weekbar: BarConfig(height: 20)
    )
}


