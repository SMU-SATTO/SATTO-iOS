//
//  TimeTableTutorial.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct TimeTableTutorial: View {
    // 요일 배열
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // 시간 배열 (8am - 9pm)
    let hoursOfDay = Array(8...21).map { hour in
        let period = hour < 12 ? "am" : "pm"
        let hourIn12 = hour > 12 ? hour - 12 : hour
        return "\(hourIn12)\(period)"
    }
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    
    var body: some View {
        //        ScrollView {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("")
                    .font(Font.custom("Pretendard", size: 10))
                    .foregroundColor(Color(red: 0.19, green: 0.17, blue: 0.21))
                    .opacity(0.6)
                    .frame(width: 32, height: 40)
                
                ForEach(hoursOfDay, id: \.self) { hour in
                    Text(hour)
                        .font(Font.custom("Pretendard", size: 10))
                        .foregroundColor(Color(red: 0.19, green: 0.17, blue: 0.21))
                        .opacity(0.6)
                        .frame(width: 32, height: 40, alignment: .top)
                    
                }
            }
            
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        VStack(spacing: 0) {
                            Text(day)
                                .font(.system(size: 12, weight: .semibold)) // 변경된 폰트 사용
                                .frame(width: geo.size.width/6, height: 40)
                                .foregroundColor(Color(red: 0.27, green: 0.3, blue: 0.33))
                                .frame(maxWidth: .infinity, alignment: .top)
                                .opacity(0.9)
                            
                            ForEach(0..<hoursOfDay.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                
                if friendViewModel.timeTableInfo?.lects.count == 0 {
                    VStack {
                        Text("시간표 비어있음")
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        
                        Button(action: {
                            print(friendViewModel.timeTableInfo?.lects.count)
                        }, label: {
                            Text("과목개수")
                        })
                    }
                    
                }
                else{
                    if let lectures = friendViewModel.timeTableInfo?.lects {
                        
                        ForEach(lectures, id: \.codeSection) { lecture in
                            ForEach(makeTimeBlock(lectures: [lecture]), id: \.0.codeSection) { lecture, periods, firstTimes in
                                ForEach(0..<periods.count, id: \.self) { index in
                                    let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                    let periodIndex = getPeriodIndex(period: String(firstTimes[index].suffix(1)))
                                    let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                    
                                    VStack(spacing: 0) {
                                        Spacer()
                                            .frame(height: 5)
                                        Text(lecture.lectName)
                                            .font(.m11)
                                            .foregroundColor(.white)
                                        //                                        Text("\(lecture.professor)")
                                        //                                            .font(.system(size: 8))
                                        //                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    )
                                    .background(backgroundColor)
                                    //                                    .background(Color.blue)
                                    .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                              y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                                    
                                }
                            }
                        }
                    } else {
                        Text("No lectures found")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        //        }
        //        .onAppear {
        //            assignColors()
        //        }
    }
    
    //    func assignColors() {
    //        var assignedColors: [String: Color] = [:]
    //        var colorIndex = 0
    //
    //        if let lectures = friendViewModel.detailTimetable?.lects {
    //
    //            for lecture in lectures {
    //                if assignedColors[lecture.codeSection] == nil {
    //                    assignedColors[lecture.codeSection] = friendViewModel.colors[colorIndex % friendViewModel.colors.count]
    //                    colorIndex += 1
    //                }
    //            }
    //        }
    ////        print(assignedColors)
    //        friendViewModel.colorMapping = assignedColors
    //    }
    
    func makeTimeBlock(lectures: [Lecture]) -> [(Lecture, [Int], [String])] {
        var result: [(Lecture, [Int], [String])] = []
        
        for lecture in lectures {
            let lectTimes = lecture.lectTime.split(separator: " ").map { String($0) }
            var period = [Int]()
            var firstTimes = [String]()
            var count = 1
            
            for i in 0..<lectTimes.count-1 {
                if let nextTime = nextNumberString(from: String(lectTimes[i])), nextTime == String(lectTimes[i+1]) {
                    count += 1
                } else {
                    period.append(count)
                    firstTimes.append(lectTimes[i - count + 1])  // 연속 시간의 첫 번째 시간을 추가
                    count = 1
                }
            }
            
            // 마지막 강의 시간 블록 처리
            period.append(count)
            firstTimes.append(lectTimes[lectTimes.count - count])
            
            result.append((lecture, period, firstTimes))
        }
        
        //        print(result)
        return result
    }
    
    
    func nextNumberString(from string: String) -> String? {
        let day = String(string.prefix(1)) // 요일 추출
        let numberString = String(string.suffix(1)) // 숫자 부분 추출
        
        guard let number = Int(numberString) else {
            return nil
        }
        
        let nextNumber = number + 1 // 다음 숫자 계산
        return "\(day)\(nextNumber)" // 요일과 다음 숫자를 결합하여 반환
    }
    
    func getDayIndex(day: String) -> Int {
        switch day {
        case "월": return 0
        case "화": return 1
        case "수": return 2
        case "목": return 3
        case "금": return 4
        case "토": return 5
        default: return 0
        }
    }
    
    func getPeriodIndex(period: String) -> Int {
        return (Int(period) ?? 1)
    }
    
    //    func getColorForCodeSection(codeSection: String) -> Color {
    //        return friendViewModel.colorMapping[codeSection] ?? .clear
    //    }
}


