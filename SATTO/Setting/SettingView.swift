//
//  SettingView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        //        VStack(spacing: 0) {
        //            MySquare()
        //                .fill(Color.red)
        //                .frame(maxWidth: .infinity, maxHeight: 230)
        //
        //            Spacer()
        //
        //            Text("한민재")
        //                .font(.sb7)
        //              .foregroundColor(Color.gray800)
        //
        //            // m14
        //            Text("\(" 20201499@sungshin.ac.kr ")")
        //                .font(.m3)
        //              .foregroundColor(Color.gray600)
        //
        //
        //
        //        }
        
        ZStack {
            VStack(spacing: 0) {
                MySquare()
                    .fill(Color.red)
                    .frame(maxWidth: .infinity, maxHeight: 230)
                Spacer()
            }
            
            VStack(spacing: 0) {
                Text("한민재")
                    .font(.sb7)
                    .foregroundColor(Color.gray800)
                
                // m14
                Text("\(" 20201499@sungshin.ac.kr ")")
                    .font(.m3)
                    .foregroundColor(Color.gray600)
            }
        }
        
    }
}



struct MySquare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height * 0.8))
        path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.height), control: CGPoint(x: rect.size.width * 0.8, y: rect.size.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.size.height * 0.8), control: CGPoint(x: rect.size.width * 0.2, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SettingView()
}
