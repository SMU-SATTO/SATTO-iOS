//
//  NextPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct EmailAuthView: View {
    @State private var studentId = ""
    @State private var authNumber = ""
    @State private var isEmailEnabled = false
    //    @ObservedObject var vm: AuthVieModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    
//    @State var isCheckedEmailDuplicate = false
//    @State var isCheckedsendAuthNumber = true
//    @State var isCheckedAuthNumber = true
    
    var body: some View {
        ZStack {
            //            Color(red: 0.98, green: 0.98, blue: 0.98)
            //                .ignoresSafeArea()
            
            if authViewModel.isCheckedsendAuthNumberLoading == true {
                ProgressView()
                    .zIndex(1)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("아이디로 사용할\n학번을 입력해 주세요")
                    .padding(.bottom, 16)
                
                HStack(spacing: 0) {
                        TextField("이메일 주소 입력", text: $studentId)
                            .modifier(MyTextFieldModifier())
                            .disabled(authViewModel.isCheckedEmailDuplicate)
                            .padding(.trailing, 8)

                    Text("@sangmyung.kr")
                }
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.checkEmailDuplicate(studentId: studentId)
//                    isCheckedEmailDuplicate = true
//                    isCheckedsendAuthNumber = false
                }, label: {
                    Text("학번 중복확인")
                        .modifier(MyButtonModifier(isDisabled: authViewModel.isCheckedEmailDuplicate))
                })
                .disabled(authViewModel.isCheckedEmailDuplicate)
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.sendAuthNumber(studentId: studentId)
                    print("학번 저장")
                    authViewModel.user?.studentId = "201910914"
//                    print(authViewModel.user?.studentId ?? "known")
//                    authViewModel.isCheckedsendAuthNumber = true
//                    authViewModel.isCheckedAuthNumber = false
                }, label: {
                    Text("인증번호 전송")
                        .modifier(MyButtonModifier(isDisabled: authViewModel.isCheckedsendAuthNumber))
                })
                .disabled(authViewModel.isCheckedsendAuthNumber)
                .padding(.bottom, 30)
                
                
                Text("인증번호를 입력해주세요")
                    .padding(.bottom, 16)
                
                TextField("인증번호 입력", text: $authNumber)
                    .modifier(MyTextFieldModifier())
                    .padding(.bottom, 16)
                
                Text("메일이 가지 않았다면 정크메일함을 확인해보세요")
                    .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.checkAuthNumber(certificationNum: authNumber)
                }, label: {
                    Text("인증번호 확인")
                        .modifier(MyButtonModifier(isDisabled: authViewModel.isCheckedAuthNumber))
                })
                .disabled(authViewModel.isCheckedAuthNumber)
                
                Spacer()
                
                Button(action: {

                    if var user = authViewModel.user {
                        user.studentId = studentId
                        authViewModel.user = user
                        
                    }
                    
                    navPathFinder.addPath(route: .SignUpView)
                    
                }, label: {
                    Text("다음")
                        .modifier(MyButtonModifier(isDisabled: !(authViewModel.isCheckedEmailDuplicate && authViewModel.isCheckedsendAuthNumber && authViewModel.isCheckedAuthNumber)))
                })
                .disabled(!(authViewModel.isCheckedEmailDuplicate && authViewModel.isCheckedsendAuthNumber && authViewModel.isCheckedAuthNumber))
            }
            .padding(.horizontal, 20)
        }
        .alert("이미 가입된 학번입니다", isPresented: $authViewModel.studentIdDuplicateAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("인증번호가 틀렸습니다", isPresented: $authViewModel.authNumIsWrongAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            print("EmailAuthView 나타남")
        }
        .onDisappear {
            print("EmailAuthView 사라짐")
        }
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginNavigationPathFinder.shared)
    }
}
