//
//  LectureButtons.swift
//  SATTO
//
//  Created by yeongjoon on 10/4/24.
//

import SwiftUI

struct ShowLectureButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text("강의 목록 보기")
                .font(.sb14)
                .foregroundStyle(.blackWhite)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 2)
                                .stroke(.buttonBlue200, lineWidth: 1.5)
                        )
                        .padding(EdgeInsets(top: -10, leading: -15, bottom: -10, trailing: -15))
                )
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        }
    }
}

#Preview {
    ShowLectureButton(action: { })
}
