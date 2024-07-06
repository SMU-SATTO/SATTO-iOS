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
}

#Preview {
    FinalTimetableSelectorView(selectedValues: SelectedValues(), showingPopup: .constant(false), timetableIndex: .constant(1))
        .preferredColorScheme(.dark)
}
