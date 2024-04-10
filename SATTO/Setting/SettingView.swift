//
//  SettingView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

struct SettingView: View {
    
    @State private var isOn = true
    
    var body: some View {

        
        ZStack {
//            ScrollView {
                VStack(spacing: 0) {
                    MySquare()
                        .fill(Color.red)
                        .frame(maxWidth: .infinity, minHeight: 230)
                        
                    
                    ProfileImageCell(inCircleSize: 125, outCircleSize: 130)
                        .padding(.top, -100)
                        .padding(.bottom, 14)
                    
                    Text("한민재")
                        .font(.sb18)
                        .foregroundColor(Color.gray800)
                    
                    Text("\(" 20201499@sungshin.ac.kr ")")
                        .font(.m14)
                        .foregroundColor(Color.gray600)
                        .padding(.bottom, 14)
                    
                    LazyVStack(spacing: 15) {
                        
                        Toggle1()
                        Toggle1()
                        Toggle1()
                        Toggle1()
                        
                    }
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 5, x: 0, y: 0)
                    )
                    .padding(.horizontal, 25)
                    .padding(.bottom, 18)
                    
                    
                    LazyVStack(spacing: 15) {
                        
                        SettingOptionCell()
                        SettingOptionCell()
                        
                    }
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 5, x: 0, y: 0)
                    )
                    .padding(.horizontal, 25)
                    .padding(.bottom, 18)
                    
                    LazyVStack(spacing: 15) {
                        
                        SettingOptionCell()
                        SettingOptionCell()
                        SettingOptionCell()
                        SettingOptionCell()
                        
                    }
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 5, x: 0, y: 0)
                    )
                    .padding(.horizontal, 25)
                    .padding(.bottom, 100)
                    
                }
                
                
//            }
            .ignoresSafeArea()
        }
    }
}


struct Toggle1: View {
    @State private var isOn = true
    
    var body: some View {
        
            Toggle(isOn: $isOn) {
                HStack(spacing: 0) {
                    Image("account")
                        .padding(.leading, 5)
                        .padding(.trailing, 14)
                    
                    Text("계정 공개")
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundColor(Color.gray600)
                }
                
            }
            .padding(.horizontal, 23)
        
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

#Preview {
    ContentView()
}

struct SettingOptionCell: View {
    var body: some View {
        HStack(spacing: 0) {
            Image("account")
                .padding(.leading, 5)
                .padding(.trailing, 14)
            
            Text("계정 공개")
                .font(Font.custom("Pretendard", size: 14))
                .foregroundColor(Color.gray600)
            
            Spacer()
        }
        .padding(.horizontal, 23)
    }
}
