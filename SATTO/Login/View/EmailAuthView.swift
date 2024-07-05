//
//  NextPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct EmailAuthView: View {
    @State private var studentId = "201910914"
    @State private var authNumber = ""
    @State private var isEmailEnabled = false
    //    @ObservedObject var vm: AuthVieModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    
    @State var isCheckedEmailDuplicate = false
    @State var isCheckedsendAuthNumber = true
    @State var isCheckedAuthNumber = true
    
    var body: some View {
        ZStack {
            //            Color(red: 0.98, green: 0.98, blue: 0.98)
            //                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("아이디로 사용할\n학번을 입력해 주세요")
                    .padding(.bottom, 16)
                
                HStack(spacing: 0) {
                        TextField("이메일 주소 입력", text: $studentId)
                            .modifier(MyTextFieldModifier())
                            .disabled(isCheckedEmailDuplicate)
                            .padding(.trailing, 8)

                    Text("@sangmyung.kr")
                }
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.checkEmailDuplicate(studentId: studentId)
                    isCheckedEmailDuplicate = true
                    isCheckedsendAuthNumber = false
                }, label: {
                    Text("학번 중복확인")
                        .modifier(MyButtonModifier(isDisabled: isCheckedEmailDuplicate))
                })
                .disabled(isCheckedEmailDuplicate)
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.sendAuthNumber(studentId: studentId)
                    authViewModel.user?.studentId = studentId
                    print(authViewModel.user?.studentId ?? "known")
                    isCheckedsendAuthNumber = true
                    isCheckedAuthNumber = false
                }, label: {
                    Text("인증번호 전송")
                        .modifier(MyButtonModifier(isDisabled: isCheckedsendAuthNumber))
                })
                .disabled(isCheckedsendAuthNumber)
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
                    isCheckedAuthNumber = true
                }, label: {
                    Text("인증번호 확인")
                        .modifier(MyButtonModifier(isDisabled: isCheckedAuthNumber))
                })
                .disabled(isCheckedAuthNumber)
                
                Spacer()
                
                Button(action: {
                    navPathFinder.addPath(route: .SignUpView)
                }, label: {
                    Text("다음")
                        .modifier(MyButtonModifier(isDisabled: !(isCheckedEmailDuplicate && isCheckedsendAuthNumber && isCheckedAuthNumber)))
                })
                .disabled(!(isCheckedEmailDuplicate && isCheckedsendAuthNumber && isCheckedAuthNumber))
            }
            .padding(.horizontal, 20)
        }
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginNavigationPathFinder.shared)
    }
}
