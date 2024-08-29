//
//  TimetableMakeView.swift
//  SATTO
//
//  Created by 김영준 on 2/29/24.
//

import SwiftUI

struct TimetableMakeView: View {
    enum SelectedView: CaseIterable {
        case creditPicker, essentialClasses, invalidTime, midCheck, majorCombination, finalTimetable, completionTimetable
    }

    @Binding var stackPath: [TimetableRoute]
    
    @StateObject var selectedValues = SelectedValues()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    
    @State private var selectedView: SelectedView = .creditPicker
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var isProgressing = false
    
    @State private var midCheckPopup = false
    @State private var invalidPopup = false
    @State private var finalSelectPopup = false
    @State private var errorPopup = false
    @State private var completionPopup = false
    @State private var showingAlert = false
    
    @State private var isRegisterSuccess = false
    
    @State private var timetableIndex = 0
    @State private var registeredTimetableList: Set<Int> = []
    
    @State private var isButtonDisabled = false
    
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
        .alert("지금 뒤로 가면 진행상항이 사라져요!", isPresented: $showingAlert) {
            Button("취소", role: .cancel, action: {})
            Button("확인") {
                stackPath.removeLast()
            }
        }
        .popup(isPresented: $invalidPopup, view: {
            InvalidPopup(invalidPopup: $invalidPopup)
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $midCheckPopup, view: {
            MidCheckPopup(midCheckPopup: $midCheckPopup, navigateForward: navigateForward, selectedValues: selectedValues)
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .dragToDismiss(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $finalSelectPopup, view: {
            FinalSelectPopup(selectedValues: selectedValues, finalSelectPopup: $finalSelectPopup, completionPopup: $completionPopup, isRegisterSuccess: $isRegisterSuccess, timetableIndex: $timetableIndex, registeredTimetableList: $registeredTimetableList)
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .dragToDismiss(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $isProgressing, view: {
            TimetableProgressView()
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.9))
                .dragToDismiss(false)
        })
        .popup(isPresented: $errorPopup, view: {
            ErrorPopup()
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.9))
                .autohideIn(3)
        })
        .popup(isPresented: $completionPopup) {
            TimetableSelectCompletionPopup(completionPupop: $completionPopup, isRegisterSuccess: $isRegisterSuccess)
        } customize: {
            $0.type(.floater())
                .position(.bottom)
                .appearFrom(.bottom)
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .dragToDismiss(false)
                .backgroundColor(.black.opacity(0.5))
                .autohideIn(3)
        }
    }
    
