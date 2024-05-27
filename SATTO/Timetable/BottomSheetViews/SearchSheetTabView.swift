//
//  SearchSheetTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

//MARK: - todo: 중복 선택 구현
struct SearchSheetTabView: View {
    @ObservedObject var timetableViewModel: TimetableViewModel
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    @State private var selectedTab = ""
    @State private var selectedCategories: [String: Bool] = [:]
    private let categories = ["학년", "교양", "e-러닝", "시간"]
    
    @State private var searchText = ""
    
    var showResultAction: () -> Void
    
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
            .padding(.top, 20)
            //MARK: - 검색 바
            if selectedTab != "시간" {
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
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
            //MARK: - Option에 따라 다른 뷰 제공
            switch selectedTab {
            case "학년":
                // 학년에 따른 뷰
                GradeSheetView()
                    .frame(height: 30)
            case "학과":
                // 학과에 따른 뷰 - 삭제
                EmptyView()
            case "교양":
                // 교양에 따른 뷰
                GESheetView()
                    .frame(height: 30)
            case "e-러닝":
                // e-러닝에 따른 뷰
                ELearnSheetView()
                    .frame(height: 30)
            case "시간":
                // 시간에 따른 뷰
                TimeSheetView(selectedValues: selectedValues, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews)
                    .padding(.top, 10)
            default:
                EmptyView()
            }
            if selectedTab != "시간" {
                VStack {
                    SubjectSheetView(timetableViewModel: timetableViewModel, selectedValues: selectedValues, showResultAction: showResultAction)
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    
                    Spacer()
                }
            }
            else {
                Spacer()
            }
        }
        
    }
}

#Preview {
    SearchSheetTabView(timetableViewModel: TimetableViewModel(), selectedValues: SelectedValues(), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]), showResultAction: {})
}
