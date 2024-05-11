//
//  SearchSheetTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

struct SearchSheetTabView: View {
    @State private var selectedTab = ""
    @State private var selectedCategories: [String: Bool] = [:]
    private let categories = ["학년", "교양", "e-러닝", "시간"]
    
    @State private var searchText = ""
    
    private let gradeOptions = ["전체", "1학년", "2학년", "3학년", "4학년"]
    @State private var selectedGrades: [String: Bool] = [:]
    var body: some View {
        VStack {
            //MARK: - 검색, 학과, 학년, 교양, e-러닝 ... 가로 스크롤
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategories[category, default: false].toggle()
                            selectedCategories.keys.forEach { key in
                                    selectedCategories[key] = (key == category)
                                }
                                selectedTab = category
                        }) {
                            Text(category)
                                .font(.sb16)
                                .foregroundStyle(selectedCategories[category, default: false] ? Color(red: 0.11, green: 0.33, blue: 1) : .gray500)
                                .foregroundStyle(.blue)
                                .frame(width: 70, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(selectedCategories[category, default: false] ? Color(red: 0.91, green: 0.94, blue: 1) : .gray50)
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
            //MARK: - Option에 따라 다른 뷰 제공
            switch selectedTab {
            case "학년":
                // 학년에 따른 뷰
                HStack(spacing: 10) {
                    ForEach(gradeOptions.indices, id: \.self) { index in
                        HStack(spacing: 10) {
                            Button(action: {
                                if index == 0 {
                                    self.selectedGrades = Dictionary(uniqueKeysWithValues: self.gradeOptions.map { ($0, false) })
                                    self.selectedGrades[gradeOptions[0]] = true
                                } else {
                                    self.selectedGrades[gradeOptions[0]] = false
                                    self.selectedGrades[gradeOptions[index], default: false].toggle()
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.clear)
                                    .frame(width: 60, height: 30)
                                    .overlay(
                                        Text(gradeOptions[index])
                                            .foregroundStyle(selectedGrades[gradeOptions[index], default: false] ? .blue : .black)
                                            .font(.sb12)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .inset(by: 0.5)
                                            .stroke(selectedGrades[gradeOptions[index], default: false] ? .blue : Color.gray200, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .onAppear {
                    //MARK: - 중복 가능하게 수정 필요
                    self.selectedGrades[gradeOptions[0]] = true
                }
            case "학과":
                // 학과에 따른 뷰
                EmptyView()
            case "교양":
                // 교양에 따른 뷰
                EmptyView()
            case "e-러닝":
                // e-러닝에 따른 뷰
                EmptyView()
            case "시간":
                // 시간에 따른 뷰
                EmptyView()
            default:
                EmptyView()
            }
            
            ScrollView {
                DefaultSheetView()
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
                Spacer()
            }
            .ignoresSafeArea(.all)
            .onAppear {
                UIScrollView.appearance().isScrollEnabled = false
            }
        }
        
    }
}

#Preview {
    SearchSheetTabView()
}
