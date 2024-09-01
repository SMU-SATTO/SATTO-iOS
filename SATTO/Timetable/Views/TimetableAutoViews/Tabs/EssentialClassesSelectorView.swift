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
    @ObservedObject var selectedValues: SelectedValues
    @ObservedObject var bottomSheetViewModel: BottomSheetViewModel
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var isShowBottomSheet = false
    @State private var usingSelectedSubjects = true
    
    var body: some View {
        ScrollView {
            HStack {
                VStack (alignment: .leading, spacing: 2) {
                    Text("이번 학기에 필수로 들어야 할\n과목을 선택해 주세요.")
                        .font(.sb18)
                        .lineSpacing(5)
                    Text("ex) 재수강, 교양필수, 전공필수")
                        .font(.m12)
                        .foregroundStyle(.gray400)
                        .padding(.top, 5)
                }
                Button(action: {
                    isShowBottomSheet = true
                }) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.buttonBlue)
                        .frame(width: 100, height: 50)
                }
                Spacer()
            }
            .padding(.leading, 30)
            
            TimetableView(timetableBaseArray: selectedValues.selectedSubjects)
                .onTapGesture {
                    isShowBottomSheet = true
                }
                .sheet(isPresented: $isShowBottomSheet, content: {
                    BottomSheetTabView(
                        selectedValues: selectedValues,
                        bottomSheetViewModel: bottomSheetViewModel,
                        selectedSubviews: $selectedSubviews,
                        alreadySelectedSubviews: $alreadySelectedSubviews,
                        showResultAction: {isShowBottomSheet = false}
                    )
                    .presentationDetents([.medium, .large])
                })
        }
    }
}

#Preview {
    EssentialClassesSelectorView(selectedValues: SelectedValues(), bottomSheetViewModel: BottomSheetViewModel())
}
