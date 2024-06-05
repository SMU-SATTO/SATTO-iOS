//
//  EmailPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct EmailPageView: View {
    @State var number = ""
    @State private var isEmailEnabled = false
    @State private var isSendEmail = false


    var body: some View {
        VStack {
            Text("회원가입을 위해\n학교 이메일 인증을 해주세요.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 150)

            if !isSendEmail {
                Text("이미 등록된 이메일 입니다.")
                  .font(.caption)
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(Color.red)
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .padding(.trailing, 50)
            }

            HStack {
                TextField("학번", text: $number)
                    .padding()
                    .frame(width: 150, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray)
                    )

                Text("@sangmyung.kr")
            }

            NavigationLink(destination: Text("Email Check View"), isActive: $isSendEmail) {
                Button(action: {
                    // Action for the button
                }) {
                    Text("이메일 인증하기")
                        .foregroundColor(isEmailEnabled ? Color.white : Color.gray)
                        .font(.headline)
                        .frame(width: 365, height: 50)
                        .background(isEmailEnabled ? Color.orange : Color.gray)
                        .cornerRadius(10)
                        .padding(.top, 320)
                }
            }
            .disabled(!isEmailEnabled)
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                isSendEmail = true
            }
        }
        .onReceive([number].publisher.collect()) { values in
            isEmailEnabled = values.allSatisfy { number in
                let regex = #"^\d{9}"#
                return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
            }
        }
    }
}

#Preview {
    EmailPageView()
}
