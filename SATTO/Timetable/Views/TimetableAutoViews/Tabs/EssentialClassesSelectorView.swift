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
                Spacer()
                
                Button(action: {
                    isShowBottomSheet = true
                }) {
                    Text("강의 목록 보기")
                        .font(.sb14)
                        .foregroundStyle(.blackWhite)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 2)
                                        .stroke(.buttonBlue200, lineWidth: 1.5)
                                )
                                .padding(EdgeInsets(top: -10, leading: -15, bottom: -10, trailing: -15))
                        )
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                }
            }
            .padding(.horizontal, 30)
            
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
