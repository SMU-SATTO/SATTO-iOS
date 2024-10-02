//
//  MidCheckView.swift
//  SATTO
//
//  Created by yeongjoon on 4/11/24.
//

import SwiftUI

struct MidCheckView: View {
    @ObservedObject var viewModel: ConstraintsViewModel
    
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
                        content: "\(viewModel.credit)학점"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 전공 개수",
                        headerColor: Color.blackWhite200,
                        content: "\(viewModel.majorNum)개"
                    )
                    selectedOptionInfo(
                        header: "이번 학기에 들을 이러닝 개수",
                        headerColor: Color.blackWhite200,
                        content: "\(viewModel.eLearnNum)개"
                    )
                    selectedOptionInfo(
                        header: "필수로 들을 과목",
                        headerColor: Color.blackWhite200,
                        content: viewModel.selectedLectures.isEmpty
                        ? "선택된 과목이 없어요"
                        : viewModel.selectedLectures.map { $0.sbjName }.joined(separator: ", ")
                    )
                    selectedOptionInfo(
                        header: "제외된 시간대",
                        headerColor: Color(red: 0.87, green: 0.34, blue: 0.34),
                        content: viewModel.selectedBlocks.isEmpty
                        ? "선택된 불가능한 시간이 없어요"
                        : viewModel.sortedSelectedBlocks
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

#Preview {
    MidCheckView(viewModel: ConstraintsViewModel(container: .preview))
}
