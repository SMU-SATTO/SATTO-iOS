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
    case PasswordResetView
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
    
    @State private var studentId: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var isDisabled = false
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {

                    Text("SATTO")
                        .font(.largeTitle)
                        .padding(.vertical, 70)
                    
                    TextField("학번만 입력", text: $studentId)
                        .modifier(MyTextFieldModifier())
                        .padding(.bottom, 8)
                    
                    SecureField("비밀번호 입력", text: $password)
                        .modifier(MyTextFieldModifier())
                        .padding(.bottom, 68)
                    
                    Button(action: {
                        authViewModel.logIn(email: "\(studentId)@sangmyung.kr", password: password)
                    }, label: {
                        Text("로그인")
                            .modifier(MyButtonModifier(isDisabled: disabledCondition()))
                    })
                    .disabled(disabledCondition())
                    .padding(.bottom, 12)
                    
                    Button(action: {
                        navPathFinder.path.append(.AgreeView)
                    }, label: {
                        Text("회원가입")
                            .foregroundStyle(Color(red: 0.3, green: 0.32, blue: 0.34))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 0.3, green: 0.32, blue: 0.34), lineWidth: 1)
                            )
                    })
                    .padding(.bottom, 12)
                    
                    Button(action: {
                        navPathFinder.addPath(route: .PasswordResetView)
                    }, label: {
                        Text("비밀번호 찾기")
                    })
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .alert("아이디 또는 비밀번호가 틀렸습니다.", isPresented: $authViewModel.LogInFailAlert) {
                    Button("OK", role: .cancel) { }
                }
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .AgreeView:
                        AgreeView()
                    case .EmailAuthView:
                        EmailAuthView()
                    case .SignUpView:
                        SignUpView()
                    case .PasswordResetView:
                        PasswordResetView()
                    }
                }
            }
        }
    }
    // 로그인버튼 활성 조건
    func disabledCondition() -> Bool {
        var disabled = studentId.isEmpty || password.isEmpty
        return disabled
    }
}

struct MyTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.textField.opacity(0.7))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.textField, lineWidth: 1)
            )
    }
}

struct MyButtonModifier: ViewModifier {
    
    var isDisabled: Bool
    
    func body(content: Content) -> some View{
        content
            .foregroundStyle(Color.white)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(isDisabled ? Color.gray : Color.blue)
            .cornerRadius(20)
    }
}
