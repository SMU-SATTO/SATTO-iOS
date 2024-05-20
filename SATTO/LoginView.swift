//
//  LoginView.swift
//  SATTO
//
//  Created by 김영준 on 12/31/23.
//

import SwiftUI

struct LoginView: View {
    @State private var login = ""
    @State private var password = ""
    var body: some View {
        VStack {
            
            Image("SATTO")
                .resizable()
                .frame(width: 300, height: 400)
            Text("SATTO")
                .font(
                    .custom("Apple SD Gothic Neo", size: 15)
                    .weight(.bold)
                )
            Text("Sangmyung Auto Time Table Organizer")
                .foregroundStyle(.gray)
                .font(
                    .custom("Apple SD Gothic Neo", size: 15)
                    .weight(.thin)
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: 0.97, green: 0.97, blue: 0.97))
                .frame(width: 320, height: 50)
                .overlay(
                    HStack {
                        Image(systemName: "person")
                            .padding(.leading, 10)
                        TextField("ID", text: $login)
                            .font(
                                .custom("Apple SD Gothic Neo", size: 15)
                                .weight(.medium)
                            )
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                    }
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: 0.97, green: 0.97, blue: 0.97))
                .frame(width: 320, height: 50)
                .overlay(
                    HStack {
                        Image(systemName: "lock")
                            .padding(.leading, 10)
                        SecureField("Password", text: $password)
                            .font(
                                .custom("Apple SD Gothic Neo", size: 15)
                                .weight(.medium)
                            )
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                        //MARK: - https://medium.com/@chinthaka01/swiftui-show-hide-password-text-input-field-86fc8fea4660 있긴한데 귀찮아서 생각좀
//                        Image(systemName: "eye.slash")
//                            .resizable()
//                            .frame(width: 19, height: 15)
//                            .foregroundStyle(.gray)
//                            .padding(.trailing, 10)
//                            .onTapGesture {
//                                print("test")
//                            }
                    }
                )
            Button(action: {
                print("test")
            }) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 320, height: 50)
                    .overlay(
                        Text("Login")
                            .font(
                                .custom("Apple SD Gothic Neo", size: 15)
                                .weight(.bold)
                            )
                            .foregroundStyle(.white)
                    )
            }
            
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
