//
//  SettingView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
//            Raindrop()
            MySquare()
        }
    }
}



struct MySquare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.width))
        path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.width * 1.2), control: CGPoint(x: rect.size.width * 0.8, y: rect.size.width * 1.2))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.size.width), control: CGPoint(x: rect.size.width * 0.2, y: rect.size.width * 1.2))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SettingView()
}
