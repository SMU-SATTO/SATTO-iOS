//
//  MidCheckView.swift
//  SATTO
//
//  Created by yeongjoon on 4/11/24.
//

import SwiftUI

struct MidCheckView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 3) {
                Text("이렇게 시간표를 생성해드릴까요?")
                    .font(.sb16)
                Text("수정사항이 있다면 뒤로 가기를 눌러주세요.")
                    .font(.m12)
                    .foregroundStyle(.gray500)
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
            VStack(alignment: .leading, spacing: 10) {
                selectedOptionInfo(info: "선택한 학점", infoColor: .gray900, range: "19")
                selectedOptionInfo(info: "전공 개수", infoColor: .gray900, range: "3개")
                selectedOptionInfo(info: "이러닝 개수", infoColor: .gray900, range: "2개")
                selectedOptionInfo(info: "제외된 시간대", infoColor: .red, range: "월3, 화4, 금6")
            }
            .padding(.top, 20)
        }
    }
    @ViewBuilder
    func selectedOptionInfo(info: String, infoColor: Color, range: String) -> some View {
        VStack(alignment: .leading) {
            Text(info)
                .font(.sb16)
                .foregroundColor(infoColor)
            Text(range)
                .font(.m16)
                .foregroundColor(.gray500)
        }
    }
}

#Preview {
    MidCheckView()
}
