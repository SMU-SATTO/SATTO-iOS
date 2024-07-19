//
//  ProfileImageCell.swift
//  SATTO
//
//  Created by 황인성 on 7/16/24.
//

import SwiftUI

struct ProfileImageCell: View {
    
    var inCircleSize: CGFloat
    var outCircleSize: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: outCircleSize, height: outCircleSize)
            .overlay(
                Circle()
                    .frame(width: inCircleSize, height: inCircleSize)
            )
            .shadow(radius: 15, x: 0, y: 10)
    }
}

#Preview {
    ProfileImageCell(inCircleSize: 67, outCircleSize: 70)
}
