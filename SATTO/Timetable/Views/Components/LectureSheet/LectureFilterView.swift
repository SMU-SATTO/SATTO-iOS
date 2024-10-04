//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 10/3/24.
//

import SwiftUI

struct LectureFilterView: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    @Binding var currCategory: String?
    
    var body: some View {
        VStack(spacing: 15) {
            LectureCategory(viewModel: viewModel, currCategory: $currCategory)
            LectureSearchBar(viewModel: viewModel)
                .padding(.horizontal, 20)
            switch currCategory {
            case "학년":
                LectureSubCategory(
                    viewModel: viewModel,
                    action: { viewModel.updateGrade(viewModel.selectedGradeCategories) },
                    currCategory: "학년",
                    subCategories: viewModel.gradeSubCategories,
                    allowDuplicates: true,
                    isSubCategorySelected: $viewModel.selectedGradeCategories
                )
            case "교양":
                LectureSubCategory(
                    viewModel: viewModel,
                    action: { viewModel.updateElective(viewModel.selectedElectiveCategories) },
                    currCategory: "교양",
                    subCategories: viewModel.electiveSubCategories,
                    allowDuplicates: true,
                    isSubCategorySelected: $viewModel.selectedElectiveCategories
                )
                ///`균형교양` 선택 시 추가적인 SubCategory
                if viewModel.selectedElectiveCategories[1] {
                    LectureSubCategory(
                        viewModel: viewModel,
                        action: { viewModel.updateBalanceElective(viewModel.selectedBalanceCategories) },
                        currCategory: "균형교양",
                        subCategories: viewModel.balanceSubCategories,
                        allowDuplicates: true,
                        isSubCategorySelected: $viewModel.selectedBalanceCategories
                    )
                }
            case "e-러닝":
                LectureSubCategory(
                    viewModel: viewModel,
                    action: { viewModel.updateELearn(viewModel.selectedELearnCategories) },
                    currCategory: "e-러닝",
                    subCategories: viewModel.eLearnSubCategories,
                    allowDuplicates: false,
                    isSubCategorySelected: $viewModel.selectedELearnCategories
                )
            case "시간":
                LectureTimeSheetView(viewModel: viewModel)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    LectureFilterView(viewModel: LectureSheetViewModel(container: .preview), currCategory: .constant("학년"))
}
