//
//  CreditPickerView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 학점 범위 선택
struct CreditPickerView: View {
    //MARK: - 사용자 학년에 따라 start 학점 6 아니고 12로 바꿔야함 -> 12학점 미만 선택시 알림 띄우는 형식도 괜찮을듯
    @ObservedObject var selectedValues: SelectedValues
    
    var body: some View {
        VStack {
            Text("이번 학기에 들을 학점을 선택해 주세요.")
                .font(.sb16)

            HStack(spacing: 10) {
                Text("학점")
                    .frame(width: 100, alignment: .trailing)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 30)
                    Picker(selection: $selectedValues.credit, label: Text("")) {
                        ForEach(6...22, id: \.self) { credit in
                            Text("\(credit)").tag(credit)
                        }
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
                .frame(width: 100, height: 30)
            }
            .padding(.top, 10)
            
            Text("이번 학기에 들을 전공 개수를 선택해 주세요.")
                .font(.sb16)
                .padding(.top, 20)

            HStack(spacing: 10) {
                Text("전공 개수")
                    .frame(width: 100, alignment: .trailing)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 30)
                    Picker(selection: $selectedValues.majorNum, label: Text("")) {
                        ForEach(0...7, id: \.self) { credit in
                            Text("\(credit)").tag(credit)
                        }
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
                .frame(width: 100, height: 30)
            }
            .padding(.top, 10)
            
            Text("이번 학기에 들을 E-러닝 개수를 선택해 주세요")
                .font(.sb16)
                .padding(.top, 20)

            HStack(spacing: 10) {
                Text("E-러닝 개수")
                    .frame(width: 100, alignment: .trailing)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 30)
                    Picker(selection: $selectedValues.ELearnNum, label: Text("")) {
                        ForEach(0...2, id: \.self) { credit in
                            Text("\(credit)").tag(credit)
                        }
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
                .frame(width: 100, height: 30)
            }
            .padding(.top, 10)
        }
    }
}


#Preview {
    CreditPickerView(selectedValues: SelectedValues())
}
