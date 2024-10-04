//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/21/24.
//

import SwiftUI

struct TimetableModifyView: View {
    @Binding var stackPath: [TimetableRoute]
    
    @ObservedObject var lectureSearchViewModel: LectureSearchViewModel
    @ObservedObject var timetableMainViewModel: TimetableMainViewModel
    
    @State private var isShowBottomSheet = false
    @State private var showingBackAlert = false
    @State private var showingConfirmAlert = false
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    Text("이번 학기에 들을 과목을 선택해 주세요.")
                        .font(.sb18)
                    Spacer()
                    ShowLectureButton(action: {
                        isShowBottomSheet = true
                    })
                }
                .padding(.horizontal, 30)
                if let currentTimetable = timetableMainViewModel.currentTimetable {
                    TimetableView(timetable: TimetableModel(id: currentTimetable.id, semester: currentTimetable.semester, name: currentTimetable.name, lectures: lectureSearchViewModel.selectedLectures, isPublic: currentTimetable.isPublic, isRepresented: currentTimetable.isRepresented))
                        .sheet(isPresented: $isShowBottomSheet, content: {
                            LectureSearchView(viewModel: lectureSearchViewModel, showResultAction: {isShowBottomSheet = false})
                            .presentationDetents([.medium, .large])
                        })
                        .padding(.horizontal, 15)
                    Button(action: {
                        showingConfirmAlert = true
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
        }
        .onAppear {
            lectureSearchViewModel.selectedLectures = timetableMainViewModel.currentTimetable?.lectures ?? []
        }
        .onDisappear {
            lectureSearchViewModel.clearSelectedLectures()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        showingBackAlert = true
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
        .alert("지금 뒤로 가면 수정사항이 사라져요!", isPresented: $showingBackAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                stackPath.removeLast()
            }
        }
        .alert("이대로 시간표를 수정할까요?", isPresented: $showingConfirmAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                Task {
                    await timetableMainViewModel.patchTimetableInfo()
                    await timetableMainViewModel.fetchTimetable(id: timetableMainViewModel.currentTimetable?.id)
                    stackPath.removeLast()
                }
            }
        }
    }
}

#Preview {
    TimetableModifyView(stackPath: .constant([.timetableModify]), lectureSearchViewModel: LectureSearchViewModel(container: .preview), timetableMainViewModel: TimetableMainViewModel(container: .preview))
}
