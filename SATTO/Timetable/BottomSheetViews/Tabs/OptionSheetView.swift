//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/3/24.
//

import SwiftUI

struct OptionSheetView: View {
    let options: [String]
    @Binding var selectedOptions: [String: Bool]
    let isToggleFirst: Bool

    @State private var isFirstTimeAccess = true

    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                optionButton(for: option)
            }
        }
        .onAppear(perform: initializeOptions)
    }

    // MARK: - Option Button
    private func optionButton(for option: String) -> some View {
        Button(action: {
            handleOptionSelection(for: option)
        }) {
            Text(option)
                .foregroundStyle(selectedOptions[option, default: false] ? .blue : .black)
                .font(.sb12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.5)
                                .stroke(selectedOptions[option, default: false] ? .blue : Color.gray200, lineWidth: 1)
                        )
                        .padding(EdgeInsets(top: -7, leading: -13, bottom: -7, trailing: -13))
                )
                .padding(EdgeInsets(top: 7, leading: 13, bottom: 7, trailing: 13))
        }
    }

    // MARK: - Handle Option Selection
    private func handleOptionSelection(for option: String) {
        if isToggleFirst {
            if option == options.first {
                selectedOptions = Dictionary(uniqueKeysWithValues: options.map { ($0, false) })
                selectedOptions[option] = true
            } else {
                selectedOptions[options.first!] = false
                selectedOptions[option, default: false].toggle()
            }
        } else {
            selectedOptions = Dictionary(uniqueKeysWithValues: options.map { ($0, false) })
            selectedOptions[option] = true
        }
    }
    
    // MARK: - Initialize Options
    private func initializeOptions() {
        if isFirstTimeAccess {
            isFirstTimeAccess = false
            selectedOptions = Dictionary(uniqueKeysWithValues: options.map { ($0, false) })
            selectedOptions[options.first!] = true
        }
    }
}

#Preview {
    OptionSheetView(options: ["전체", "1학년", "2학년", "3학년", "4학년"], selectedOptions: .constant([:]), isToggleFirst: true)
}
