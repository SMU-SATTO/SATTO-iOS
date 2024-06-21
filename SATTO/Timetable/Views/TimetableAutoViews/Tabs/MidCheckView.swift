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
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("이렇게 시간표를 생성해드릴까요?")
                        .font(.sb16)
                    Text("시간표를 생성한 후에는 선택한 설정을 수정할 수 없어요!")
                        .font(.m12)
                        .foregroundStyle(Color.blackWhite400)
                }
                .padding(.leading, 50)
                Spacer()
            }
            Circle()
                .foregroundStyle(Color.iconBackground)
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
                        headerColor: Color.blackWhite200,
                        content: "\(selectedValues.credit)학점"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 전공 개수",
                        headerColor: Color.blackWhite200,
                        content: "\(selectedValues.majorNum)개"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 이러닝 개수",
                        headerColor: Color.blackWhite200,
                        content: "\(selectedValues.ELearnNum)개"
                    )
                    selectedOptionInfo(
                        header: "필수로 들을 과목",
                        headerColor: Color.blackWhite200,
                        content: selectedValues.selectedSubjects.isEmpty
                        ? "선택된 과목이 없어요"
                        : selectedValues.selectedSubjects.map { $0.sbjName }.joined(separator: ", ")
                    )
                    //MARK: - String값 model에 업데이트 필요
                    selectedOptionInfo(
                        header: "제외된 시간대",
                        headerColor: Color(red: 0.87, green: 0.34, blue: 0.34),
                        content: selectedValues.selectedTimes.isEmpty
                            ? "선택된 불가능한 시간이 없어요"
                            : selectedValues.selectedTimes
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
                .foregroundStyle(headerColor)
            Text(content)
                .font(.m16)
                .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
        }
    }
}

struct MidCheckPopupView: View {
    @Binding var midCheckPopup: Bool
    let navigateForward: () -> Void
    let selectedValues: SelectedValues
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.popupBackground)
            .frame(width: 300, height: 360)
            .overlay(
                VStack(spacing: 30) {
                    Image(systemName: "exclamationmark.warninglight")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("시간표를 생성하면\n현재 설정은 수정할 수 없어요!!")
                        .font(.sb16)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                    VStack {
                        Button(action: {
                            navigateForward()
                            midCheckPopup = false
                            selectedValues.fetchMajorCombinations(GPA: selectedValues.credit, requiredLect: selectedValues.selectedSubjects, majorCount: selectedValues.majorNum, cyberCount: selectedValues.ELearnNum, impossibleTimeZone: selectedValues.selectedTimes)
                        }) {
                            Text("시간표 생성하러 가기")
                                .font(.sb14)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.buttonBlue)
                        )
                        .frame(height: 40)
                        Button(action: {
                            midCheckPopup = false
                        }) {
                            Text("조금 더 고민해보기")
                                .font(.sb14)
                                .foregroundStyle(Color.buttonBlue)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 2)
                                        .stroke(Color.buttonBlue, lineWidth: 1.5)
                                )
                        )
                        .frame(height: 40)
                    }
                    .padding(.horizontal, 15)
                }
            )
    }
}

#Preview {
    MidCheckView(selectedValues: SelectedValues())
        .preferredColorScheme(.dark)
}
