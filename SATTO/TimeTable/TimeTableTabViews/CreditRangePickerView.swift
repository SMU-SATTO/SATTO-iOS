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
            Text("이번 학기에 들을 학점을 선택해 주세요.")
                .font(.sb16)

            HStack(spacing: 10) {
                Text("최소 학점")
                // 최소 학점 선택 Picker
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 30)
                    Picker(selection: $minimumCredit, label: Text("최소 학점")) {
                        ForEach(0..<maximumCreditsRange.upperBound + 1, id: \.self) { credit in
                            Text("\(credit)").tag(credit)
                        }
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
                .frame(width: 100, height: 30)
            }
            .padding(.top, 50)
            HStack(spacing: 10) {
                Text("최대 학점")
                // 최대 학점 선택 Picker
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 30)
                    
                    Picker(selection: $maximumCredit, label: Text("최대 학점")) {
                        ForEach(minimumCredit...22, id: \.self) { credit in
                            Text("\(credit)").tag(credit)
                        }
                    }
                    .tint(.black)
                    .padding(.horizontal)
                    .onChange(of: minimumCredit) { newValue in
                        maximumCreditsRange = newValue...22
                    }
                }
                .frame(width: 100, height: 30)
            }
            .padding(.top, 10)
        }
    }
}


#Preview {
    CreditRangePickerView()
}
