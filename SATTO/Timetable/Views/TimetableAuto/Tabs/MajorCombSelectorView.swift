//
//  MajorCombSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

struct MajorCombSelectorView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ConstraintsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.majorCombinations.count == 0 {
                    VStack(spacing: 10) {
                        Text("설정하신 조건으로는 시간표를 생성할 수 없었어요.")
                        Text("입력된 조건 중 충돌하는 조건이 있었거나,")
                        Text("과목을 배치할 수 있는 시간대가 부족한 것 같아요.")
                        Text("조건을 일부 수정해 보시거나, 불가능한 시간대를 줄여주세요.")
                        Text("도움이 필요하면 개발자에게 문의해 주세요!")
                    }
                    .font(.sb16)
                    .foregroundStyle(Color.blackWhite200)
                    .multilineTextAlignment(.center)
                    .padding()
                }
                else {
                    HStack {
                        VStack(spacing: 5) {
                            HStack(spacing: 0) {
                                Text("\(viewModel.majorCombinations.count)개의 전공 조합")
                                    .font(.sb16)
                                    .foregroundStyle(Color.accentText)
                                Text("이 만들어졌어요!")
                                    .font(.sb16)
                                    .foregroundStyle(Color.blackWhite200)
                            }
                            
                            Text("원하는 전공 조합을 선택해 최종 시간표를 만들어요.")
                                .font(.m12)
                                .foregroundStyle(Color.blackWhite200)
                                .multilineTextAlignment(.center)
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
                    HStack {
                        Image(systemName: "arrow.down")
                        Text("전공 조합을 클릭해보세요!")
                            .foregroundStyle(.blackWhite200)
                        Image(systemName: "arrow.down")
                    }
                    .font(.sb14)
                }
                ForEach(viewModel.majorCombinations.indices, id: \.self) { index in
                    majorRectangle(combination: viewModel.majorCombinations[index])
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            await viewModel.fetchMajorCombinations()
        }
    }
    
    @ViewBuilder
    private func majorRectangle(combination: MajorComb) -> some View {
        Button(action: {
            viewModel.toggleSelection(combination)
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
                    .foregroundStyle(viewModel.isSelected(combination) ? Color.subjectCardSelected : Color.subjectCardBackground)
                    .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.isSelected(combination) ? Color.subjectCardBorder : Color.clear, lineWidth: 1)
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
    MajorCombSelectorView(viewModel: ConstraintsViewModel(container: .preview))
        .preferredColorScheme(.dark)
}
