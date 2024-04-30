//
//  EssentialClassesSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI
import JHTimeTable

#if DEBUG
import Foundation

struct LectureModel: Identifiable {
    var id: String { title }
    var title: String
    var color: String
    var week: LectureWeeks
    var startAt: LectureTableTime
    var endAt: LectureTableTime
}

extension LectureModel {
    static let examples: [LectureModel] = [
        LectureModel(title: "Lecture1", color: "FF204E",
                     week: .mon,
                     startAt: .init(hour: 9, minute: 0),
                     endAt: .init(hour: 11, minute: 0)),
        LectureModel(title: "Lecture2", color: "007F73",
                     week: .tue,
                     startAt: .init(hour: 15, minute: 0),
                     endAt: .init(hour: 17, minute: 0)),
        LectureModel(title: "Lecture3", color: "E8751A",
                     week: .thu,
                     startAt: .init(hour: 11, minute: 0),
                     endAt: .init(hour: 13, minute: 0))
    ]
}
#endif


//MARK: - 필수로 들어야 할 과목 선택
struct EssentialClassesSelectorView: View {
    @State private var isShowBottomSheet = false
    var body: some View {
        VStack {
            Text("이번 학기에 필수로 들어야 할\n과목을 선택해 주세요.")
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .lineSpacing(5)
                .frame(width: 320, alignment: .topLeading)
            Text("ex) 재수강, 교양필수, 전공필수")
                .font(Font.custom("Pretendard", size: 12))
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                .frame(width: 320, alignment: .topLeading)
                .padding(.top, 5)
            JHLectureTable {
                ForEach(LectureModel.examples) { lecture in
                    ZStack(alignment: .topLeading) {
                        Rectangle()
    //                        .foregroundStyle(Color(hexString: lecture.color))
                        Text(lecture.title)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 2, leading: 3, bottom: 0, trailing: 0))
                    }
                    .lectureTableTime(week: lecture.week,
                                      startAt: lecture.startAt,
                                      endAt: lecture.endAt)
                }
            } timebar: { time in
                // Add customized timebar
                Text("\(time.hour)")
                    .padding(.trailing, 3)
            } weekbar: { week in
                // week: LectureWeeks enum
                // You can use week.symbol, week.shortSymbol, week.veryShortSymbol
                // Add cusomized weekbar
                Text("\(week)")
                    .padding(.horizontal, 0)
            } background: {
                // Add background
            }
            .lectureTableWeekdays([.sun, .mon, .tue, .wed, .thu, .fri, .sat])
            
            .lectureTableTimes(startAt: .init(hour: 8, minute: 0), endAt: .init(hour: 22, minute: 0)) // 시작, 끝 시간 설정
            .lectureTableBorder(width: 0.5, radius: 0, color: "#979797") // table 그리드 선 색 변경
            .lectureTableBar(time: .init(height: 0, width: 30), week: .init(height: 30, width: 10)) //날짜, 시간 위치 변경 가능
            .frame(width: 350, height: 500)
            .onTapGesture {
                isShowBottomSheet.toggle()
            }
            .sheet(isPresented: $isShowBottomSheet, content: {
                SearchSheetTabView()
                    .presentationDetents([.medium, .large])
            })
        }
    }
}

#Preview {
    EssentialClassesSelectorView()
}
