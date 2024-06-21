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
    @EnvironmentObject var authViewModel: AuthVieModel
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("아이디로 사용할\n학번을 입력해 주세요")
                  .foregroundColor(Color(red: 0.1, green: 0.11, blue: 0.12))
//                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.bottom, 16)

                HStack(spacing: 0) {
                    TextField("이메일 주소 입력", text: $studentId)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                            
                        )
                        .padding(.trailing, 8)
                    
                    
                        Text("@sangmyung.kr")
                }
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.checkEemailDuplicate(studentId: studentId)
                }, label: {
                    Text("학번 중복확인")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                        )
                })
                .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.sendAuthNumber(studentId: studentId)
                    authViewModel.user?.studentId = studentId
                    print(authViewModel.user?.studentId ?? "known")
                }, label: {
                    Text("인증번호 전송")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                        )
                })
                .padding(.bottom, 30)
                
                
                Text("인증번호를 입력해주세요")
                    .padding(.bottom, 16)
                
                TextField("이메일 주소 입력", text: $authNumber)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                        
                    )
                    .padding(.bottom, 16)
                
                Text("메일이 가지 않았다면 정크메일함을 확인해보세요")
                    .padding(.bottom, 16)
                
                Button(action: {
                    authViewModel.checkAuthNumber(certificationNum: authNumber)
                }, label: {
                    Text("인증번호 확인")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                        )
                })

                Spacer()
                
                Button(action: {
                    navPathFinder.addPath(route: .SignUpView)
                }, label: {
                    Text("다음")
                      .foregroundColor(Color(red: 0.57, green: 0.61, blue: 0.65))
                      .padding(.vertical, 16)
                      .frame(maxWidth: .infinity)
                      .background(
                              RoundedRectangle(cornerRadius: 20)
                                  .fill(Color.white)
                      )
                      .overlay(
                          RoundedRectangle(cornerRadius: 20)
                              .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                      )
                })
            }
            .padding(.horizontal, 20)
            .onReceive([studentId].publisher.collect()) { values in
                isEmailEnabled = values.allSatisfy { email in
                    let regex = #"^\d{9}@sangmyung\.kr$"#
                    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
                }
        }
        }
    }
}

#Preview {
    EmailAuthView()
        .environmentObject(NavigationPathFinder.shared)
}
