//
//  NextPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct EmailAuthView: View {
    @State private var email = ""
    @State private var isEmailEnabled = false
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Text("아이디로 사용할\n학번을 입력해 주세요")
                  .foregroundColor(Color(red: 0.1, green: 0.11, blue: 0.12))
//                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.bottom, 20)

                HStack(spacing: 0) {
                    TextField("이메일 주소 입력", text: $email)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                            
                        )
                        .padding(.trailing, 8)
                    
                    
                        Text("@sangmyung.kr")
                }
                
                Text("인증번호를 입력해주세요")
                
                TextField("이메일 주소 입력", text: $email)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                        
                    )

                Button(action: {
                    navPathFinder.addPath(route: .SignUpView)
                }) {
                    Text("비밀번호 전송")
                        .foregroundColor(isEmailEnabled ? Color.white : Color.gray)
                        .font(.headline)
                        .frame(width: 365, height: 50)
                        .background(isEmailEnabled ? Color.orange : Color.gray)
                        .cornerRadius(10)
                        .padding(.top, 320)
                }
//                .disabled(!isEmailEnabled)
            }
            .padding(.horizontal, 20)
            .onReceive([email].publisher.collect()) { values in
                isEmailEnabled = values.allSatisfy { email in
                    let regex = #"^\d{9}@sangmyung\.kr$"#
                    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
                }
        }
        }
    }
}

#Preview {
    EmailAuthView()
        .environmentObject(NavigationPathFinder.shared)
}
