//
//  MajorCombinationSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/5/24.
//

import SwiftUI

//MARK: - 가능한 전공 조합 선택하는 페이지
struct MajorCombinationSelectorView: View {
    @State private var isButtonSelected = false
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("90개의 시간표가 만들어졌어요!")
                        .font(.sb16)
                        .foregroundColor(Color.gray800)
                    
                    Text("원하는 전공 조합을 선택해\n최종 시간표를 만들어요.")
                        .font(.m12)
                        .foregroundColor(Color.gray800)
                }
                Spacer()
            }
            .padding(.leading, 50)
            
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
            
            /// 가능한 전공 조합 경우의 수를 가져다 줘야함
            majorRectangle(lec: "dd", lecNum: 3)
            majorRectangle(lec: "dd", lecNum: 3)
            majorRectangle(lec: "dd", lecNum: 3)
        }
        
    }
    
    /// 전공 개수에 따라 과목 개수가 달라짐
    @ViewBuilder
    func majorRectangle(lec: String, lecNum: Int) -> some View {
        Button(action: {
            isButtonSelected.toggle()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .shadow(color: Color(red: 0.75, green: 0.75, blue: 0.75).opacity(0.25), radius: 5, x: 0, y: 0)
                .frame(width: 330, height: 28 * CGFloat(lecNum))
                .overlay(
                    ZStack {
                        VStack {
                            ForEach(0..<lecNum, id: \.self) { _ in
                                HStack {
                                    Text("subject")
                                    Text("time")
                                }
                            }
                        }
                        VStack {
                            HStack {
                                Spacer()
                                Text("30개")
                                    .font(.m12)
                                    .foregroundStyle(.red)
                                    .padding(.trailing, 10)
                            }
                            .padding(.top, 10)
                            Spacer()
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // 선택된 경우 테두리를 변경
                        .stroke(isButtonSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
    }
}

#Preview {
    MajorCombinationSelectorView()
}
