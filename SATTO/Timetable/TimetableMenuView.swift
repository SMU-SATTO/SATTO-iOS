//
//  TimetableMenuView.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import SwiftUI

struct TimetableMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var stackPath: [Route]
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 10) {
                    timetableBlock(headerText: "2024년 1학기", timetableList: ["시간표", "2"])
                    timetableBlock(headerText: "2023년 2학기", timetableList: ["3", "9", "10"])
                    timetableBlock(headerText: "2023년 1학기", timetableList: ["4", "6"])
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
    }
    
    private func timetableBlock(headerText: String, timetableList: [String]) -> some View {
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
    
    private func contentView(timetableList: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(timetableList.indices, id: \.self) { index in
                let timetableName = timetableList[index]
                Button(action: {
//                    stackPath.removeLast()
                }) {
                    HStack {
                        Text(timetableName)
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
    TimetableMenuView(stackPath: .constant([]))
        .preferredColorScheme(.light)
}
