//
//  EssentialClassesSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI
import JHTimeTable

//MARK: - 필수로 들어야 할 과목 선택
struct EssentialClassesSelectorView: View {
    @State private var isShowBottomSheet = false
    var body: some View {
        VStack {
            VStack (spacing: 2) {
                Text("이번 학기에 필수로 들어야 할\n과목을 선택해 주세요.")
                    .font(.sb18)
                    .lineSpacing(5)
                    .frame(width: 320, alignment: .topLeading)
                Text("ex) 재수강, 교양필수, 전공필수")
                    .font(.m12)
                    .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                    .frame(width: 320, alignment: .topLeading)
                    .padding(.top, 5)
            }
            TimeTableView(timetableViewModel: TimetableViewModel())
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
