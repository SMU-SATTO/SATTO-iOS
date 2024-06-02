//
//  MajorCombinationSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 가능한 전공 조합 선택하는 페이지
struct MajorCombinationSelectorView: View {
    /// 위로 올려야함 stateobject
    @StateObject private var selectedMajorCombination = SelectedMajorCombination()
    
    @State private var majorCombinations: [MajorCombinationModel] = [
        MajorCombinationModel(lec: ["과목명1", "과목명2", "과목명3"], combCount: 30),
        MajorCombinationModel(lec: ["과목명2", "과목명4", "과목명3"], combCount: 10),
        MajorCombinationModel(lec: ["과목명1", "과목명5", "과목명7"], combCount: 20)
    ]
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("\(majorCombinations.count)개의 전공 조합, \(majorCombinations.reduce(0) { $0 + $1.combCount })개의 시간표")
                            .font(.sb16)
                            .foregroundColor(Color("blue_6"))
                        Text("가 만들어졌어요!")
                            .font(.sb16)
                            .foregroundColor(Color.gray800)
                    }
                    
                    Text("원하는 전공 조합을 선택해\n최종 시간표를 만들어요.")
                        .font(.m12)
                        .foregroundColor(Color.gray800)
                }
            }
            
            Circle()
                .foregroundStyle(Color(red: 0.8, green: 0.85, blue: 0.96))
                .frame(width: 200, height: 200)
                .overlay(
                    Image("MajorSelect")
                        .resizable()
                        .frame(width: 150, height: 150)
                )
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            ForEach(majorCombinations.indices, id: \.self) { index in
                majorRectangle(combination: majorCombinations[index])
            }
            
            VStack {
                Text("선택된 전공 조합 출력:")
                    .font(.m14)
                    .foregroundColor(Color.gray800)
                
                ForEach(selectedMajorCombination.selectedMajorCombs, id: \.self) { combination in
                    HStack(spacing: 0) {
                        ForEach(combination, id: \.self) { item in
                            Text(item)
                                .font(.m14)
                                .foregroundColor(Color("blue_6"))
                            if item != combination.last {
                                Text(", ")
                                    .font(.m14)
                                    .foregroundColor(Color("blue_6"))
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private func majorRectangle(combination: MajorCombinationModel) -> some View {
        Button(action: {
            selectedMajorCombination.toggleSelection(combination.lec)
        }) {
            ZStack {
                    VStack(spacing: 3) {
                        ForEach(combination.lec, id: \.self) { course in
                            Text(course)
                                .font(.m14)
                                .foregroundStyle(.black)
                                .padding(.leading, 20)
                        }
                }
                VStack {
                    HStack {
                        Spacer()
                        Text("\(combination.combCount)개")
                            .font(.r14)
                            .foregroundStyle(.red)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .shadow(color: Color(red: 0.75, green: 0.75, blue: 0.75).opacity(0.75), radius: 5, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedMajorCombination.isSelected(combination.lec) ? Color("blue_6") : Color.clear, lineWidth: 1)
                    )
                    .padding(.vertical, -10)
            )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
    }
}

#Preview {
    MajorCombinationSelectorView()
}
