//
//  SettingView.swift
//  SATTO
//
//  Created by 김영준 on 1/6/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        Text("Settings")
            .font(
                .custom("Apple SD Gothic Neo", size: 32)
                .weight(.semibold)
            )
            .kerning(0.64)
            .foregroundStyle(Color(red: 0.65, green: 0.59, blue: 0.48))
        
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: 0.74, green: 0.88, blue: 1))
                .frame(width: 350, height: 90)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    HStack(spacing: 10) {
                        Image("SATTO")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding(.leading, 20)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("username")
                                .font(.title)
                            Text("email")
                                .font(
                                    .custom("Apple SD Gothic Neo", size: 15)
                                    .weight(.thin)
                                )
                        }
                        Spacer()
                    }
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: 0.94, green: 0.94, blue: 0.94))
                .frame(width: 350, height: 150)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    VStack {
                        Text("1")
                    }
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: 0.94, green: 0.94, blue: 0.94))
                .frame(width: 350, height: 100)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    VStack {
                        Text("1")
                    }
                )
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .frame(width: 350, height: 100)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.gray)
                            .frame(width: 20, height: 20)
                        Text("로그아웃")
                            .font(
                                .custom("Apple SD Gothic Neo", size: 15)
                                .weight(.medium)
                            )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    .frame(width: 310, height: 40)
                    HStack {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .foregroundStyle(.gray)
                            .frame(width: 20, height: 20)
                        Text("회원탈퇴")
                            .font(
                                .custom("Apple SD Gothic Neo", size: 15)
                                .weight(.medium)
                            )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                        
                    }
                    .frame(width: 310, height: 40)
                }
                .frame(width: 350, height: 100)
                .foregroundStyle(.gray)
                
            }
        }
    }
}

#Preview {
    SettingView()
}
