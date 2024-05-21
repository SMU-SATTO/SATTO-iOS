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
    @ObservedObject var timetableViewModel: TimetableViewModel
    
    @State private var isShowBottomSheet = false
    @State private var usingSelectedSubjects = true
    
    var body: some View {
        VStack {
            VStack (spacing: 2) {
                Text("이번 학기에 필수로 들어야 할\n과목을 선택해 주세요.")
                    .font(.sb18)
                    .lineSpacing(5)
                    .frame(width: 320, alignment: .topLeading)
                Text("ex) 재수강, 교양필수, 전공필수")
                    .font(.m12)
                    .foregroundStyle(.gray400)
                    .frame(width: 320, alignment: .topLeading)
                    .padding(.top, 5)
            }
            TimetableView(timetableViewModel: timetableViewModel, usingSelectedSubjects: $usingSelectedSubjects)
                .onTapGesture {
                    isShowBottomSheet = true
                }
                .sheet(isPresented: $isShowBottomSheet, content: {
                    SearchSheetTabView(timetableViewModel: timetableViewModel, showResultAction: {isShowBottomSheet = false})
                        .presentationDetents([.medium, .large])
                })
        }
    }
}

#Preview {
    EssentialClassesSelectorView(timetableViewModel: TimetableViewModel())
}
