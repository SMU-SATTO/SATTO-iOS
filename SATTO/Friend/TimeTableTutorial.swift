//
//  TimeTableTutorial.swift
//  SATTO
//
//  Created by 황인성 on 7/26/24.
//

import SwiftUI

struct TimeTableTutorial: View {
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    // 요일 배열
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // 시간 배열 (8am - 9pm)
    let hoursOfDay = Array(8...21).map { hour in
        let period = hour < 12 ? "am" : "pm"
        let hourIn12 = hour > 12 ? hour - 12 : hour
        return "\(hourIn12)\(period)"
    }
    
    
    var body: some View {
        // 시간표시
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                // 요일을 표시하는 부분
                Text("")
                    .font(Font.custom("Pretendard", size: 10))
                    .opacity(0.6)
                    .frame(width: 32, height: 40)
                // 여기서부터 시간 표시
                ForEach(hoursOfDay, id: \.self) { hour in
                    Text(hour)
                        .font(Font.custom("Pretendard", size: 10))
                        .opacity(0.6)
                        .frame(width: 32, height: 40, alignment: .top)
                }
            }
            .foregroundStyle(Color.cellText)
            
            // 시간부분 뺴고 지오메트리리더
            GeometryReader { geo in
                HStack(spacing: 0) {
                    // 요일의 개수만큼
                    ForEach(daysOfWeek, id: \.self) { day in
                        VStack(spacing: 0) {
                            // 요일 표시
                            Text(day)
                                .font(.system(size: 12, weight: .semibold)) // 변경된 폰트 사용
                                .frame(width: geo.size.width/6, height: 40)
                                .frame(maxWidth: .infinity, alignment: .top)
                                .opacity(0.9)
                            // 시간 개수만큼 사각형 나열
                            ForEach(0..<hoursOfDay.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color.cellText, lineWidth: 0.5)
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                .foregroundStyle(Color.cellText)
                
                // 만약 시간표 정보의 강의의 수가 0이면 지오메트리리더 가운데 텍스트 위치시키기
                if friendViewModel.timeTableInfo?.lects.count == 0 {
                    // 일단 주석처리 ????
//                        Text("시간표 비어있습니다")
//                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                // 시간표 정보의 강의가 있을때
                else{
                    // timeTableInfo가 nil이 아닐때
                    if let lectures = friendViewModel.timeTableInfo?.lects {
                        // 강의들을 학수번호를 id로 반복
                        ForEach(lectures, id: \.codeSection) { lecture in
                            // [(Lecture, [Int], [String])]로 반환된 값을 Lecture.codeSection을 id로 반복
                            ForEach(makeTimeBlock(lectures: [lecture]), id: \.0.codeSection) { lecture, periods, firstTimes in
                                // periods의 개수 만큼 반복
                                ForEach(0..<periods.count, id: \.self) { index in
                                    // firstTimes의 요소의 요일부분을 숫자로 변환 ex) 월3->0 화2->1
                                    let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                    // firstTimes의 요소의 숫자부분을 숫자로 변환 ex) 월3->3 화2->2
                                    let periodIndex = getPeriodIndex(period: String(firstTimes[index].substring(from: 1)))
                                    // 매핑되어있는 학수번호를 넣으면 색이 나온다
                                    let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                    
                                    // 강의 표시하는 블럭
                                    VStack(spacing: 0) {
                                        Spacer()
                                            .frame(height: 5)
                                        Text(lecture.lectName)
                                            .font(.m11)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    // 가로길이는 전체에서 요일의 개수로 나눔
                                    // 세로길이는 블럭 세로길이 곱하기 periods[index]
                                    .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                    .overlay(
                                        // 테두리 표시하는거 같은데 의미있나???
                                        Rectangle()
                                            .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    )
                                    // 학수번호에 맵핑되어있던 배경색
                                    .background(backgroundColor)
                                    // x축은 몇번쨰 요일인지 확인후 그 요일의 중앙으로 옮긴다
                                    // y축은 이해가 안되게 나중에 봐야함 ????
                                    .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                              y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    
    // 강의 배열을 받으면 강의와 숫자배열, 문자배열을 리턴한다
    func makeTimeBlock(lectures: [Lecture]) -> [(Lecture, [Int], [String])] {
        // 빈 배열 상성
        var result: [(Lecture, [Int], [String])] = []
        // 강의 배열을 반복
        for lecture in lectures {
            // 강의시간을 " "기준으로 나눠서 문자배열로 저장
            let lectTimes = lecture.lectTime.split(separator: " ").map { String($0) }
            // 빈 숫자배열 생성
            var period = [Int]()
            // 빈 문자배열 생성
            var firstTimes = [String]()
            // 카운트
            var count = 1
            
            // (강의시간을 나눈 배열 - 1) 번 반복
            for i in 0..<lectTimes.count-1 {
                // nextNumberString은 입력받은 시간의 다음시간을 반환
                // 그 다음시간이 실제 강의 다음시간과 일치하면 count에 1을 더함
                if let nextTime = nextNumberString(from: String(lectTimes[i])), nextTime == String(lectTimes[i+1]) {
                    count += 1
                }
                // 일치하지 않으면
                else {
                    // 빈 숫자배열에 count를 대입
                    period.append(count)
                    // 빈 문자배열에 연속되는 시간의 첫번째 값 대입
                    firstTimes.append(lectTimes[i - count + 1])  // 연속 시간의 첫 번째 시간을 추가
                    count = 1
                }
            }
            
            // 마지막 강의 시간까지 처리
            // 시간 연속여부 추가
            period.append(count)
            // 연속된 시간의 첫번쨰 요소 추가
            firstTimes.append(lectTimes[lectTimes.count - count])
            // 리턴 타입으로 변환
            result.append((lecture, period, firstTimes))
        }
        return result
    }
    
    // 문자열을 받아서 옵셔널 문자열을 리턴
    func nextNumberString(from string: String) -> String? {
        // 입력받은 문자열 첫번쨰 글자
        let day = String(string.prefix(1)) // 요일 추출
        // 입력받은 문자열의 마지막 글자
        let numberString = String(string.substring(from: 1)) // 숫자 부분 추출
        // 마지막 글자를 숫자로 형변환
        guard let number = Int(numberString) else {
            // 숫자가 아니면 함수 종류 nil반환
            return nil
        }
        // 마직막 숫자에 + 1
        let nextNumber = number + 1 // 다음 숫자 계산
        // 입력받은 문자 + (입력받은 숫자 + 1)
        return "\(day)\(nextNumber)" // 요일과 다음 숫자를 결합하여 반환
    }
    
    // 요일이 몇번쨰 요일인지 정수로 반환
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
}


extension String {
    func substring(from index: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[startIndex...])
    }
}

