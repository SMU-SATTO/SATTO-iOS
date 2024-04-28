//
//  DepartmentSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct DepartmentSheetView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.clear)
                .frame(width: 336, height: 126)
                .background(Color(red: 0.96, green: 0.98, blue: 1).opacity(0.6))
                .shadow(color: Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.25), radius: 6.23, x: 0, y: 1.22)
                .overlay(
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.92, green: 0.97, blue: 1))
                            .frame(width: 40, height: 25)
                            .overlay(
                                Text("전공")
                                    .foregroundStyle(.blue)
                            )
                        HStack {
                            Text("운영체제")
                                .foregroundStyle(.black)
                            Text("김영준")
                                .foregroundStyle(.black)
                            
                        }
                        HStack {
                            Text("월 1-3")
                                .foregroundStyle(.black)
                            Text("AB012345")
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .padding(.horizontal, 10)
                        HStack {
                            Text("수강정원")
                            Text("200")
                            Text("담은인원")
                            Text("230")
                        }
                    }
                )
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                        }
                        Spacer()
                    }
                )
            //MARK: - ontapgesture로 아래로 열리면서 수강인원 그래프 구현
        }
    }
}

#Preview {
    DepartmentSheetView()
}
