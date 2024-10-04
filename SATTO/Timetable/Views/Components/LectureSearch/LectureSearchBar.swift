//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 10/2/24.
//

import SwiftUI

struct LectureSearchBar: View {
    @ObservedObject var viewModel: LectureSearchViewModel
    
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
                TextField("듣고 싶은 과목을 입력해 주세요", text: $viewModel.lectureFilter.searchText)
                    .font(.sb14)
                    .autocorrectionDisabled()
                    .foregroundStyle(Color.searchbarText)
                    .padding(.leading, 5)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.resetCurrPage()
                        Task {
                            await viewModel.searchLecture()
                        }
                    }
                if !viewModel.lectureFilter.searchText.isEmpty {
                    Button(action: {
                        viewModel.resetSearchText()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.searchbarText)
                    }
                }
                Button(action: {
                    viewModel.resetCurrPage()
                    Task {
                        await viewModel.searchLecture()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.white)
                            .frame(width: 25, height: 25)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.searchbarText)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    LectureSearchBar(viewModel: LectureSearchViewModel(container: .preview))
        .padding(.horizontal, 30)
}
