//
//  PasswordResetView.swift
//  SATTO
//
//  Created by 황인성 on 9/2/24.
//

import SwiftUI

struct PasswordResetView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    @State private var studentId: String = ""
    @State private var successAlert = false
    @State var failAlert = false
    @State private var alertMessage = ""
    @State var showAlert = false

    var body: some View {
        ZStack {
            
            if authViewModel.isLoading {
                ProgressView()
            }
            
            VStack(spacing: 20) {
                Text("비밀번호 재설정")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("가입한 학번을 입력하시면, 임시 비밀번호를 학교웹메일로 보내드립니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                //            TextField("이메일 주소", text: $studentId)
                //                .textFieldStyle(RoundedBorderTextFieldStyle())
                //                .keyboardType(.emailAddress)
                //                .autocapitalization(.none)
                //                .padding(.horizontal, 40)
                
                TextField("학번만 입력하세요", text: $studentId)
                    .modifier(MyTextFieldModifier())
                //                .disabled(authViewModel.isCheckedEmailDuplicate)
                
                Button(action: {
                    authViewModel.resetPassword(studentId: studentId) { success in
                        if success {
                            successAlert.toggle()
                        }
                        else {
                            failAlert.toggle()
                        }
                    }
                }, label: {
                    Text("임시비밀번호 보내기")
                        .modifier(MyButtonModifier(isDisabled: studentId.isEmpty))
                })
                .disabled(studentId.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .alert("존재하지 않는 학번 입니다.", isPresented: $failAlert) {
            Button("OK", role: .cancel) {
                studentId = ""
            }
        }
        .alert("인증번호 전송", isPresented: $successAlert) {
            Button("OK", role: .cancel) {
                navPathFinder.path.popLast()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton()
            }
        }
    }
    
    // 이메일 유효성 검사를 위한 함수
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}


#Preview {
    PasswordResetView()
}
