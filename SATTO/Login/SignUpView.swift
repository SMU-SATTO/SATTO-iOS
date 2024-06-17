//
//  SignView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct SignUpView: View {
    let schoolId = "201910914"
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
    
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이제 회원가입을\n완료해 주세요.")
                .font(.title)
            
            Text("아이디")
            
            Text("\(schoolId)@sangmyung.kr")
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                    
                )
            
            Text("비밀번호")
            
            SecureField("비밀번호", text: $password)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                    
                )
            
            SecureField("비밀번호 재입력", text: $confirmPassword)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                    
                )
            
            Text("비밀번호는 숫자/영문자 혼합 6자 이상으로 작성해 주세요.")
                .font(.caption)
                .foregroundColor(.black)
                .padding(.bottom, 50)
                .padding(.leading, 15)
//                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("학과")
            
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
            }
            
            Text("계정 공개 / 비공개")
            
            HStack(spacing: 10) {
                Text("공개")
                .padding(.vertical, 16)
                                    .padding(.horizontal, 20)
                                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                                        
                                    )
                
                Text("비공개")
                .padding(.vertical, 16)
                                    .padding(.horizontal, 20)
                                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                                        
                                    )
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
        .padding(.horizontal, 20)
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
    SignUpView()
        .environmentObject(NavigationPathFinder.shared)
}
