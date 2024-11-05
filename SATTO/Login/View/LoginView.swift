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
    
    @FocusState private var isFocused: Bool

    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                  
                ScrollView {
                    VStack(spacing: 0) {
                        
                        Text("SATTO")
                            .font(.largeTitle)
                            .padding(.vertical, 70)
                        
                        TextField("학번만 입력", text: $studentId)
                            .focused($isFocused)
                            .modifier(MyTextFieldModifier())
                            .padding(.bottom, 8)
                            .keyboardType(.numberPad)
                            
                        
                        SecureField("비밀번호 입력", text: $password)
                            .focused($isFocused)
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
                        
                        HStack(spacing: 10) {
                            Button(action: {
                                navPathFinder.addPath(route: .PasswordResetView)
                            }, label: {
                                Text("비밀번호 찾기")
                            })
                            
                            Rectangle()
                                .frame(width: 1, height: 10)
                            
                            Button(action: {
                                navPathFinder.path.append(.AgreeView)
                            }, label: {
                                Text("회원가입")
                            })
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 20)
                }
                .toolbar { // 키보드 툴바 설정
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // 우측 정렬을 위한 Spacer
                        Button("완료") { // 키보드 숨기기 버튼
                            isFocused = false // 포커스 해제하여 키보드 숨기기
                        }
                        .foregroundColor(.blue)
                    }
                }
//                .gesture(
//                    DragGesture()
//                        .onChanged { _ in
//                            hideKeyboard()
//                        }
//                )
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
