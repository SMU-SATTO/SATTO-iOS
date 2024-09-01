//
//  EditPasswordView.swift
//  SATTO
//
//  Created by 황인성 on 8/27/24.
//

import SwiftUI
import Combine

struct EditPasswordView: View {
    
    @State private var password = ""
    @State private var isPasswordValid: Bool = false
    @State private var confirmPassword = ""
    @State private var passwordsMatch: Bool = false
    @State private var passwordError = ""
    
    @EnvironmentObject var navPathFinder: SettingNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("비밀번호 수정을\n완료해 주세요.")
                        .font(.title)
                    
                    Text("비밀번호")
                    SecureField("비밀번호", text: $password)
                        .modifier(MyTextFieldModifier())
                    SecureField("비밀번호 재입력", text: $confirmPassword)
                        .modifier(MyTextFieldModifier())
                    Text("비밀번호는 숫자/영문자 혼합 6자 이상으로 작성해 주세요.")
                        .font(.caption)
                        .foregroundColor(isPasswordValid == false ? .red : Color.cellText)
                    Text(passwordError)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
                .onChange(of: password) { _ in
                    validatePasswords()
                    confirmPasswordMatch()
                    print(isPasswordValid)
                }
                .onChange(of: confirmPassword) { _ in
                    confirmPasswordMatch()
                    print(passwordsMatch)
                }
            }
            .foregroundStyle(Color.cellText)
            
            Spacer()
            
            Button(action: {
                authViewModel.editPassword(password: confirmPassword) {
                    navPathFinder.path.popLast()
                }
            }, label: {
                Text("확인")
                    .modifier(MyButtonModifier(isDisabled: disabledCondition()))
            })
            .disabled(disabledCondition())
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton()
            }
        }
    }
    
    func validatePasswords() {
        if !passwordMeetsCriteria(password) {
            isPasswordValid = false
        } else {
            isPasswordValid = true
        }
    }
    
    func confirmPasswordMatch() {
        if password == confirmPassword {
            passwordError = ""
            passwordsMatch = true
        } else {
            passwordError = "비밀번호가 일치하지 않습니다"
            passwordsMatch = false
        }
    }
    
    func passwordMeetsCriteria(_ password: String) -> Bool {
        let containsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        let count = password.count >= 6
        
        return containsNumber && containsLetter && count
    }
    
    func disabledCondition() -> Bool {
        var disabled = !passwordsMatch || !isPasswordValid
        return disabled
    }
}
