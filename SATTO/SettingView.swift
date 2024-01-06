//
//  SettingView.swift
//  SATTO
//
//  Created by 김영준 on 1/6/24.
//

import SwiftUI

struct SettingView: View {
    @State private var isLogoutPopupPresented = false
    @State private var isWithdrawalPopupPresented = false
    @State private var isRealWithdrawalPopupPresented = false
    var body: some View {
        ZStack {
            VStack {
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
                            Button(action: {
                                isLogoutPopupPresented.toggle()
                            }) {
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
                                        .foregroundStyle(.black)
                                }
                                .frame(width: 310, height: 40)
                            }
                            Button(action: {
                                isWithdrawalPopupPresented.toggle()
                            }){
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
                                        .foregroundStyle(.black)
                                    
                                }
                                .frame(width: 310, height: 40)
                            }
                        }
                        .frame(width: 350, height: 100)
                        .foregroundStyle(.gray)
                        
                    }
                }
            }
            .blur(radius: isLogoutPopupPresented || isWithdrawalPopupPresented ? 10 : 0)
            .disabled(isLogoutPopupPresented || isWithdrawalPopupPresented)
            if isLogoutPopupPresented {
                LogoutPopup(isLogoutPopupPresented: $isLogoutPopupPresented)
            }
            if isWithdrawalPopupPresented {
                WithdrawalPopup(isWithdrawalPopupPresented: $isWithdrawalPopupPresented)
            }
        }
    }
}

struct LogoutPopup: View {
    @Binding var isLogoutPopupPresented: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13).opacity(0.6))
            .frame(width: 330, height: 180)
            .overlay(
                VStack{
                    Text("로그아웃 하시겠습니까?")
                        .font(
                            .custom("Apple SD Gothic Neo", size: 18)
                            .weight(.bold)
                        )
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    HStack(spacing: 20) {
                        Button(action: {
                            isLogoutPopupPresented.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray)
                                .frame(width: 70, height: 30)
                                .overlay(
                                    Text("️예")
                                        .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                        .foregroundStyle(.white)
                                )
                        }
                        .padding(.top, 15)
                        Button(action: {
                            isLogoutPopupPresented.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray)
                                .frame(width: 70, height: 30)
                                .overlay(
                                    Text("️아니오")
                                        .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                        .foregroundStyle(.white)
                                )
                        }
                        .padding(.top, 15)
                    }
                }
            )
    }
}

struct WithdrawalPopup: View {
    @Binding var isWithdrawalPopupPresented: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color(red: 0.87, green: 1, blue: 1))
            .frame(width: 330, height: 180)
            .overlay(
                VStack{
                    Text("정말로 회원탈퇴 하시겠습니까?")
                        .font(
                            .custom("Apple SD Gothic Neo", size: 18)
                            .weight(.bold)
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 10)
                    HStack(spacing: 20) {
                        Button(action: {
                            isWithdrawalPopupPresented.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray)
                                .frame(width: 70, height: 30)
                                .overlay(
                                    Text("️예")
                                        .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                        .foregroundStyle(.white)
                                )
                        }
                        .padding(.top, 15)
                        Button(action: {
                            isWithdrawalPopupPresented.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray)
                                .frame(width: 70, height: 30)
                                .overlay(
                                    Text("️아니오")
                                        .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                        .foregroundStyle(.white)
                                )
                        }
                        .padding(.top, 15)
                    }
                }
            )
    }
}

#Preview {
    SettingView()
}
