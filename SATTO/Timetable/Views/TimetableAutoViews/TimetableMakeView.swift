//
//  TimetableMakeView.swift
//  SATTO
//
//  Created by 김영준 on 2/29/24.
//

import SwiftUI

struct TimetableMakeView: View {
    enum SelectedView: CaseIterable {
        case creditPicker, essentialClasses, invalidTime, midCheck, majorCombination, finalTimetable
    }

    @Binding var stackPath: [TimetableRoute]
    
    @StateObject var selectedValues = SelectedValues()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    
    @State private var selectedView: SelectedView = .creditPicker
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var midCheckPopup = false
    @State private var invalidPopup = false
    @State private var finalSelectPopup = false
    @State private var progressPopup = false
    @State private var errorPopup = false
    
    @State private var timetableIndex = 0
    
    @State private var isButtonDisabled = false
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            VStack {
                GeometryReader { geometry in
                    VStack {
                        CustomPageControl(
                            totalIndex: SelectedView.allCases.count,
                            selectedIndex: selectedViewIndex()
                        )
                        .animation(.spring(), value: UUID())
                        .padding(.horizontal)
                        
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
                        .padding(.top, 20)
                    }
                    .padding(.top, 0)
                }
                HStack(spacing: 20) {
                    if selectedView != .creditPicker && selectedView != .majorCombination {
                        backButton
                    }
                    if selectedView != .finalTimetable {
                        nextButton
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
            }
            .animation(.easeInOut, value: UUID())
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        stackPath.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.blackWhite)
                    }
                    Text("시간표 생성하기")
                        .font(.b18)
                        .foregroundStyle(Color.blackWhite200)
                }
            }
        }
        .popup(isPresented: $invalidPopup, view: {
            InvalidPopupView(invalidPopup: $invalidPopup)
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $midCheckPopup, view: {
            MidCheckPopupView(midCheckPopup: $midCheckPopup, navigateForward: navigateForward, selectedValues: selectedValues)
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
            FinalSelectPopupView(selectedValues: selectedValues, finalSelectPopup: $finalSelectPopup, timetableIndex: $timetableIndex)
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .dragToDismiss(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $progressPopup, view: {
            VStack {
                TimetableProgressView()
                    .padding(.top, 50)
                Button(action: {
                    progressPopup = false
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.buttonBlue)
                        .frame(width: 150, height: 50)
                        .overlay(
                            Text("취소하기")
                                .foregroundStyle(.white)
                                .font(.sb16))
                })
                .padding(.top, 50)
            }
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
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 300)
                    .overlay(
                        Text("시간표 생성에 실패했어요. 전공 조합을 다시 선택해보거나 개발자에게 문의해주세요!")
                            .font(.sb14)
                            .foregroundStyle(.black)
                    )
            }
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.9))
                .autohideIn(3)
        })
    }
    
    private var backButton: some View {
        GeometryReader { geometry in
            Button(action: {
                navigateBack()
            }) {
                Text("이전으로")
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
    
    private var nextButton: some View {
        GeometryReader { geometry in
            Button(action: {
                if selectedView == .midCheck {
                    midCheckPopup = true
                } else {
                    navigateForward()
                }
            }) {
                Text(selectedView == .midCheck ? "시간표 생성하기" : "다음으로")
                    .font(.sb16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 150, maxHeight: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(isButtonDisabled ? Color.gray : Color.buttonBlue)
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .disabled(isButtonDisabled)
        }
        .frame(height: 45)
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
        default:
            break
        }
    }

    // 다음 뷰로 이동하는 함수
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
            progressPopup = true
            isButtonDisabled = true
            selectedValues.fetchFinalTimetableList(GPA: selectedValues.credit, requiredLect: selectedValues.selectedSubjects, majorCount: selectedValues.majorNum, cyberCount: selectedValues.ELearnNum, impossibleTimeZone: selectedValues.selectedTimes, majorList: selectedValues.selectedMajorCombs) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.progressPopup = false
                            selectedView = .finalTimetable
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.progressPopup = false
                            self.errorPopup = true
                            selectedView = .finalTimetable
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.isButtonDisabled = false
                    }
                }
            }
        default:
            break
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
        }
    }

    // 다음으로 버튼의 텍스트를 반환하는 함수
    func nextButtonText() -> String {
        switch selectedView {
        case .midCheck:
            return "확인하기"
        default:
            return "다음으로"
        }
    }
}

struct CustomPageControl: View {
    let totalIndex: Int
    let selectedIndex: Int
    
    @Namespace private var animation
    
    let rectangleHeight: CGFloat = 7
    let rectangleRadius: CGFloat = 5
    
    var body: some View {
        HStack {
            //MARK: - 개수 수정 필요
            ForEach(0..<totalIndex, id: \.self) { index in
                if selectedIndex > index {
                    // 지나온 페이지
                    Rectangle()
                        .foregroundStyle(Color.pagecontrolPrevious)
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                } else if selectedIndex == index {
                    // 선택된 페이지
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                        .overlay {
                            Rectangle()
                                .foregroundStyle(Color.pagecontrolCurrent)
                                .frame(height: rectangleHeight)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: rectangleRadius)
                                )
                                .matchedGeometryEffect(id: "IndicatorAnimationId", in: animation)
                        }
                } else {
                    // 나머지 페이지
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: rectangleRadius))
                }
                
            }
        }
    }
}

#Preview {
    TimetableMakeView(stackPath: .constant([.timetableMake]))
        .preferredColorScheme(.dark)
}
