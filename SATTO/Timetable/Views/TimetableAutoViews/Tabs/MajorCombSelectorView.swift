//
//  MajorCombSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

struct MajorCombSelectorView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: SelectedValues
    //TODO: 위로 올려야함 stateobject
    @StateObject private var selectedValues = SelectedValues()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 0) {
                            Text("\(viewModel.majorCombinations.count)개의 전공 조합")
                                .font(.sb16)
                                .foregroundColor(Color.accentText)
                            Text("이 만들어졌어요!")
                                .font(.sb16)
                                .foregroundColor(Color.blackWhite200)
                        }
                        
                        Text("원하는 전공 조합을 선택해\n최종 시간표를 만들어요.")
                            .font(.m12)
                            .foregroundColor(Color.blackWhite200)
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
            ForEach(viewModel.majorCombinations.indices, id: \.self) { outerIndex in
                ForEach(viewModel.majorCombinations[outerIndex].indices, id: \.self) { innerIndex in
                    majorRectangle(combination: viewModel.majorCombinations[outerIndex][innerIndex])
                }
            }
            
            VStack {
                Text("선택된 전공 조합 출력:")
                    .font(.m14)
                    .foregroundColor(Color.blackWhite200)
                
                ForEach(selectedValues.selectedMajorCombs, id: \.self) { combination in
                    HStack(spacing: 0) {
                        ForEach(combination, id: \.self) { item in
                            Text(item)
                                .font(.m14)
                                .foregroundColor(Color.blackWhite200)
                            if item != combination.last {
                                Text(", ")
                                    .font(.m14)
                                    .foregroundColor(Color.blackWhite200)
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private func majorRectangle(combination: MajorCombModel) -> some View {
        Button(action: {
            selectedValues.toggleSelection(combination.lec)
        }) {
            VStack(spacing: 3) {
                ForEach(combination.lec, id: \.self) { course in
                    Text(course)
                        .font(.m14)
                        .foregroundStyle(Color.blackWhite200)
                        .padding(.leading, 20)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(selectedValues.isSelected(combination.lec) ? Color.subjectCardSelected : Color.subjectCardBackground)
                    .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedValues.isSelected(combination.lec) ? Color.subjectCardBorder : Color.clear, lineWidth: 1)
                    )
                    .padding(.vertical, -10)
            )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
    }
}

#Preview {
    MajorCombSelectorView(viewModel: SelectedValues())
        .preferredColorScheme(.dark)
}
