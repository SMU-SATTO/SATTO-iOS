//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import SwiftUI

struct TimetableModifyView: View {
    @Binding var stackPath: [TimetableRoute]
    
    @StateObject var selectedValues = SelectedValues()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    
    @ObservedObject var timetableMainViewModel: TimetableMainViewModel
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var isShowBottomSheet = false
    @State private var isUsingSelectedSubjects = true
    
    @State private var showingAlert = false
    
    @Binding var timetableId: Int
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    Text("이번 학기에 들을 과목을 선택해 주세요.")
                        .font(.sb18)
                    Spacer()
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
                    timetableMainViewModel.patchTimetableInfo(timetableId: timetableMainViewModel.timetableId, codeSectionList: selectedValues.selectedSubjects)
                    stackPath.removeLast()
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
        .onAppear {
            selectedValues.selectedSubjects = timetableMainViewModel.timetableInfo
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        showingAlert = true
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("시간표 수정 취소하기")
                                .font(.sb16)
                        }
                        .foregroundStyle(Color.blackWhite)
                    }
                    
                }
            }
        }
        .alert("지금 뒤로 가면 수정사항이 사라져요!", isPresented: $showingAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                stackPath.removeLast()
            }
        }
    }
}

#Preview {
    TimetableModifyView(stackPath: .constant([.timetableModify]), timetableMainViewModel: TimetableMainViewModel(), timetableId: .constant(0))
}