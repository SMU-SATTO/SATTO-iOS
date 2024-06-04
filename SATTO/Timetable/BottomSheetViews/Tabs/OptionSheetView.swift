//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/3/24.
//

import SwiftUI

struct OptionSheetView: View {
    let options: [String]
    @Binding var selectedOptions: [String]
    let allowsDuplicates: Bool
    
    @State private var isFirstTimeAccess = true
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                optionButton(for: option)
            }
        }
        .onAppear(perform: initializeOptions)
    }
    
    private func optionButton(for option: String) -> some View {
        Button(action: {
            handleOptionSelection(for: option)
        }) {
            Text(option)
                .foregroundStyle(selectedOptions.contains(option) ? .blue : .black)
                .font(.sb12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.5)
                                .stroke(selectedOptions.contains(option) ? .blue : Color.gray200, lineWidth: 1)
                        )
                        .padding(EdgeInsets(top: -7, leading: -13, bottom: -7, trailing: -13))
                )
                .padding(EdgeInsets(top: 7, leading: 13, bottom: 7, trailing: 13))
        }
    }
    
    private func handleOptionSelection(for option: String) {
        if allowsDuplicates {
            if option == options.first {
                selectedOptions = [option]
            } 
            else {
                if selectedOptions.contains(option) {
                    selectedOptions.remove(at: selectedOptions.firstIndex(of: option)!)
                } 
                else {
                    selectedOptions.append(option)
                }
                if let firstIndex = selectedOptions.firstIndex(of: options.first!) {
                    selectedOptions.remove(at: firstIndex)
                }
                if selectedOptions.isEmpty {
                    selectedOptions = [options.first!]
                }
            }
        } 
        else {
            selectedOptions = [option]
        }
    }
    
    private func initializeOptions() {
        if isFirstTimeAccess && selectedOptions.isEmpty {
            isFirstTimeAccess = false
            selectedOptions = [options.first!]
        }
    }
}

#Preview {
    OptionSheetView(options: ["전체", "1학년", "2학년", "3학년", "4학년"], selectedOptions: .constant([]), allowsDuplicates: false)
}
