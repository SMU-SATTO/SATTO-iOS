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
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isProgressing = false
    @State private var errorPopup = false
    @State private var isRawChecked = false
    @State private var currIndex: Int = 0
    
    @Binding var showingPopup: Bool
    @Binding var timetableIndex: Int
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if selectedValues.timetableList.isEmpty {
                    emptyTimetableView
                }
                else {
                    timetableTabView
                    CustomPageIndicator(currIndex: $currIndex, totalIndex: selectedValues.timetableList.count)
                }
            }
        }
        .onAppear {
            isRawChecked = false
        }
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
    }
    
    private var emptyTimetableView: some View {
        VStack {
            if isRawChecked {
                Text("해당 전공 조합의 남는 시간에 맞는 교양 과목이 없어요..\n불가능한 시간대와 같은 제약조건을 완화해보세요.")
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .multilineTextAlignment(.center)
            } else {
                Text("해당 전공 조합으로는 최적의 시간표가 존재하지 않아요..\n전체 시간표를 확인해보시겠어요?")
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .multilineTextAlignment(.center)
                
                Button(action: fetchAllTimetables) {
                    HStack {
                        Text("전체 시간표 확인하기")
                        Image(systemName: "arrow.clockwise")
                    }
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.menuCardBackground)
                            .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                    )
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
        }
    }
    
    private var timetableTabView: some View {
        LazyVStack {
            Text("\(selectedValues.timetableList.count)개의 시간표가 만들어졌어요!")
                .font(.sb14)
                .multilineTextAlignment(.center)
            Text("좌우로 스크롤하고 시간표를 클릭해 \n 원하는 시간표를 등록해요.")
                .font(.sb16)
                .multilineTextAlignment(.center)
            TabView(selection: $currIndex) {
                ForEach(selectedValues.timetableList.indices, id: \.self) { index in
                    TimetableView(timetableBaseArray: selectedValues.timetableList[index])
                        .onTapGesture {
                            timetableIndex = index
                            showingPopup.toggle()
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                currIndex = 0
                UIScrollView.appearance().isScrollEnabled = true //드래그제스처로 탭뷰 넘기는거 여기 TabView에서만 허용
            }
            .frame(height: 500)
        }
    }
    
    private func fetchAllTimetables() {
        isProgressing = true
        selectedValues.fetchFinalTimetableList(
            isRaw: true,
            GPA: selectedValues.credit,
            requiredLect: selectedValues.selectedSubjects,
            majorCount: selectedValues.majorNum,
            cyberCount: selectedValues.ELearnNum,
            impossibleTimeZone: selectedValues.selectedTimes,
            majorList: selectedValues.selectedMajorCombs) { result in
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isProgressing = false
                        isRawChecked = true
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isProgressing = false
                        errorPopup = true
                    }
                }
            }
    }
}

struct CustomPageIndicator: View {
    @Binding var currIndex: Int
    @State var totalIndex: Int
    
    var body: some View {
        VStack {
            pageIndicator
        }
    }
    
    private var pageIndicator: some View {
        GeometryReader { geometry in
            HStack(spacing: 8) { // 간격을 좁게 조정
                ForEach(pageIndicatorIndices(), id: \.self) { index in
                    Circle()
                        .fill(index == currIndex ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                        .scaleEffect(circleScaleEffect(index: index))
                        .animation(.easeInOut, value: currIndex)
                        .onTapGesture {
                            withAnimation {
                                currIndex = index
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .frame(height: 20)
    }
    
    private func circleScaleEffect(index: Int) -> CGFloat {
        let maxIndicators = 9
        let halfMax = maxIndicators / 2
        
        if index == currIndex {
            return 1.0
        } else if (currIndex > halfMax && currIndex < totalIndex - halfMax && index == currIndex - halfMax) || (currIndex > halfMax && currIndex < totalIndex - halfMax - 1 && index == currIndex + halfMax) {
            return 0.6
        } else if (currIndex == halfMax && index == currIndex + halfMax) || (currIndex == totalIndex - halfMax - 1 && index == currIndex - halfMax) {
            return 0.6
        } else {
            return 0.8
        }
    }

    private func pageIndicatorIndices() -> [Int] {
        let maxIndicators = 9
        let halfMax = maxIndicators / 2
        
        if totalIndex <= maxIndicators {
            return Array(0..<totalIndex)
        } else if currIndex <= halfMax {
            return Array(0..<maxIndicators)
        } else if currIndex >= totalIndex - halfMax - 1 {
            return Array((totalIndex - maxIndicators)..<totalIndex)
        } else {
            return Array((currIndex - halfMax)..<(currIndex + halfMax + 1))
        }
    }
}
