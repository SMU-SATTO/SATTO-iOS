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

    @Binding var stackPath: [Route]
    
    @StateObject var subjectViewModel = SubjectViewModel()
    @StateObject var majorCombViewModel = MajorCombViewModel()
    @StateObject var selectedValues = SelectedValues()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    
    @State private var selectedView: SelectedView = .creditPicker
    
    @State private var selectedSubviews = Set<Int>()
    @State private var alreadySelectedSubviews = Set<Int>()
    
    @State private var midCheckPopup = false
    @State var invalidPopup = false
    
    var body: some View {
        ZStack {
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
        .popup(isPresented: $invalidPopup, view: {
            invalidPopupView
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $midCheckPopup, view: {
            midCheckPopupView
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .backgroundColor(.black.opacity(0.5))
        })
    }
    
    private var backButton: some View {
        GeometryReader { geometry in
            Button(action: {
                navigateBack()
            }) {
                Text("이전으로")
                    .font(.sb18)
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
                    .font(.sb18)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 150, maxHeight: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.buttonBlue)
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(height: 45)
    }
    
    private var invalidPopupView: some View {
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
    
    private var midCheckPopupView: some View {
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
                            majorCombViewModel.fetchMajorCombinations(GPA: selectedValues.credit, requiredLect: selectedValues.selectedSubjects, majorCount: selectedValues.majorNum, cyberCount: selectedValues.ELearnNum, impossibleTimeZone: selectedValues.selectedTimes)
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
            selectedView = .finalTimetable
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
            return AnyView(EssentialClassesSelectorView(subjectViewModel: subjectViewModel, selectedValues: selectedValues, bottomSheetViewModel: bottomSheetViewModel))
        case .invalidTime:
            return AnyView(InvalidTimeSelectorView(selectedValues: selectedValues, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews, invalidPopup: $invalidPopup))
        case .midCheck:
            return AnyView(MidCheckView(selectedValues: selectedValues))
        case .majorCombination:
            return AnyView(MajorCombSelectorView(viewModel: majorCombViewModel))
        case .finalTimetable:
            return AnyView(FinalTimetableSelectorView())
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
