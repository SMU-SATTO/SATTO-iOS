//
//  ELearnSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct ELearnSheetView: View {
    private let ELearnOptions = ["전체", "E러닝만 보기", "E러닝 빼고 보기"]
    @State private var selectedELOption: [String: Bool] = [:]
    @State private var isFirstTimeAccess = true
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(ELearnOptions.indices, id: \.self) { index in
                HStack(spacing: 10) {
                    Button(action: {
                        self.selectedELOption = Dictionary(uniqueKeysWithValues: self.ELearnOptions.map { ($0, false) })
                        self.selectedELOption[ELearnOptions[index], default: false] = true
                    }) {
                        Text(ELearnOptions[index])
                            .font(.sb12)
                            .foregroundStyle(selectedELOption[ELearnOptions[index], default: false] ? .blue : .black)
                            .padding([.leading, .trailing], 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.clear)
                                    .frame(height: 30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .inset(by: 0.5)
                                            .stroke(selectedELOption[ELearnOptions[index], default: false] ? .blue : Color.gray200, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .onAppear {
                if isFirstTimeAccess {
                    isFirstTimeAccess = false
                    self.selectedELOption = Dictionary(uniqueKeysWithValues: self.ELearnOptions.map { ($0, false) })
                    self.selectedELOption[ELearnOptions[0]] = true
                }
            }
        }
    }
}

#Preview {
    ELearnSheetView()
}
