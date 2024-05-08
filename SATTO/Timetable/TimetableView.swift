//
//  TimetableView.swift
//  SATTO
//
//  Created by yeongjoon on 5/2/24.
//

import SwiftUI
import JHTimeTable

struct TimetableView: View {
    @ObservedObject var timetableViewModel: TimetableViewModel
    @State var isFirst = true
    
    var body: some View {
        ///테스트 코드
//        VStack {
//            Text("Test")
//            ForEach(timetableViewModel.convertToLectureModels()) { lecture in
//                VStack {
//                    Text("Title: \(lecture.title)")
//                    Text("Color: \(lecture.color)")
//                    Text("Week: \(lecture.week)")
//                    Text("Start At: \(lecture.startAt.hour)")
//                    Text("End At: \(lecture.endAt.hour)")
//                    Divider()
//                }
//            }
//            Text("End")
//        }
        JHLectureTable {
            ForEach(timetableViewModel.convertToLectureModels()) { lecture in
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
//                .id(lecture.title)
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
    TimetableView(timetableViewModel: TimetableViewModel())
}
