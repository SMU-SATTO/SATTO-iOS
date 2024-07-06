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
    
    @State private var isProgressing = false
    @State private var errorPopup = false
    @State private var isRawChecked = false
    
    @Binding var showingPopup: Bool
    @Binding var timetableIndex: Int

    var body: some View {
        ZStack {
            VStack {
                if selectedValues.timetableList.count == 0 {
                    if isRawChecked {
                        Text("해당 전공 조합의 남는 시간에 맞는 교양 과목이 없어요..\n불가능한 시간대와 같은 제약조건을 완화해보세요.")
                            .font(.sb16)
                            .foregroundStyle(.blackWhite)
                            .multilineTextAlignment(.center)
                    } 
                    else {
                        Text("해당 전공 조합으로는 최적의 시간표가 존재하지 않아요..\n전체 시간표를 확인해보시겠어요?")
                            .font(.sb16)
                            .foregroundStyle(.blackWhite)
                            .multilineTextAlignment(.center)
                        Button(action: {
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
                                            self.isProgressing = false
                                            self.isRawChecked = true
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self.isProgressing = false
                                            self.errorPopup = true
                                        }
                                    }
                                }
                        }) {
                            HStack {
                                Text("전체 시간표 확인하기")
                                Image(systemName: "arrow.clockwise")
                            }
                            .font(.sb16)
                            .foregroundStyle(.blackWhite)
                            .padding(.top)
                        }
                    }
                }
                else {
                    Text("\(selectedValues.timetableList.count)개의 시간표가 만들어졌어요!")
                        .font(.sb14)
                        .multilineTextAlignment(.center)
                    Text("좌우로 스크롤하고 시간표를 클릭해 \n 원하는 시간표를 등록해요.")
                        .font(.sb16)
                        .multilineTextAlignment(.center)
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
                    .frame(height: 500)
                }
            }
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
}

#Preview {
    FinalTimetableSelectorView(selectedValues: SelectedValues(), showingPopup: .constant(false), timetableIndex: .constant(1))
        .preferredColorScheme(.dark)
}
