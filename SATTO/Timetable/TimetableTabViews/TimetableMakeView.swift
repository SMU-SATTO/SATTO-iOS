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
    
    @StateObject var timeTableMainViewModel = TimetableMainViewModel()
    @State private var selectedView: SelectedView = .creditPicker
    let selectedValues = SelectedValues()
    
    @State private var midCheckPopup = false
    @State var invalidPopup = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    CustomPageControl(
                        totalIndex: SelectedView.allCases.count,
                        selectedIndex: selectedViewIndex()
                    )
                    .animation(.spring(), value: UUID())
                    .padding(.horizontal)
                }
                .padding(.top, 0)
                
                TabView(selection: $selectedView) {
                    ForEach(SelectedView.allCases, id: \.self) { view in
                        tabViewContent(for: view)
                            .tag(view)
                    }
                }
                .onAppear {
                    UIScrollView.appearance().isScrollEnabled = false
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 600)
                .padding(.top, 20)
                
                HStack(spacing: 20) {
                    //MARK: - 시간표 생성 이후에 이전으로 지우기
                    if selectedView != .creditPicker && selectedView != .majorCombination {
                        Button(action: {
                            navigateBack()
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .frame(width: 150, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 2)
                                        .stroke(.blue, lineWidth: 1.5)
                                        .overlay {
                                            Text("이전으로")
                                                .font(.sb18)
                                                .foregroundStyle(Color(red: 0.11, green: 0.33, blue: 1))
                                        }
                                )
                        }
                    }
                    if selectedView != .finalTimetable {
                        Button(action: {
                            if selectedView == .midCheck {
                                midCheckPopup = true
                            }
                            else {
                                navigateForward()
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.11, green: 0.33, blue: 1))
                                .frame(width: 150, height: 50)
                                .overlay {
                                    if selectedView == .midCheck {
                                        Text("시간표 생성하기")
                                            .font(.sb18)
                                            .foregroundStyle(.white)
                                    }
                                    else {
                                        Text("다음으로")
                                            .font(.sb18)
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: UUID())
        }
        .popup(isPresented: $invalidPopup, view: {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
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
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue)
                                .frame(width: 250, height: 40)
                                .overlay(
                                    Text("확인했어요")
                                        .font(.sb14)
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                )
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        })
        .popup(isPresented: $midCheckPopup, view: {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
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
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue)
                                .frame(width: 250, height: 40)
                                .overlay(
                                    Button(action: {
                                        navigateForward()
                                        midCheckPopup = false
                                    }) {
                                        Text("시간표 생성하러 가기")
                                            .font(.sb14)
                                            .foregroundStyle(.white)
                                    }
                                )
                            Button(action: {
                                midCheckPopup = false
                            }) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .frame(width: 250, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 2)
                                            .stroke(.blue, lineWidth: 1.5)
                                            .overlay {
                                                Text("조금 더 고민해보기")
                                                    .font(.sb14)
                                                    .foregroundStyle(Color(red: 0.11, green: 0.33, blue: 1))
                                            }
                                    )
                            }
                        }
                    }
                )
        }, customize: {
            $0
                .position(.center)
                .appearFrom(.bottom)
                .backgroundColor(.black.opacity(0.5))
        })
    }

    // 이전 뷰로 이동하는 함수
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
            return AnyView(CreditPickerView().environmentObject(selectedValues))
        case .essentialClasses:
            return AnyView(EssentialClassesSelectorView())
        case .invalidTime:
            return AnyView(InvalidTimeSelectorView(invalidPopup: $invalidPopup))
        case .midCheck:
            return AnyView(MidCheckView().environmentObject(selectedValues))
        case .majorCombination:
            return AnyView(MajorCombinationSelectorView())
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
                        .fill(Color(red: 0.06, green: 0.51, blue: 0.79))
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
                                .fill(Color(red: 0.06, green: 0.81, blue: 0.79))
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
}
