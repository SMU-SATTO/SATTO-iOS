//
//  SignView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct SignView: View {
    let schoolId: Int = 201910914
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    @State private var passwordError = ""
    @State private var nickname = ""
    @State private var isButtonPressed = false
    @State private var isNicknameEnabled = false
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var navigateToLogin = false
    
    
    var body: some View {
        VStack {
            Text("이제 회원가입을\n완료해 주세요.")
                .font(.title)
                .foregroundColor(.black)
                .padding(.vertical, 20)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(schoolId)@sangmyung.kr")
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(width: 365, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray)
                )
                .padding(.bottom, 30)
            
            if !passwordError.isEmpty {
                Text(passwordError)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.trailing, 20)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            SecureField("비밀번호", text: $password)
                .padding()
                .frame(width: 365, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray)
                )
            
            SecureField("비밀번호 재입력", text: $confirmPassword)
                .padding()
                .frame(width: 365, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray)
                )
            
            Text("비밀번호는 숫자/영문자 혼합 6자 이상으로 작성해 주세요.")
                .font(.caption)
                .foregroundColor(.black)
                .padding(.bottom, 50)
                .padding(.leading, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !isNicknameEnabled && isButtonPressed {
                Text("중복된 닉네임입니다.")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.trailing, 20)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack {
                TextField("닉네임", text: $nickname)
                    .padding()
                    .frame(width: 250, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray)
                    )
                Button(action: {
                    checkNickname()
                }) {
                    Text("중복 확인")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .frame(width: 89, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(isNicknameEnabled ? Color.orange : Color.gray)
                        )
                }
                .disabled(nickname.isEmpty)
            }
            
            Spacer()
            
            Button(action: {
                validatePasswords()
                
                if shouldEnableConfirmationButton {
                    registerUser()
                }
            }) {
                Text("확인")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 365, height: 50)
                    .background(shouldEnableConfirmationButton ? Color.orange : Color.gray)
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("회원가입 성공"),
                message: Text("회원가입이 성공적으로 완료되었습니다!"),
                dismissButton: .default(Text("확인")) {
                    navigateToLogin = true
                }
            )
        }
    }
    
    var shouldEnableConfirmationButton: Bool {
        return passwordsMatch && passwordMeetsCriteria(password) && isNicknameEnabled
    }
    
    func validatePasswords() {
        if password.isEmpty || confirmPassword.isEmpty {
            passwordError = "비밀번호를 입력해 주세요."
        } else if password != confirmPassword {
            passwordsMatch = false
            passwordError = "비밀번호와 재입력한 비밀번호가 일치하지 않습니다."
        } else if !passwordMeetsCriteria(password) {
            passwordError = "비밀번호 규칙을 확인해 주세요."
        } else {
            passwordsMatch = true
            passwordError = ""
        }
    }
    
    func passwordMeetsCriteria(_ password: String) -> Bool {
        let containsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        let count = password.count >= 6
        
        return containsNumber && containsLetter && count
    }
    
    func checkNickname() {
        // Simulate checking nickname availability
        isButtonPressed = true
        isNicknameEnabled = nickname != "taken"
    }
    
    func registerUser() {
        // Simulate user registration
        showAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            navigateToLogin = true
//            navigationPath.removeLast(navigationPath.count)
        }
    }
}

#Preview {
    SignView()
}
