//
//  SignView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI
import Combine

struct SignUpView: View {
    
    @State private var password = ""
    @State private var isPasswordValid: Bool = false
    @State private var confirmPassword = ""
    @State private var passwordsMatch: Bool = false
    @State private var passwordError = ""
    @State private var name = ""
    @State private var nickname = ""
    @State private var department = ""
    @State private var grade = 0
    @State private var isPublic = true
    
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("이제 회원가입을\n완료해 주세요.")
                        .font(.title)
                    
                    Text("아이디")
                    Text("\(authViewModel.user.studentId)@sangmyung.kr")
                        .frame(maxWidth: .infinity)
                        .modifier(MyTextFieldModifier())
                    
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
                        if department.isEmpty {
                            Text("선택").tag("")
                        }
                        Text("컴퓨터과학전공").tag("컴퓨터과학전공")
//                        Text("융합전자공학과").tag("융합전자공학과")
                    }
                    
                    Text("학년")
                    Picker(selection: $grade, label: Text("grade")) {
                        if grade == 0 {
                            Text("선택").tag(0)
                        }
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }
                    
                    Text("계정 공개 / 비공개")
                    HStack(spacing: 10) {
                        Button(action: {
                            isPublic = true
                        }, label: {
                            Text("공개")
                                .modifier(MyTextFieldModifier())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(isPublic ? Color.blue : Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                                )
                        })
                        
                        Button(action: {
                            isPublic = false
                        }, label: {
                            Text("비공개")
                                .modifier(MyTextFieldModifier())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(!isPublic ? Color.blue : Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                                )
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 뷰의 변수를 뷰모델로 전달
                        authViewModel.user.email = "\(authViewModel.user.studentId ?? "asd")@sangmyung.kr"
                        authViewModel.user.password = password
                        authViewModel.user.name = name
                        authViewModel.user.nickname = nickname
                        authViewModel.user.department = department
                        authViewModel.user.grade = grade
                        authViewModel.user.isPublic = isPublic
                        // 회원가입
                        authViewModel.signUp(user: authViewModel.user) {
                            navPathFinder.popToRoot()
                        }
                    }, label: {
                        Text("확인")
                            .modifier(MyButtonModifier(isDisabled: disabledCondition()))
                    })
                    .disabled(disabledCondition())
                    .padding(.bottom, 10)
                }
                .padding(.horizontal, 20)
                .foregroundStyle(Color.cellText)
                .navigationBarBackButtonHidden(true)
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
        }
    }
    
    // 비밀번호 규칙 맞는지 확인
    func validatePasswords() {
        if !passwordMeetsCriteria(password) {
            isPasswordValid = false
        } else {
            isPasswordValid = true
        }
    }
    // 재입력 비밀번호가 맞는지
    func confirmPasswordMatch() {
        if password == confirmPassword {
            passwordError = ""
            passwordsMatch = true
        } else {
            passwordError = "비밀번호가 일치하지 않습니다"
            passwordsMatch = false
        }
    }
    // 비밀번호 규칙
    func passwordMeetsCriteria(_ password: String) -> Bool {
        let containsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        let count = password.count >= 6
        
        return containsNumber && containsLetter && count
    }
    // 회원가입 버튼 활성화 조건
    func disabledCondition() -> Bool {
        var disabled = !passwordsMatch || !isPasswordValid || name.isEmpty || nickname.isEmpty || department.isEmpty || grade == 0
        return disabled
    }
}

