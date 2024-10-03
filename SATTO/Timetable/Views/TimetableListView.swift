//
//  TimetableListView.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import SwiftUI

struct TimetableListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var stackPath: [TimetableRoute]
    
    @ObservedObject var timetableMainViewModel: TimetableMainViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                if groupedTimetables.isEmpty {
                    VStack {
                        Text("등록된 시간표가 없어요.")
                        Text("시간표를 만들어보세요!")
                        Button(action: {
                            stackPath.removeAll()
                            stackPath.append(.timetableOption)
                        }) {
                            HStack {
                                Text("시간표 생성하러 가기")
                                Image(systemName: "arrowshape.right.fill")
                            }
                            .font(.sb14)
                            .foregroundStyle(.blackWhite)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.buttonBlue200)
                                    .padding(EdgeInsets(top: -10, leading: -15, bottom: -10, trailing: -15))
                            )
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        }
                    }
                    .font(.sb16)
                    .foregroundStyle(Color.blackWhite)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(groupedTimetables.keys.sorted(by: >), id: \.self) { semesterYear in
                                if let timetables = groupedTimetables[semesterYear] {
                                    TimetableListRec(headerText: semesterYear, timetableList: timetables, timetableMainViewModel: timetableMainViewModel, stackPath: $stackPath)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Button(action: {
                            stackPath.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("돌아가기")
                                    .font(.sb16)
                            }
                            .foregroundStyle(Color.blackWhite)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("시간표 목록")
                        .font(.sb16)
                        .foregroundStyle(Color.blackWhite200)
                }
            }
        }
        .onAppear {
            Task {
                await timetableMainViewModel.fetchTimetableList()
            }
        }
    }
    
    private var groupedTimetables: [String: [TimetableListModel]] {
        Dictionary(grouping: timetableMainViewModel.timetableList?.compactMap { $0 } ?? [], by: { $0.semesterYear })
    }
}

struct TimetableListRec: View {
    let headerText: String
    let timetableList: [TimetableListModel]
    @ObservedObject var timetableMainViewModel: TimetableMainViewModel
    @Binding var stackPath: [TimetableRoute]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            headerView(headerText: headerText)
            contentView(timetableList: timetableList)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.menuCardBackground)
                .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
        )
    }

    private func headerView(headerText: String) -> some View {
        HStack {
            Text(headerText)
                .font(.b18)
                .padding(.top, 15)
                .padding(.leading, 20)
            Spacer()
        }
    }

    private func contentView(timetableList: [TimetableListModel]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(timetableList.indices, id: \.self) { index in
                let timetable = timetableList[index]
                Button(action: {
                    Task {
                        await timetableMainViewModel.fetchTimetable(id: timetable.id)
                        stackPath.removeLast()
                    }
                }) {
                    HStack {
                        Image(systemName: timetable.isPublic ? "lock.open" : "lock")
                        Text(timetable.timetableName)
                        if timetable.isRepresent {
                            Text("대표 시간표")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .font(.m18)
                    .foregroundStyle(Color.blackWhite)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                if index < timetableList.count - 1 {
                    Divider()
                }
            }
        }
    }
}

//#Preview {
//    TimetableListView(stackPath: .constant([]), timetableMainViewModel: TimetableMainViewModel())
//        .preferredColorScheme(.light)
//}
