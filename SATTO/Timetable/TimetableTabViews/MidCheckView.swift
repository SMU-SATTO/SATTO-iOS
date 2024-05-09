//
//  MidCheckView.swift
//  SATTO
//
//  Created by yeongjoon on 4/11/24.
//

import SwiftUI

struct MidCheckView: View {
    @EnvironmentObject var selectedValues: SelectedValues
    
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
                    selectedOptionInfo(info: "선택한 학점", infoColor: .gray900, range: "\(selectedValues.minimumCredit)학점")
                    selectedOptionInfo(info: "전공 개수", infoColor: .gray900, range: "\(selectedValues.majorNum)개")
                    selectedOptionInfo(info: "이러닝 개수", infoColor: .gray900, range: "\(selectedValues.ELearnNum)개")
                    //                selectedOptionInfo(info: "제외된 시간대", infoColor: .red, range: "월3, 화4, 금6")
                }
                .padding(.leading, 50)
                Spacer()
            }
            .padding(.top, 20)
        }
    }
    @ViewBuilder
    func selectedOptionInfo(info: String, infoColor: Color, range: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(info)
                .font(.sb16)
                .foregroundColor(infoColor)
            Text(range)
                .font(.m16)
                .foregroundColor(.gray500)
        }
    }
}

struct MidCheckView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedValues = SelectedValues() // 프리뷰에서 사용할 환경 객체 생성
        MidCheckView()
            .environmentObject(selectedValues) // 생성된 환경 객체를 뷰에 제공
    }
}
