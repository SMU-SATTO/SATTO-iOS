//
//  MidCheckView.swift
//  SATTO
//
//  Created by yeongjoon on 4/11/24.
//

import SwiftUI

struct MidCheckView: View {
    @ObservedObject var selectedValues: SelectedValues
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("이렇게 시간표를 생성해드릴까요?")
                        .font(.sb16)
                    Text("시간표를 생성한 후에는 선택한 설정을 수정할 수 없어요!")
                        .font(.m12)
                        .foregroundStyle(.gray500)
                }
                .padding(.leading, 50)
                Spacer()
            }
            Circle()
                .foregroundStyle(Color(red: 0.8, green: 0.85, blue: 0.96))
                .frame(width: 200, height: 200)
                .overlay(
                    Image("MidCheck")
                        .resizable()
                        .frame(width: 150, height: 150)
                )
                .padding(.top, 20)
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    selectedOptionInfo(
                        header: "선택한 학점",
                        headerColor: .gray900,
                        content: "\(selectedValues.credit)학점"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 전공 개수",
                        headerColor: .gray900,
                        content: "\(selectedValues.majorNum)개"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 이러닝 개수",
                        headerColor: .gray900,
                        content: "\(selectedValues.ELearnNum)개"
                    )
                    selectedOptionInfo(
                        header: "필수로 들을 과목",
                        headerColor: .gray900,
                        content: selectedValues.selectedSubjects.isEmpty
                        ? "선택된 과목이 없어요"
                        : selectedValues.selectedSubjects.map { $0.sbjName }.joined(separator: ", ")
                    )
                    //MARK: - String값 model에 업데이트 필요
                    selectedOptionInfo(
                        header: "제외된 시간대",
                        headerColor: .red,
                        content: selectedValues.invalidTimes.isEmpty
                            ? "선택된 불가능한 시간이 없어요"
                            : selectedValues.invalidTimes
                                .split(separator: " ")
                                .map { String($0) }
                                .joined(separator: ", ")
                    )

                }
                .padding(.leading, 50)
                Spacer()
            }
            .padding(.top, 20)
        }
    }
    @ViewBuilder
    func selectedOptionInfo(header: String, headerColor: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(header)
                .font(.sb16)
                .foregroundColor(headerColor)
            Text(content)
                .font(.m16)
                .foregroundColor(.gray500)
        }
    }
}

#Preview {
    MidCheckView(selectedValues: SelectedValues())
}
