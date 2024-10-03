//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 10/2/24.
//

import SwiftUI

struct LectureCategory: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    @Binding var currCategory: String?
    
    var body: some View {
        HStack {
            ForEach(viewModel.categories, id: \.self) { category in
                CategoryButton(
                    action: { currCategory = category },
                    category: category,
                    isSelected: currCategory == category,
                    isSubCategorySelected: viewModel.isSubCategorySelected(for: category)
                )
            }
        }
    }
}

struct CategoryButton: View {
    let action: () -> Void
    let category: String
    let isSelected: Bool
    let isSubCategorySelected: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                action()
            }) {
                Text(category)
                    .font(.m16)
                    .foregroundStyle(
                        isSelected || isSubCategorySelected
                        ? Color.categoryTextSelected
                        : Color.categoryTextUnselected)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(
                                isSelected
                                ? Color.categorySelected
                                : Color.pickerBackground)
                            .padding(EdgeInsets(top: -5, leading: -15, bottom: -5, trailing: -15))
                    )
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            }
        }
    }
}

/// `"전체"`는 initailizer로 분리
struct LectureSubCategory: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    let action: () -> Void
    let currCategory: String
    let subCategories: [String]
    let allowDuplicates: Bool
    @Binding var isSubCategorySelected: [Bool]
    
    var body: some View {
        HStack(spacing: 8) {
            SubCategoryButton(
                action: {
                    Task {
                        viewModel.resetSubCategory(for: currCategory)
                        await viewModel.searchLecture()
                    }
                },
                subCategoryText: "전체",
                index: -1,
                isSelected: isSubCategorySelected.allSatisfy { !$0 })
            ForEach(subCategories.indices, id: \.self) { index in
                SubCategoryButton(
                    action: {
                        Task {
                            viewModel.toggleSubCategorySelection(for: currCategory, at: index, allowDuplicates: allowDuplicates)
                            action()
                            await viewModel.searchLecture()
                        }
                    },
                    subCategoryText: subCategories[index],
                    index: index,
                    isSelected: isSubCategorySelected[index])
            }
        }
    }
}

struct SubCategoryButton: View {
    let action: () -> Void
    let subCategoryText: String
    let index: Int
    let isSelected: Bool
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(subCategoryText)
                .font(.sb12)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(
                    isSelected
                    ? Color.buttonBlue
                    : Color.blackWhite)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.5)
                                .stroke(
                                    isSelected
                                    ? Color.buttonBlue
                                    : Color.blackWhite,
                                    lineWidth: 1)
                        )
                        .padding(EdgeInsets(top: -7, leading: -13, bottom: -7, trailing: -13))
                )
                .padding(EdgeInsets(top: 7, leading: 13, bottom: 7, trailing: 13))
        }
    }
}

#Preview {
    LectureCategory(viewModel: LectureSheetViewModel(container: .preview), currCategory: .constant("학년"))
}
