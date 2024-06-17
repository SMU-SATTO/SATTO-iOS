//
//  LoginView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

enum LoginRoute: Hashable {
    case AgreeView
    case EmailAuthView
    case SignUpView
}

final class LoginNavigationPathFinder: ObservableObject {
    static let shared = LoginNavigationPathFinder()
    private init() { }
    
    @Published var path: [LoginRoute] = []
    
    func addPath(route: LoginRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}

struct LoginView: View {
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            VStack(spacing: 0) {
                
                
                Image("SATTO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                
                
                TextField("이메일 주소 입력", text: $username)
                    .modifier(MyTextFieldModifier())
                    .padding(.bottom, 8)
                
                SecureField("비밀번호 입력", text: $password)
                    .modifier(MyTextFieldModifier())
                    .padding(.bottom, 68)
                
                Button(action: {
                    
                }, label: {
                    Text("로그인")
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .padding(.bottom, 12)
                    
                })
                
                Button(action: {
                    navPathFinder.path.append(.AgreeView)
                }, label: {
                    Text("회원가입")
                        .foregroundStyle(Color(red: 0.3, green: 0.32, blue: 0.34))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                    
                })
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .navigationDestination(for: LoginRoute.self) { route in
                switch route {
                case .AgreeView:
                    AgreeView()
                case .EmailAuthView:
                    EmailAuthView()
                case .SignUpView:
                    SignUpView()
                }
            }
        }
        .accentColor(.black)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginNavigationPathFinder.shared)
    }
}

struct MyTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                
            )
    }
}
