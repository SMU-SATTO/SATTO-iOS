//
//  SearchSheetTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

struct SearchSheetTabView: View {
    @State private var selectedTab = 0
    
    let optionCategories = ["학과", "교양", "e-러닝", "시간"]
    @State var selectedCategories: [Bool] = [false, false, false, false]
    
    @State var searchText = ""
    
    let gradeOptions = ["전체", "1학년", "2학년", "3학년", "4학년"]
    @State var selectedGrades: [Bool] = [true, false, false, false, false]
    
    var tabs: [AnyView] {
        [
            AnyView(DepartmentSheetView()),
            AnyView(GradeSheetView()),
            AnyView(GESheetView()),
            AnyView(ELearnSheetView()),
            AnyView(TimeSheetView())
        ]
    }
    
    var body: some View {
        VStack {
            //MARK: - 검색, 학과, 학년, 교양, e-러닝 ... 가로 스크롤
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(optionCategories.indices, id: \.self) { category in
                        Button(action: {
                            selectedCategories[category].toggle()
                        }) {
                            Text(optionCategories[category])
                                .font(.b16)
                                .foregroundStyle(.blue)
                                .frame(width: 70, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(selectedCategories[category] ? Color(red: 0.91, green: 0.94, blue: 1) : .clear)
                                        .frame(width: 70, height: 30)
                                        .padding(EdgeInsets(top: -5, leading: -5, bottom: -5, trailing: -5))
                                )
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
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
                                .font(.sb14)
                                .foregroundStyle(.gray)
                                .padding(.leading, 5)
                            Button(action: {
                                searchText.removeAll()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                    )
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            //MARK: - 학년 선택
            HStack(spacing: 10) {
                ForEach(gradeOptions.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        Button(action: {
                            if index == 0 {
                                self.selectedGrades = Array(repeating: false, count: self.selectedGrades.count)
                                self.selectedGrades[0] = true
                            } else {
                                self.selectedGrades[0] = false
                                self.selectedGrades[index].toggle()
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.clear)
                                .frame(width: 60, height: 30)
                                .overlay(
                                    Text(gradeOptions[index])
                                        .foregroundStyle(selectedGrades[index] ? .blue : .black)
                                        .font(
                                            Font.custom("Pretendard", size: 14)
                                                .weight(.semibold)
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 0.5)
                                        .stroke(selectedGrades[index] ? .blue : Color.gray200, lineWidth: 1.5)
                                )
                        }
                    }
                }
            }
        }
        TabView(selection: $selectedTab) {
            ForEach(0..<tabs.count, id: \.self) { index in
                tabs[index].tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    SearchSheetTabView()
}
