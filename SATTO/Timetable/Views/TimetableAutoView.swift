//
//  TimetableAutoView.swift
//  SATTO
//
//  Created by 김영준 on 2/29/24.
//

import SwiftUI
import PopupView

struct TimetableAutoView: View {
    enum SelectedView: CaseIterable {
        case creditPicker, essentialClasses, invalidTime, midCheck, majorCombination, finalTimetable
    }

    @Binding var stackPath: [TimetableRoute]
    
    @ObservedObject var constraintsViewModel: ConstraintsViewModel
    @ObservedObject var lectureSearchViewModel: LectureSearchViewModel
    
    @State private var selectedView: SelectedView = .creditPicker
    
    @State private var isProgressing = false
    
    @State private var midCheckPopup = false
    @State private var errorPopup = false
    @State private var finishMakingPopup = false          //시간표 생성 끝낼 때 뜨는 팝업
    @State private var backAlert = false
    
    @State private var timetableIndex = 0
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                pageControl
                tabView
                    .padding(.top)
                tabViewNavigationButtons
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
            }
            .animation(.easeInOut, value: UUID())
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customToolBar
            }
        }
        .alert("시간표 자동 생성을 취소하고 뒤로 가시겠어요?", isPresented: $backAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                constraintsViewModel.resetAllProperties()
                lectureSearchViewModel.resetAllProperties()
                stackPath.removeLast()
            }
        }
        .STPopup(isPresented: $isProgressing) {
            TimetableProgressView()
        }
    }
    
    private var customToolBar: some View {
        HStack {
            Button(action: {
                backAlert = true
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
    
    private var pageControl: some View {
        VStack {
            TimetableAutoPageControl(totalIndex: SelectedView.allCases.count, selectedIndex: selectedViewIndex())
                .animation(.spring(), value: UUID())
                .padding(.horizontal)
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedView) {
            CreditPickerView(credit: $constraintsViewModel.constraints.credit, majorCount: $constraintsViewModel.constraints.majorCount, eLearnCount: $constraintsViewModel.constraints.eLearnCount)
                .tag(SelectedView.creditPicker)
            EssentialLectureSelector(viewModel: lectureSearchViewModel)
                .tag(SelectedView.essentialClasses)
            InvalidTimeSelectorView(invalidTimes: $constraintsViewModel.constraints.invalidTimes, preSelectedTimes: constraintsViewModel.preSelectedTimes)
                .tag(SelectedView.invalidTime)
            MidCheckView(constraintModel: constraintsViewModel.constraints)
                .tag(SelectedView.midCheck)
                .STPopup(isPresented: $midCheckPopup) {
                    MidCheckPopup(isPresented: $midCheckPopup, action: { selectedView = .majorCombination })
                }
            MajorCombSelectorView(viewModel: constraintsViewModel)
                .tag(SelectedView.majorCombination)
            FinalTimetableSelectorView(viewModel: constraintsViewModel, timetableIndex: $timetableIndex)
                .tag(SelectedView.finalTimetable)
                .STPopup(isPresented: $finishMakingPopup) {
                    FinishMakingTimetablePopup(isPresented: $finishMakingPopup, action: {
                        stackPath.removeAll()
                        stackPath.append(.timetableList)
                    })
                }
        }
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false //드래그제스처로 탭뷰 넘기는거 방지
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var tabViewNavigationButtons: some View {
        HStack(spacing: 20) {
            switch selectedView {
            case .creditPicker:
                TimetableAutoNextButton(text: "다음으로", action: {
                    selectedView = .essentialClasses
                })
            case .essentialClasses:
                TimetableAutoBackButton(text: "이전으로", action: {
                    selectedView = .creditPicker
                })
                TimetableAutoNextButton(text: "다음으로", action: {
                    selectedView = .invalidTime
                })
            case .invalidTime:
                TimetableAutoBackButton(text: "이전으로", action: {
                    selectedView = .essentialClasses
                })
                TimetableAutoNextButton(text: "다음으로", action: {
                    selectedView = .midCheck
                })
            case .midCheck:
                TimetableAutoBackButton(text: "이전으로", action: {
                    selectedView = .invalidTime
                })
                TimetableAutoNextButton(text: "시간표 생성하기", action: {
                    midCheckPopup = true
                })
            case .majorCombination:
                if constraintsViewModel.majorCombinations != nil {
                    VStack(spacing: 0) {
                        GeometryReader { geometry in
                            Button(action: {
                                Task {
                                    isProgressing = true
                                    await constraintsViewModel.fetchFinalTimetableList(isRaw: false)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.isProgressing = false
                                        selectedView = .finalTimetable
                                    }
                                }
                            }) {
                                Text("시간표 생성하기")
                                    .font(.sb16)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: 150, maxHeight: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(constraintsViewModel.selectedMajorCombs.isEmpty ? .gray : .buttonBlue)
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                        .frame(height: 45)
                        .disabled(constraintsViewModel.selectedMajorCombs.isEmpty)
                    }
                }
                else {
                    TimetableAutoBackButton(text: "이전으로", action: {
                        selectedView = .midCheck
                    })
                }
            case .finalTimetable:
                TimetableAutoBackButton(text: "전공조합 선택하기", action: {
                    selectedView = .majorCombination
                })
                TimetableAutoNextButton(text: "시간표 등록 끝내기", action: {
                    finishMakingPopup = true
                })
            }
        }
    }

    // 선택된 뷰의 인덱스를 반환하는 함수
    func selectedViewIndex() -> Int {
        return SelectedView.allCases.firstIndex(of: selectedView)!
    }
}

struct TimetableAutoBackButton: View {
    let text: String
    var action: () -> Void
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                action()
            }) {
                Text(text)
                    .font(.sb16)
                    .foregroundStyle(Color.buttonBlue)
                    .frame(maxWidth: 150, maxHeight: .infinity)
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
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(height: 45)
    }
}

struct TimetableAutoNextButton: View {
    let text: String
    var action: () -> Void
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                action()
            }) {
                Text(text)
                    .font(.sb16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 150, maxHeight: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.buttonBlue)
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(height: 45)
    }
}

#Preview {
    TimetableAutoView(stackPath: .constant([.timetableAuto]), constraintsViewModel: ConstraintsViewModel(container: .preview), lectureSearchViewModel: LectureSearchViewModel(container: .preview))
}
