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
        public var startAt: TimetableTime
        public var endAt: TimetableTime

        public static let `default`: TimeConfig = TimeConfig(
            startAt: TimetableTime(hour: 9, minute: 0), endAt: TimetableTime(hour: 21, minute: 0)
        )
    }
    
    public struct BarConfig: Codable, Sendable {
        public var width: CGFloat
        public var height: CGFloat
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
                time: TimeConfig = .default,
                timebar: BarConfig = BarConfig(width: 20, height: 0),
                weekbar: BarConfig = BarConfig(width: 0, height: 20),
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
        time: TimeConfig(startAt: TimetableTime(hour: 8, minute: 0), endAt: TimetableTime(hour: 22, minute: 0)),
        timebar: BarConfig(width: 20, height: 0),
        weekbar: BarConfig(width: 0, height: 20)
    )
}

public struct TimetableTime: Codable, Comparable, Sendable, Identifiable {
    public var id: Int { hour*60 + minute }
    public var hour: Int
    public var minute: Int
    
    public init(hour: Int, minute: Int) {
        self.hour = min(24, hour)
        self.minute = min(60, minute)
    }
    
    public init(date: Date) {
        let calendar = Calendar.current
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
    
    public static func < (lhs: TimetableTime, rhs: TimetableTime) -> Bool {
        lhs.hour*60+lhs.minute < rhs.hour*60+rhs.minute
    }
}

public enum Weekdays: Int ,CaseIterable, Identifiable, Codable, Sendable {
    case sun = 0
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    
    public var id: Int { self.rawValue }
    
    ///For example, for English in the Gregorian calendar, returns `["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]`.
    public var symbol: String {
        Calendar.current.weekdaySymbols[self.rawValue]
    }
    
    public var symbolKor: String {
        switch self {
        case .sun: return "일요일"
        case .mon: return "월요일"
        case .tue: return "화요일"
        case .wed: return "수요일"
        case .thu: return "목요일"
        case .fri: return "금요일"
        case .sat: return "토요일"
        }
    }
    
    /// For example, for English in the Gregorian calendar, returns `["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]`.
    public var shortSymbol: String {
        Calendar.current.shortWeekdaySymbols[self.rawValue]
    }
    public var shortSymbolKor: String {
        switch self {
        case .sun: return "일"
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        }
    }
    
    /// For example, for English in the Gregorian calendar, returns `["S", "M", "T", "W", "T", "F", "S"]`.
    public var veryShortSymbol: String {
        Calendar.current.veryShortWeekdaySymbols[self.rawValue]
    }
    
    public init?(date: Date) {
        let week = Calendar.current.component(.weekday, from: date)
        self.init(rawValue: week-1)
    }
}



