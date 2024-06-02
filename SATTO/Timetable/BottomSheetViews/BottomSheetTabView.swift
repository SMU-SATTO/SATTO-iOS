//
//  BottomSheetTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

//MARK: - todo: 중복 선택 구현
struct BottomSheetTabView: View {
    @ObservedObject var subjectViewModel: SubjectViewModel
    @ObservedObject var selectedValues: SelectedValues
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    @State private var selectedTab = ""
    @State private var selectedCategories: [String: Bool] = [:]
    @State private var searchText = ""
    
    private let categories = ["학년", "교양", "e-러닝", "시간"]
    
    private let gradeOptions = ["전체", "1학년", "2학년", "3학년", "4학년"]
    @State private var selectedGrades: [String: Bool] = [:]
    
    private let GEOptions = ["전체", "일반교양", "균형교양", "교양필수"]
    @State private var selectedGE: [String: Bool] = [:]
    
    /// 중복 선택 안되게 구성
    private let BGEOptions = ["인문영역", "사회영역", "자연영역", "예술영역"]
    @State private var selectedBGE: [String: Bool] = [:]
    
    private let eLearnOptions = ["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    @State private var selectedELOption: [String: Bool] = [:]
    
    var showResultAction: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            categoryView
                .padding(.horizontal, 15)
                .padding(.top, 20)
            
            if selectedTab != "시간" {
                searchBar
                    .padding(.horizontal, 20)
            }
            
            selectedTabView
                .padding(.horizontal, 10)
            
            if selectedTab != "시간" {
                subjectSheetView
                Spacer()
            } else {
                Spacer()
            }
        }
    }
    
    private var categoryView: some View {
        HStack(spacing: 10) {
            ForEach(categories, id: \.self) { category in
                categoryButton(category: category)
            }
        }
        .padding(.top, 10)
    }
    
    private func categoryButton(category: String) -> some View {
        Button(action: {
            selectedCategories[category, default: false].toggle()
            selectedCategories.keys.forEach { key in
                selectedCategories[key] = (key == category)
            }
            selectedTab = category
        }) {
            Text(category)
                .font(.sb16)
                .foregroundStyle(selectedCategories[category, default: false] ? Color("blue_7") : .gray500)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(selectedCategories[category, default: false] ? Color("Info02") : .gray50)
                        .padding(EdgeInsets(top: -5, leading: -15, bottom: -5, trailing: -15))
                )
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        }
    }
    
    private var searchBar: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color("gray50"))
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
    }
    
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case "학년":
            OptionSheetView(options: gradeOptions, selectedOptions: $selectedGrades, allowsDuplicates: true)
        case "교양":
            OptionSheetView(options: GEOptions, selectedOptions: $selectedGE, allowsDuplicates: true)
            if selectedGE["균형교양"] == true {
                OptionSheetView(options: BGEOptions, selectedOptions: $selectedBGE, allowsDuplicates: false)
            }
        case "e-러닝":
            OptionSheetView(options: eLearnOptions, selectedOptions: $selectedELOption, allowsDuplicates: false)
        case "시간":
            TimeSheetView(selectedValues: selectedValues, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews)
                .padding(.top, 10)
        default:
            EmptyView()
        }
    }
    
    // MARK: - Subject Sheet View
    private var subjectSheetView: some View {
        VStack {
            SubjectSheetView(subjectViewModel: subjectViewModel, selectedValues: selectedValues, showResultAction: showResultAction)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

#Preview {
    BottomSheetTabView(subjectViewModel: SubjectViewModel(), selectedValues: SelectedValues(), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]), showResultAction: {})
}
