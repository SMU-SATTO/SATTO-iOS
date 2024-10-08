//
//  CustomNavigationTitle.swift
//  SATTO
//
//  Created by 황인성 on 7/16/24.
//

import SwiftUI

struct CustomNavigationTitle: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.b20)
            .foregroundStyle(.backButton)
            .padding(.leading, 5)
    }
}

#Preview {
    CustomNavigationTitle(title: "친구관리")
}
