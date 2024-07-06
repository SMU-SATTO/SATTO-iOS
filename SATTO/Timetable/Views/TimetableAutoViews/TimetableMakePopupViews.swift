//
//  TimetableMakePopupViews.swift
//  SATTO
//
//  Created by yeongjoon on 7/6/24.
//

import SwiftUI

struct InvalidPopup: View {
    @Binding var invalidPopup: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.popupBackground)
            .frame(width: 300, height: 300)
            .overlay(
                VStack(spacing: 30) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.yellow)
                    
                    Text("불가능한 시간대가 많으면\n원활한 시간표 생성이 어려울 수 있어요.")
                        .font(.sb16)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        invalidPopup = false
                    }) {
                        Text("확인했어요")
                            .font(.sb14)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.buttonBlue)
                    )
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                }
            )
    }
}

struct MidCheckPopup: View {
    @Binding var midCheckPopup: Bool
    let navigateForward: () -> Void
    let selectedValues: SelectedValues
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.popupBackground)
            .frame(width: 300, height: 360)
            .overlay(
                VStack(spacing: 30) {
                    Image(systemName: "exclamationmark.warninglight")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("시간표를 생성하면\n현재 설정은 수정할 수 없어요!!")
                        .font(.sb16)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                    VStack {
                        Button(action: {
                            navigateForward()
                            midCheckPopup = false
                        }) {
                            Text("시간표 생성하러 가기")
                                .font(.sb14)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.buttonBlue)
                        )
                        .frame(height: 40)
                        Button(action: {
                            midCheckPopup = false
                        }) {
                            Text("조금 더 고민해보기")
                                .font(.sb14)
                                .foregroundStyle(Color.buttonBlue)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 2)
                                        .stroke(Color.buttonBlue, lineWidth: 1.5)
                                )
                        )
                        .frame(height: 40)
                    }
                    .padding(.horizontal, 15)
                }
            )
    }
}

struct FinalSelectPopup: View {
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var finalSelectPopup: Bool
    @Binding var completionPopup: Bool
    @Binding var isRegisterSuccess: Bool
    
    @Binding var timetableIndex: Int
    @Binding var registeredTimetableList: Set<Int>
    
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
                        acceptButton
                        declineButton
                    }
                )
                .alert("시간표 이름을 입력해주세요", isPresented: $showingAlert) {
                    alertContent
                }
        }
    }
    
    private var acceptButton: some View {
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
    }
    
    private var declineButton: some View {
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
    
    private var alertContent: some View {
        VStack {
            TextField("시간표 이름", text: $timeTableName)
            HStack {
                Button("취소", role: .cancel, action: {})
                Button("확인") {
                    saveTimetable()
                }
            }
        }
    }
    
    private func saveTimetable() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        selectedValues.postSelectedTimetable(timetableIndex: timetableIndex, semesterYear: "2024학년도 2학기", timeTableName: timeTableName, isPublic: true, isRepresented: false) { success in
            DispatchQueue.main.async {
                isRegisterSuccess = success
                if success {
                    registeredTimetableList.insert(timetableIndex)
                }
                finalSelectPopup = false
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completionPopup = true
        }
    }
}

struct ErrorPopup: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 300, height: 300)
                .overlay(
                    Text("시간표 생성에 실패했어요. 전공 조합을 다시 선택해보거나 개발자에게 문의해주세요!")
                        .font(.sb14)
                        .foregroundStyle(.blackWhite)
                )
        }
    }
}

struct TimetableSelectCompletionPopup: View {
    @Binding var completionPupop: Bool
    @Binding var isRegisterSuccess: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isRegisterSuccess ? "시간표 등록이 완료되었습니다." : "시간표 등록에 실패했습니다.\n현상이 지속되면 개발자에게 문의해주세요!")
                .font(.sb16)
                .foregroundStyle(.blackWhite)
                .multilineTextAlignment(.center)
            Button(action: {
                completionPupop = false
            }) {
                Text("확인")
                    .font(.m16)
                    .foregroundStyle(.blackWhite)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.popupBackground)
                .padding(EdgeInsets(top: -20, leading: -20, bottom: -20, trailing: -20))
                .shadow(radius: 5)
        )
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
}
