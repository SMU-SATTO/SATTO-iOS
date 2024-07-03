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
    
    @StateObject private var viewModel = TimetableListViewModel()
    
    @Binding var selectedId: Int
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.timetables, id: \.id) { timetable in
                        timetableBlock(headerText: timetable.semesterYear, timetableList: [(id: timetable.id, name: timetable.timetableName)])
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("시간표 목록")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        stackPath.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.blackWhite)
                    }
                }
            }
        }
        .onAppear() {
            //MARK: API
            viewModel.fetchTimetableList()
        }
    }
    
    private func timetableBlock(headerText: String, timetableList: [(id: Int, name: String)]) -> some View {
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
    
    private func contentView(timetableList: [(id: Int, name: String)]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(timetableList.indices, id: \.self) { index in
                let timetable = timetableList[index]
                Button(action: {
                    //TODO: id를 업데이트 main에서 id로 호출만 하고 맨처음은 기본호출일거고, 그 후는 id로 onappear 호출.
                    selectedId = timetable.id
                    stackPath.removeLast()
                }) {
                    HStack {
                        Text(timetable.name)
                            .font(.m18)
                            .foregroundStyle(Color.blackWhite)
                        Spacer()
                    }
                }
                .padding(.horizontal, 5)
                if index < timetableList.count - 1 {
                    Divider()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .padding(.top, 10)
    }
}

#Preview {
    TimetableListView(stackPath: .constant([]), selectedId: .constant(0))
        .preferredColorScheme(.light)
}
