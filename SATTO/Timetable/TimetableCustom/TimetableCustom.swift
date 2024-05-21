//
//  TimetableCustom.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI

struct TimetableCustom: View {
    @Binding var stackPath: [Route]
    
    @StateObject var timetableViewModel = TimetableViewModel()
    
    @State private var isShowBottomSheet = false
    @State private var isUsingSelectedSubjects = true
    var body: some View {
        VStack {
            VStack (spacing: 2) {
                Text("이번 학기에 들을 과목을 선택해 주세요.")
                    .font(.sb18)
                    .frame(width: 320, alignment: .topLeading)
            }
            TimetableView(timetableViewModel: timetableViewModel, usingSelectedSubjects: $isUsingSelectedSubjects)
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
    TimetableCustom(stackPath: .constant([.timetableCustom]))
}
