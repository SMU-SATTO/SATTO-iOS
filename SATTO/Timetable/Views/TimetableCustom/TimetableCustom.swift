//
//  TimetableCustom.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI

struct TimetableCustom: View {
    @Binding var stackPath: [TimetableRoute]
    
    @StateObject var selectedValues = SelectedValues()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var isShowBottomSheet = false
    @State private var isUsingSelectedSubjects = true
    @State private var showingAlert = false
    @State private var timetableName = ""
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    Text("이번 학기에 들을 과목을 선택해 보세요!")
                        .font(.sb18)
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
                Button(action: {
                    showingAlert = true
                }) {
                    Text("시간표 저장하기")
                        .font(.sb16)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.buttonBlue)
                                .padding(EdgeInsets(top: -10, leading: -30, bottom: -10, trailing: -30))
                        )
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                    
                }
                .padding()
            }
        }
        .alert("시간표 이름을 입력해주세요", isPresented: $showingAlert) {
            VStack {
                TextField("시간표 이름", text: $timetableName)
                    .autocorrectionDisabled()
                HStack {
                    Button("취소", role: .cancel, action: {})
                    Button("확인") {
                        saveTimetable()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        stackPath.removeLast()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("시간표 생성 취소하기")
                                .font(.sb16)
                        }
                        .foregroundStyle(Color.blackWhite)
                    }
                }
            }
        }
    }
    
    private func saveTimetable() {
        selectedValues.postCustomTimetable(codeSectionList: selectedValues.selectedSubjects.map { $0.sbjDivcls }, semesterYear: "2024학년도 2학기", timeTableName: timetableName, isPublic: true, isRepresented: false) { success in
            DispatchQueue.main.async {
                stackPath.removeLast()
            }
        }
    }
}

#Preview {
    TimetableCustom(stackPath: .constant([.timetableCustom]))
}
