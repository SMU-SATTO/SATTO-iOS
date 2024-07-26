//
//  MajorCombSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

struct MajorCombSelectorView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var selectedValues: SelectedValues
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 0) {
                            Text("\(selectedValues.majorCombinations.count)개의 전공 조합")
                                .font(.sb16)
                                .foregroundStyle(Color.accentText)
                            Text("이 만들어졌어요!")
                                .font(.sb16)
                                .foregroundStyle(Color.blackWhite200)
                        }
                        
                        Text("원하는 전공 조합을 선택해\n최종 시간표를 만들어요.")
                            .font(.m12)
                            .foregroundStyle(Color.blackWhite200)
                    }
                }
                
                Circle()
                    .foregroundStyle(Color.iconBackground)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image("MajorSelect")
                            .resizable()
                            .frame(width: 150, height: 150)
                    )
                    .padding(.top, 20)
                    .padding(.bottom, 20)
            }
            ForEach(selectedValues.majorCombinations.indices, id: \.self) { index in
                majorRectangle(combination: selectedValues.majorCombinations[index])
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            //MARK: API
            selectedValues.fetchMajorCombinations(GPA: selectedValues.credit, requiredLect: selectedValues.selectedSubjects, majorCount: selectedValues.majorNum, cyberCount: selectedValues.ELearnNum, impossibleTimeZone: selectedValues.selectedTimes)
        }
    }
    
    @ViewBuilder
    private func majorRectangle(combination: MajorComb) -> some View {
        Button(action: {
            selectedValues.toggleSelection(combination)
        }) {
            VStack(spacing: 3) {
                ForEach(combination.combination.indices, id: \.self) { index in
                    Text(combination.combination[index].lectName)
                        .font(.m14)
                        .foregroundStyle(Color.blackWhite200)
                        .padding(.horizontal, 10)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(selectedValues.isSelected(combination) ? Color.subjectCardSelected : Color.subjectCardBackground)
                    .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedValues.isSelected(combination) ? Color.subjectCardBorder : Color.clear, lineWidth: 1)
                    )
                    .frame(width: 300)
                    .padding(.vertical, -10)
            )
            .frame(width: 300)
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    MajorCombSelectorView(selectedValues: SelectedValues())
        .preferredColorScheme(.dark)
}
