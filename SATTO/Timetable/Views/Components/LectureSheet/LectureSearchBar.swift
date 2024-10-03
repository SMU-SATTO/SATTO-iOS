//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 10/2/24.
//

import SwiftUI

struct LectureSearchBar: View {
    @ObservedObject var viewModel: LectureSheetViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.searchbarBackground)
                .frame(height: 40)
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 19, height: 19)
                    .foregroundStyle(Color.searchbarText)
                    .padding(.leading, 15)
                TextField("듣고 싶은 과목을 입력해 주세요", text: $viewModel.searchText)
                    .font(.sb14)
                    .autocorrectionDisabled()
                    .foregroundStyle(Color.searchbarText)
                    .padding(.leading, 5)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.resetCurrPage()
                        Task {
                            await viewModel.fetchCurrentLectureList()
                        }
                    }
                Button(action: {
                    viewModel.resetSearchText()
                    viewModel.resetCurrPage()
                    Task {
                        await viewModel.fetchCurrentLectureList()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.searchbarText)
                }
                .padding(.trailing, 3)
                Button(action: {
                    viewModel.resetCurrPage()
                    Task {
                        await viewModel.fetchCurrentLectureList()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19, height: 19)
                        .foregroundStyle(Color.searchbarText)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    LectureSearchBar(viewModel: LectureSheetViewModel(container: .preview))
        .padding(.horizontal, 30)
}
