//
//  LoginPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct LoginPageView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginEnabled = false
    @State private var isEmailEnabled = false
    
    @State private var isPasswordEnabled = false
    
    @Binding var isLoggedin: Bool
    @Binding var showLoginPage: Bool
    @EnvironmentObject var navPathFinder: NavigationPathFinder
    @Binding var studentID: Int
    @Binding var username: String

    var body: some View {
        VStack {
            Image("Logo")
                .padding(.top, 210)
            
            TextField("이메일", text: $email)
                .padding()
                .frame(width: 339, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("DividerGray"))
                )
                .padding(.top, 10)
            
            SecureField("비밀번호", text: $password)
                .padding()
                .frame(width: 339, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("DividerGray"))
                )
                .padding(.top, 10)
            
            Button(action: {
                // Action for the button
            }) {
                Text("로그인 PASS")
                    .foregroundColor(isLoginEnabled && isEmailEnabled ? Color.white : Color.black)
                    .font(
                        Font.custom("NanumSquareRoundOTF", size: 18)
                            .weight(.heavy)
                    )
                    .frame(width: 365, height: 50)
                    .background(isLoginEnabled && isEmailEnabled ? Color("CustomOrange") : Color("DividerGray"))
                    .cornerRadius(10)
            }
            .padding(.top, 180)

            Button(action: {
                // Action for the button
            }) {
                Text("로그인")
                    .foregroundColor(isLoginEnabled && isEmailEnabled ? Color.white : Color.black)
                    .font(
                        Font.custom("NanumSquareRoundOTF", size: 18)
                            .weight(.heavy)
                    )
                    .frame(width: 365, height: 50)
                    .background(isLoginEnabled && isEmailEnabled ? Color("CustomOrange") : Color("DividerGray"))
                    .cornerRadius(10)
            }
            .padding(.top, 180)
            .disabled(!isLoginEnabled)
            .disabled(!isEmailEnabled)

//            NavigationLink(value: LoginNavigationStackView.nextPageView) {
                Text("비밀번호 찾기")
                .foregroundColor(Color.black)
                    .font(
                        Font.custom("NanumSquareRoundOTF", size: 16)
                            .weight(.bold)
                    )
                    .underline()
//            }
            .padding(.bottom, 30)
            .navigationBarTitle("", displayMode: .inline)
        }
        .onReceive([email, password].publisher.collect()) { values in
            isLoginEnabled = values.allSatisfy { !$0.isEmpty }
        }
        .onReceive([email].publisher.collect()) { values in
            isEmailEnabled = values.allSatisfy { email in
                let regex = #"^\d{9}@sangmyung\.kr$"# // 숫자 9개 + @sangmyung.kr 패턴
                return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
            }
        }
    }
}

#Preview {
    LoginPageView(isLoggedin: .constant(true), showLoginPage: .constant(true), studentID: .constant(201910914), username: .constant("insung"))
}
