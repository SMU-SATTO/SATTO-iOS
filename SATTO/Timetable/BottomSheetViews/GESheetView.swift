//
//  GESheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

/// 교양
struct GESheetView: View {
    private let GEOptions = ["전체", "일반교양", "기초교양", "균형교양", "교양필수"]
    @State private var selectedGE: [String: Bool] = [:]
    @State private var isFirstTimeAccess = true
    
    var body: some View {
        // 학년에 따른 뷰
        HStack(spacing: 10) {
            ForEach(GEOptions.indices, id: \.self) { index in
                HStack(spacing: 10) {
                    Button(action: {
                        self.selectedGE = Dictionary(uniqueKeysWithValues: self.GEOptions.map { ($0, false) })
                        self.selectedGE[GEOptions[index], default: false] = true
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.clear)
                            .frame(width: 60, height: 30)
                            .overlay(
                                Text(GEOptions[index])
                                    .foregroundStyle(selectedGE[GEOptions[index], default: false] ? .blue : .black)
                                    .font(.sb12)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .stroke(selectedGE[GEOptions[index], default: false] ? .blue : Color.gray200, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .onAppear {
            if isFirstTimeAccess {
                isFirstTimeAccess = false
                self.selectedGE = Dictionary(uniqueKeysWithValues: self.GEOptions.map { ($0, false) })
                self.selectedGE[GEOptions[0]] = true
            }
        }
    }
}

#Preview {
    GESheetView()
}
