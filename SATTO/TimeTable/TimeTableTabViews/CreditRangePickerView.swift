//
//  CreditRangePickerView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 학점 범위 선택
struct CreditRangePickerView: View {
    //MARK: - 사용자 학년에 따라 start 학점 6 아니고 12로 바꿔야함 -> 12학점 미만 선택시 알림 띄우는 형식도 괜찮을듯
    @State var minimumCredit = 0
    @State var maximumCredit = 22
    @State private var maximumCreditsRange: ClosedRange<Int> = 0...22
    var body: some View {
        VStack {
            Text("이번 학기에 듣고 싶은\n학점 범위를 선택해 주세요.")
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .lineSpacing(5)
                .frame(width: 320, alignment: .topLeading)
            Text("ex) 17학점~19학점 사이")
                .font(Font.custom("Pretendard", size: 12))
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                .frame(width: 320, alignment: .topLeading)
                .padding(.top, 5)
            
            Text("최소 학점을 선택하세요")
            // 최소 학점 선택 Picker
            Picker(selection: $minimumCredit, label: Text("최소 학점")) {
                ForEach(0..<maximumCreditsRange.upperBound + 1, id: \.self) { credit in
                    Text("\(credit)").tag(credit)
                }
            }
            .padding(.horizontal)
            
            Text("최대 학점을 선택하세요")
            // 최대 학점 선택 Picker
            Picker(selection: $maximumCredit, label: Text("최대 학점")) {
                ForEach(minimumCredit...22, id: \.self) { credit in
                    Text("\(credit)").tag(credit)
                }
            }
            .padding(.horizontal)
            .onChange(of: minimumCredit) { newValue in
                maximumCreditsRange = newValue...22
            }
        }
    }
}


#Preview {
    CreditRangePickerView()
}
