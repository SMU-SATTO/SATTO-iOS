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
            
            background
            
            ScrollView {
                VStack(spacing: 0) {
                        
                    ProfileImageCell(inCircleSize: 125, outCircleSize: 130)
                        .padding(.top, 130)
                        .padding(.bottom, 14)
                    
                    Text("한민재")
                        .font(.sb18)
                        .foregroundColor(Color.gray800)
                    
                    Text("\(" 20201499@sungshin.ac.kr ")")
                        .font(.m14)
                        .foregroundColor(Color.gray600)
                        .padding(.bottom, 14)
                    
                    VStack(spacing: 18) {
                        VStack(spacing: 0) {
                            
                            SettingToggle(toogleTitle: "계정 공개", toggleImage: "account")
                            SettingToggle(toogleTitle: "버스 우회 정보", toggleImage: "bus")
                            SettingToggle(toogleTitle: "알림 기능", toggleImage: "alarm")
                            SettingToggle(toogleTitle: "다크모드", toggleImage: "darkmode")
                            
                        }
                        .padding(.vertical, 5)
                        .background(
                            border
                        )
                        
                        VStack(spacing: 0) {
                            
                            SettingOptionCell(settingImageName: "edit", settingName: "시간표 수정하기")
                            SettingOptionCell(settingImageName: "info", settingName: "공지사항")
                            
                        }
                        .padding(.vertical, 5)
                        .background(
                            border
                        )
                        
                        VStack(spacing: 0) {
                            
                            SettingOptionCell(settingImageName: "ask", settingName: "문의하기")
                            SettingOptionCell(settingImageName: "logout", settingName: "현재 버전")
                            SettingOptionCell(settingImageName: "logout", settingName: "로그아웃")
                            SettingOptionCell(settingImageName: "delete", settingName: "탈퇴하기")
                            
                        }
                        .padding(.vertical, 5)
                        .background(
                            border
                        )
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var background: some View {
        VStack(spacing: 0) {
            MySquare()
                .fill(Color.gray100)
            .frame(maxWidth: .infinity, maxHeight: 230)
            
            Spacer()
        }
    }
    
    var border: some View {
        Rectangle()
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5, x: 0, y: 0)
    }
}


struct SettingToggle: View {
    @State private var isOn = false
    var toogleTitle: String
    var toggleImage: String
    
    var body: some View {
        
            Toggle(isOn: $isOn) {
                HStack(spacing: 0) {
                    Image(toggleImage)
                        .padding(.leading, 5)
                        .padding(.trailing, 14)
                    
                    Text(toogleTitle)
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundColor(Color.gray600)
                }
                
            }
            .tint(Color(red: 0.18, green: 0.5, blue: 0.93))
            .padding(.horizontal, 23)
            .padding(.vertical, 7)
        
    }
        
}

struct SettingOptionCell: View {
    
    var settingImageName: String
    var settingName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(settingImageName)
                .padding(.leading, 5)
                .padding(.trailing, 14)
            
            Text(settingName)
                .font(Font.custom("Pretendard", size: 14))
                .foregroundColor(Color.gray600)
            
            Spacer()
        }
        .padding(.horizontal, 23)
        .padding(.vertical, 8)
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


