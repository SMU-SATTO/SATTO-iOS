//
//  SignView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI
import Combine

struct SignUpView: View {

    @State private var password = "insungmms57!"
    @State private var confirmPassword = "insungmms57!"
    @State private var passwordsMatch = true
    @State private var passwordError = ""
    @State private var name = "황인성"
    @State private var nickname = "insung"
    @State private var department = "컴퓨터과학과"
    @State private var grade = 3
    @State private var isPublic = true
    
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthVieModel
    
    @State private var isPasswordValid: Bool = false
    @State private var errorMessage: String?
    @State private var cancellable: AnyCancellable?
    
//    @ObservedObject var vm: AuthVieModel
    
    let user = User(studentId: "201910914", password: "insungmms57!", name: "황인성", nickname: "insung", department: "컴퓨터과학과", grade: 3, isPublic: true)
    
    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 16) {
                Text("이제 회원가입을\n완료해 주세요.")
                    .font(.title)
                
                Text("아이디")
                
            Text("\(authViewModel.user?.studentId ?? "unknown")@sangmyung.kr")
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
                    .padding(.bottom, 16)
            
            Text(passwordError)
                .padding(.bottom, 16)
                
                Text("이름")
                
                TextField("이름 입력", text: $name)
                    .modifier(MyTextFieldModifier())
                    .padding(.bottom, 8)
                
                Text("닉네임")
                
                TextField("닉네임 입력", text: $nickname)
                    .modifier(MyTextFieldModifier())
                    .padding(.bottom, 8)
                
                Text("학과")
                
                Picker(selection: $department, label: Text("department")) {
                    Text("컴퓨터과학과").tag("컴퓨터과학과")
                    Text("융합전자공학과").tag("융합전자공학과")
                }
            
            Text("학년")
            
            Picker(selection: $grade, label: Text("grade")) {
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
                Text("4").tag(4)
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
                
                Button(action: {
                    print(authViewModel.user?.studentId)
                    authViewModel.user?.password = password
                    authViewModel.user?.name = name
                    authViewModel.user?.nickname = nickname
                    authViewModel.user?.department = department
                    authViewModel.user?.grade = grade
                    authViewModel.user?.isPublic = isPublic
                    
                    
                    authViewModel.signUp(user: authViewModel.user!)
                }, label: {
                    Text("회원가입 테스트")
                })
                
                Spacer()
                
                Button(action: {
                    validatePasswords()
                    
                    authViewModel.signUp(user: authViewModel.user!)
                }) {
                    Text("확인")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 365, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
            .onChange(of: password) { _ in
//                validatePasswordWithErrorHandling()
//                print(isPasswordValid)
                validatePasswords()
                print(passwordsMatch)
            }
        }
    }
    
//    var shouldEnableConfirmationButton: Bool {
//        return passwordsMatch && passwordMeetsCriteria(password) && isNicknameEnabled
//    }
    
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
    
    func validatePasswordWithErrorHandling() {
        cancellable = Just(password)
            .tryAllSatisfy { value in
                if value.count < 6 {
                    throw NSError(domain: "PasswordError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 8 characters long"])
                }
                //                    if value.rangeOfCharacter(from: .uppercaseLetters) == nil {
                //                        throw NSError(domain: "PasswordError", code: 101, userInfo: [NSLocalizedDescriptionKey: "Password must contain at least one uppercase letter"])
                //                    }
                if value.rangeOfCharacter(from: .lowercaseLetters) == nil {
                    throw NSError(domain: "PasswordError", code: 102, userInfo: [NSLocalizedDescriptionKey: "Password must contain at least one lowercase letter"])
                }
                if value.rangeOfCharacter(from: .decimalDigits) == nil {
                    throw NSError(domain: "PasswordError", code: 103, userInfo: [NSLocalizedDescriptionKey: "Password must contain at least one digit"])
                }
                return true
            }
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { result in
                    isPasswordValid = result
                }
            )
    }
}

//#Preview {
//    SignUpView()
//        .environmentObject(NavigationPathFinder.shared)
//}
