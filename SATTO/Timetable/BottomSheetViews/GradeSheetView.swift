//
//  GradeSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct GradeSheetView: View {
    private let gradeOptions = ["전체", "1학년", "2학년", "3학년", "4학년"]
    @State private var selectedGrades: [String: Bool] = [:]
    @State private var isFirstTimeAccess = true
    
    var body: some View {
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
            if isFirstTimeAccess {
                isFirstTimeAccess = false
                self.selectedGrades = Dictionary(uniqueKeysWithValues: self.gradeOptions.map { ($0, false) })
                self.selectedGrades[gradeOptions[0]] = true
            }
        }
    }
}

#Preview {
    GradeSheetView()
}
