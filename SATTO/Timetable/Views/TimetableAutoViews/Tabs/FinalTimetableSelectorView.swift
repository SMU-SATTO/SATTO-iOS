//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

struct FinalTimetableSelectorView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var showingPopup: Bool
    @Binding var timetableIndex: Int

    var body: some View {
        ZStack {
            VStack {
                Text("좌우로 스크롤해 \n원하는 시간표를 골라보세요!")
                    .font(.sb16)
                TabView {
                    ForEach(selectedValues.timetableList.indices, id: \.self) { index in
                        TimetableView(timetableBaseArray: selectedValues.timetableList[index])
                            .onTapGesture {
                                timetableIndex = index
                                showingPopup.toggle()
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .onAppear {
                    UIScrollView.appearance().isScrollEnabled = true //드래그제스처로 탭뷰 넘기는거 여기 TabView에서만 허용
                }
            }
        }
    }
}

struct FinalSelectPopupView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var finalSelectPopup: Bool
    @Binding var timetableIndex: Int
    
    @State private var showingAlert = false
    @State private var timeTableName = "시간표"
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 600)
                .foregroundStyle(Color.popupBackground)
                .overlay(
                    VStack(spacing: 0) {
                        TimetableView(timetableBaseArray: selectedValues.timetableList[timetableIndex])
                            .padding(EdgeInsets(top: -45, leading: 15, bottom: 0, trailing: 15))
                        Text("이 시간표를 이번 학기 시간표로\n결정하시겠어요?")
                            .font(.sb16)
                            .foregroundStyle(Color.blackWhite200)
                            .multilineTextAlignment(.center)
                            .padding(.top, -40)
                        
                        Button(action: {
                            showingAlert = true
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.buttonBlue)
                                .frame(height: 40)
                                .padding(.horizontal, 30)
                                .overlay(
                                    Text("네, 결정했어요")
                                        .font(.sb14)
                                        .foregroundStyle(.white)
                                )
                                .padding(.top, 10)
                        }
                        
                        Button(action: {
                            finalSelectPopup = false
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.clear)
                                .frame(height: 40)
                                .padding(.horizontal, 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.buttonBlue, lineWidth: 1.5)
                                        .padding(.horizontal, 30)
                                        .overlay(
                                            Text("아니요, 더 둘러볼래요")
                                                .font(.sb14)
                                                .foregroundStyle(Color.buttonBlue)
                                        )
                                )
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                        }
                    }
                )
                .alert("시간표 이름을 입력해주세요", isPresented: $showingAlert) {
                    TextField(timeTableName, text: $timeTableName)
                    HStack {
                        Button("취소", role: .cancel, action: {})
                        Button("확인") {
                            //TODO: - API - 정적인 값 존재
                            selectedValues.postSelectedTimetable(timetableIndex: timetableIndex, semesterYear: "2024학년도 2학기", timeTableName: timeTableName, isPublic: true, isRepresented: false)
                            finalSelectPopup = false
                        }
                    }
                }
        }
    }
}

#Preview {
    FinalTimetableSelectorView(selectedValues: SelectedValues(), showingPopup: .constant(false), timetableIndex: .constant(1))
        .preferredColorScheme(.dark)
}
