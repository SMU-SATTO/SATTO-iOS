//
//  EditProfileView.swift
//  SATTO
//
//  Created by 황인성 on 8/27/24.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var navPathFinder: SettingNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("개인정보 수정을\n완료해 주세요.")
                            .font(.title)
                        
                        Text("이름")
                        TextField("이름 입력", text: $authViewModel.user.name)
                            .modifier(MyTextFieldModifier())
                            .padding(.bottom, 8)
                        
                        Text("닉네임")
                        TextField("닉네임 입력", text: $authViewModel.user.nickname)
                            .modifier(MyTextFieldModifier())
                            .padding(.bottom, 8)
                        
                        Text("학과")
                        Picker(selection: $authViewModel.user.department, label: Text("department")) {
                            if authViewModel.user.department.isEmpty {
                                Text("선택").tag("")
                            }
                            Text("컴퓨터과학전공").tag("컴퓨터과학전공")
//                            Text("융합전자공학과").tag("융합전자공학과")
                        }
                        .tint(Color.cellText)
                        
                        Text("학년")
                        Picker(selection: $authViewModel.user.grade, label: Text("grade")) {
                            if authViewModel.user.grade == 0 {
                                Text("선택").tag(0)
                            }
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                        }
                        .tint(Color.cellText)
                    }
                }
                .padding(.horizontal, 20)
                .foregroundStyle(Color.cellText)
                
                Spacer()
                
                Button(action: {
                    authViewModel.editProfile(user: authViewModel.user) {
                        navPathFinder.path.popLast()
                    }
                }, label: {
                    Text("확인")
                        .modifier(MyButtonModifier(isDisabled: false))
                })
                .disabled(false)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackButton()
                }
            }
        }
    }
}
