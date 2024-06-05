//
//  LoginView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

enum LoginRoute: Hashable {
    case loginPageView
    case signUpPageView
    case nextPageView
    case SchoolEmailView
    case EmailPageView
    case EmailCheckView
    case SignView
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
    
    @Binding var isLoggedin: Bool
    @Binding var showLoginPage: Bool
    
    @Binding var studentID: Int
    @Binding var username: String
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            VStack {
                Image("Login")
                    .padding()
                
                
                Button(action: {
                    navPathFinder.addPath(route: .loginPageView)
                }, label: {
                    Text("로그인")
                })
                
                Button(action: {
                    navPathFinder.addPath(route: .signUpPageView)
                }, label: {
                    Text("회원가입")
                })
                

            }
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .navigationDestination(for: LoginRoute.self) { route in
                switch route {
                case .loginPageView:
                    LoginPageView(isLoggedin: $isLoggedin, showLoginPage: $showLoginPage, studentID: $studentID, username: $username)
                case .signUpPageView:
                    SignUpPageView()
                case .nextPageView:
                    NextPageView()
                case .SchoolEmailView:
                    SchoolEmailPageView()
                case .EmailPageView:
                    EmailPageView()
                case .EmailCheckView:
                    EmailCheckView()
                case .SignView:
                    SignView()
                }
            }
        }
        .accentColor(.black)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedin: .constant(false), showLoginPage: .constant(true), studentID: .constant(0), username: .constant(""))
            .environmentObject(LoginNavigationPathFinder.shared)
    }
}