    private var customToolBar: some View {
        HStack {
            Button(action: {
                showingAlert = true
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
            CustomPageControl(totalIndex: SelectedView.allCases.count, selectedIndex: selectedViewIndex())
                .animation(.spring(), value: UUID())
                .padding(.horizontal)
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedView) {
            ForEach(SelectedView.allCases, id: \.self) { view in
                tabViewContent(for: view)
                    .tag(view)
            }
        }
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false //드래그제스처로 탭뷰 넘기는거 방지
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var tabViewNavigationButtons: some View {
        HStack(spacing: 20) {
            //majorCombination 생성에 실패하면 뒤로가기 가능
            if selectedView != .creditPicker && (selectedView != .majorCombination || selectedValues.majorCombinations.count == 0) {
                backButton
            }
            if selectedView == .majorCombination {
                if selectedValues.majorCombinations.count > 0 {
                    VStack(spacing: 0) {
                        nextButton
                        Text("시간표 생성은 5초에 한 번씩 가능해요.")
                            .font(.m12)
                            .foregroundStyle(.blackWhite200)
                            .padding(.top, 5)
                    }
                }
            }
            else {
                nextButton
            }
        }
    }
    
    private var backButton: some View {
        GeometryReader { geometry in
            Button(action: {
                navigateBack()
            }) {
                Text(backButtonText())
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
    
    func backButtonText() -> String {
        switch selectedView {
        case .finalTimetable:
            return "전공조합 선택하기"
        case .completionTimetable:
            return "시간표 더 고르기"
        default:
            return "이전으로"
        }
    }
    
    private var nextButton: some View {
        GeometryReader { geometry in
            Button(action: {
                if selectedView == .midCheck {
                    midCheckPopup = true
                } else {
                    navigateForward()
                }
            }) {
                Text(nextButtonText())
                    .font(.sb16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 150, maxHeight: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(isButtonDisabled || selectedView == .majorCombination && selectedValues.selectedMajorCombs.isEmpty ? Color.gray : Color.buttonBlue)
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .disabled(isButtonDisabled)
            .disabled(selectedView == .majorCombination && selectedValues.selectedMajorCombs.isEmpty)
        }
        .frame(height: 45)
    }
    
    // 다음으로 버튼의 텍스트를 반환하는 함수
    func nextButtonText() -> String {
        switch selectedView {
        case .midCheck:
            return "시간표 생성하기"
        case .majorCombination:
            return "시간표 생성하기"
        case .finalTimetable:
            return "시간표 등록 끝내기"
        case .completionTimetable:
            return "시간표 목록 보기"
        default:
            return "다음으로"
        }
    }
    
    func navigateBack() {
        switch selectedView {
        case .essentialClasses:
            selectedView = .creditPicker
        case .invalidTime:
            selectedView = .essentialClasses
        case .midCheck:
            selectedView = .invalidTime
        case .majorCombination:
            selectedView = .midCheck
        case .finalTimetable:
            selectedView = .majorCombination
        case .completionTimetable:
            selectedView = .finalTimetable
        default:
            break
        }
    }

    func navigateForward() {
        switch selectedView {
        case .creditPicker:
            selectedView = .essentialClasses
        case .essentialClasses:
            selectedView = .invalidTime
        case .invalidTime:
            selectedView = .midCheck
        case .midCheck:
            selectedView = .majorCombination
        case .majorCombination:
            isProgressing = true
            isButtonDisabled = true
            selectedValues.fetchFinalTimetableList(
                isRaw: false,
                GPA: selectedValues.credit,
                requiredLect: selectedValues.selectedSubjects,
                majorCount: selectedValues.majorNum,
                cyberCount: selectedValues.ELearnNum,
                impossibleTimeZone: selectedValues.selectedTimes,
                majorList: selectedValues.selectedMajorCombs
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isProgressing = false
                            selectedView = .finalTimetable
                        }
                    case .failure:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isProgressing = false
                            self.errorPopup = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.isButtonDisabled = false
                    }
                }
            }
        case .finalTimetable:
            selectedView = .completionTimetable
        case .completionTimetable:
            stackPath.removeAll()
            stackPath.append(.timetableList)
        }
    }

    // 선택된 뷰의 인덱스를 반환하는 함수
    func selectedViewIndex() -> Int {
        return SelectedView.allCases.firstIndex(of: selectedView)!
    }

    // 뷰에 따라 해당하는 내용을 반환하는 함수
    func tabViewContent(for view: SelectedView) -> AnyView {
        switch view {
        case .creditPicker:
            return AnyView(CreditPickerView(selectedValues: selectedValues))
        case .essentialClasses:
            return AnyView(EssentialClassesSelectorView(selectedValues: selectedValues, bottomSheetViewModel: bottomSheetViewModel))
        case .invalidTime:
            return AnyView(InvalidTimeSelectorView(selectedValues: selectedValues, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews, invalidPopup: $invalidPopup))
        case .midCheck:
            return AnyView(MidCheckView(selectedValues: selectedValues))
        case .majorCombination:
            return AnyView(MajorCombSelectorView(selectedValues: selectedValues))
        case .finalTimetable:
            return AnyView(FinalTimetableSelectorView(selectedValues: selectedValues, showingPopup: $finalSelectPopup, timetableIndex: $timetableIndex))
        case .completionTimetable:
            return AnyView(TimetableCompletionView(stackPath: $stackPath))
        }
    }
}

#Preview {
    TimetableMakeView(stackPath: .constant([.timetableMake]))
        .preferredColorScheme(.light)
}
