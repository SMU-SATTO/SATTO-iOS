//
//  CreditPickerView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 학점 범위 선택
struct CreditPickerView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    var body: some View {
        VStack {
            SectionView(title: "학점", pickerRange: 6...22, selection: $selectedValues.credit)
            
            SectionView(title: "전공 개수", pickerRange: 0...(selectedValues.credit / 3), selection: $selectedValues.majorNum)
                .padding(.top, 20)
            
            SectionView(title: "E-러닝 개수", pickerRange: 0...2, selection: $selectedValues.ELearnNum)
                .padding(.top, 20)
        }
    }
    
    private struct SectionView: View {
        let title: String
        let pickerRange: ClosedRange<Int>
        @Binding var selection: Int
        
        var body: some View {
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    Text("이번 학기에 들을 ")
                    Text(title)
                        .foregroundStyle(Color.accentText)
                    Text(title == "학점" ? "을 선택해 주세요." : "를 선택해 주세요.")
                    Spacer()
                }
                .font(.sb16)
                .padding(.leading, 60)

                HStack(spacing: 10) {
                    Text(title)
                        .font(.sb16)
                        .foregroundStyle(Color.blackWhite400)
                    Spacer()
                    Picker(selection: $selection, label: Text("")) {
                        ForEach(pickerRange, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .tint(.blackWhite)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color.creditPickerBackground)
                            .padding(EdgeInsets(top: 5, leading: -5, bottom: 5, trailing: -5))
                    )
                    .padding(EdgeInsets(top: -5, leading: 5, bottom: -5, trailing: 5))
                    
                }
                .padding(.leading, 60)
                .padding(.trailing, 120)
            }
        }
    }
}

#Preview {
    CreditPickerView(selectedValues: SelectedValues())
        .preferredColorScheme(.light)
}
