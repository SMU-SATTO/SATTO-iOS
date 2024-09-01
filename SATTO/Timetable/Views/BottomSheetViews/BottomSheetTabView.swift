//
//  BottomSheetTabView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI

struct BottomSheetTabView: View {
    @ObservedObject var selectedValues: SelectedValues
    @ObservedObject var bottomSheetViewModel: BottomSheetViewModel
    
    @Binding var selectedSubviews: Set<Int>
    @Binding var alreadySelectedSubviews: Set<Int>
    
    @State private var selectedTab = ""
    @State private var selectedCategories: [String] = []
    
    private let categories = ["학년", "교양", "e-러닝", "시간"]
    
    private let gradeOptions = ["전체", "1학년", "2학년", "3학년", "4학년"]
    private let GEOptions = ["전체", "일반교양", "균형교양", "교양필수"]
    private let BGEOptions = ["전체", "인문", "사회", "자연", "공학", "예술"]
    private let eLearnOptions = ["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    
    var showResultAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.popupBackground
                .ignoresSafeArea(.all)
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
        let isSelected = selectedTab == category
        let isCategorySelected: Bool
        
        switch category {
        case "학년":
            isCategorySelected = bottomSheetViewModel.isGradeSelected()
        case "교양":
            isCategorySelected = bottomSheetViewModel.isGESelected()
        case "e-러닝":
            isCategorySelected = bottomSheetViewModel.isELOptionSelected()
        case "시간":
            isCategorySelected = bottomSheetViewModel.isTimeSelected()
        default:
            isCategorySelected = false
        }
        
        return Button(action: {
            selectedTab = category
        }) {
            Text(category)
                .font(.m16)
                .foregroundStyle(isSelected || isCategorySelected ? Color.categoryTextSelected : Color.categoryTextUnselected)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(isSelected ? Color.categorySelected : Color.pickerBackground)
                        .padding(EdgeInsets(top: -5, leading: -15, bottom: -5, trailing: -15))
                )
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        }
    }
    
    private var searchBar: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.searchbarBackground)
                .frame(height: 40)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 19, height: 19)
                            .foregroundStyle(Color.searchbarText)
                            .padding(.leading, 15)
                        TextField("듣고 싶은 과목을 입력해 주세요", text: $bottomSheetViewModel.searchText)
                            .font(.sb14)
                            .autocorrectionDisabled()
                            .foregroundStyle(Color.searchbarText)
                            .padding(.leading, 5)
                            .submitLabel(.search)
                            .onSubmit {
                                bottomSheetViewModel.resetCurrPage()
                                bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
                            }
                        Button(action: {
                            bottomSheetViewModel.searchText.removeAll()
                            bottomSheetViewModel.resetCurrPage()
                            bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.searchbarText)
                        }
                        .padding(.trailing, 3)
                        Spacer()
                    }
                )
        }
    }
    
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case "학년":
            OptionSheetView(options: gradeOptions, selectedOptions: $bottomSheetViewModel.selectedGrades, allowsDuplicates: true) {
                bottomSheetViewModel.resetCurrPage()
                bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
            }
        case "교양":
            OptionSheetView(options: GEOptions, selectedOptions: $bottomSheetViewModel.selectedGE, allowsDuplicates: true) {
                bottomSheetViewModel.resetCurrPage()
                bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
            }
            if bottomSheetViewModel.selectedGE.contains("균형교양") {
                OptionSheetView(options: BGEOptions, selectedOptions: $bottomSheetViewModel.selectedBGE, allowsDuplicates: true) {
                    bottomSheetViewModel.resetCurrPage()
                    bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
                }
            }
        case "e-러닝":
            OptionSheetView(options: eLearnOptions, selectedOptions: $bottomSheetViewModel.selectedELOption, allowsDuplicates: false) {
                bottomSheetViewModel.resetCurrPage()
                bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
            }
        case "시간":
            TimeSheetView(bottomSheetViewModel: bottomSheetViewModel, selectedSubviews: $selectedSubviews, alreadySelectedSubviews: $alreadySelectedSubviews) 
                .padding(.top, 10)
                .onDisappear {
                    bottomSheetViewModel.resetCurrPage()
                    bottomSheetViewModel.fetchCurrentLectureList(page: bottomSheetViewModel.currentPage)
                }
        default:
            EmptyView()
        }
    }
    
    // MARK: - Subject Sheet View
    private var subjectSheetView: some View {
        VStack {
            SubjectSheetView(bottomSheetViewModel: bottomSheetViewModel, selectedValues: selectedValues, showResultAction: showResultAction)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

#Preview {
    BottomSheetTabView(selectedValues: SelectedValues(), bottomSheetViewModel: BottomSheetViewModel(), selectedSubviews: .constant([]), alreadySelectedSubviews: .constant([]), showResultAction: {})
        .preferredColorScheme(.dark)
}
