//
//  SearchSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

struct SearchSheetView: View {
    @State private var isShowBottomSheet = true
    @State var searchText = ""
    var body: some View {
        ZStack {
            Button(action: {
                isShowBottomSheet.toggle()
            })
            {
                RoundedRectangle(cornerRadius: 60)
                    .foregroundStyle(Color.blue)
                    .frame(width: 300, height: 100)
                    .sheet(isPresented: $isShowBottomSheet) {
                        ScrollView {
                            //MARK: - 검색, 학과, 학년, 교양, e-러닝 ... 가로 스크롤
                            ScrollView(.horizontal) {
                                Text("검색")
                                    .font(
                                        Font.b2
                                    )
                                    .foregroundStyle(.blue)
                                    .frame(width: 100, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color(red: 0.91, green: 0.94, blue: 1))
                                            .frame(width: 75, height: 35)
                                            .padding(EdgeInsets(top: -5, leading: -5, bottom: -5, trailing: -5))
                                    )
                                    .padding(.top, 10)
                            }
                            //MARK: - 검색 바
                            VStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(Color(red: 0.97, green: 0.97, blue: 0.98))
                                    .frame(height: 40)
                                    .overlay(
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 19, height: 19)
                                                .foregroundStyle(.gray)
                                                .padding(.leading, 15)
                                            TextField("듣고 싶은 과목을 입력해 주세요", text: $searchText)
                                                .font(
                                                    .custom("Apple SD Gothic Neo", size: 15)
                                                    .weight(.semibold)
                                                )
                                                .foregroundStyle(.gray)
                                                .padding(.leading, 5)
                                            Button(action: {
                                                
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundStyle(.gray)
                                            }
                                            Spacer()
                                        }
                                    )
                                    .padding(.horizontal, 15)
                            }
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.clear)
                                    .frame(width: 60, height: 30)
                                    .overlay(
                                        Text("전체")
                                            .foregroundStyle(.blue1)
                                            .font(
                                                Font.custom("Pretendard", size: 14)
                                                    .weight(.semibold)
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .inset(by: 0.5)
                                            .stroke(Color.blue7, lineWidth: 1.5)
                                    )
                            }
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
                        .presentationDetents([.medium, .large])
                        .padding(.bottom, 20)
                    }
                    .padding(.bottom, 20)
                
            }
        }
    }
}

#Preview {
    SearchSheetView()
}
