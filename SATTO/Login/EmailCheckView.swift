//
//  EmailCheckView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct EmailCheckView: View {
    @State private var isButtonPressed = false
    @State private var shouldNavigate = false
    @State private var success = false

    
    let schoolId: Int = 201910914
    
    var body: some View {
        VStack {
            Image(systemName: success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
                .padding(.top, 150)
            
            Text(success ? "안녕하세요, 슴우님!\n인증이 완료됐어요 :)" : "학교 이메일로 들어가\n인증을 완료해 주세요.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            if !success && isButtonPressed {
                Text("인증이 통과되지 않은 계정입니다.\n학교 이메일 인증을 진행해 주세요.")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                // Action for the button
                isButtonPressed = true
                // Simulate checking the auth status
                success = Bool.random()
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        shouldNavigate = true
                    }
                }
            }) {
                Text("확인했어요")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .frame(width: 365, height: 50)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.top, 250)
            .navigationBarTitle("", displayMode: .inline)
            
            NavigationLink(destination: Text("Sign View"), isActive: $shouldNavigate) {
                EmptyView()
            }
        }
    }
}

#Preview {
    EmailCheckView()
}
