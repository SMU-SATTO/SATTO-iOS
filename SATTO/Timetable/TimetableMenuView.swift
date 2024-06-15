//
//  TimetableMenuView.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import SwiftUI

struct TimetableMenuView: View {
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
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.skyblue, lineWidth: 1.5)
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
        VStack(alignment: .leading, spacing: 10) {
            ForEach(timetableList, id: \.self) { timetableName in
                Button(action: {
                    stackPath.removeLast()
                }) {
                    HStack {
                        Text(timetableName)
                            .font(.m18)
                            .foregroundStyle(Color.blackWhite)
                        Spacer()
                    }
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
        .preferredColorScheme(.dark)
}
