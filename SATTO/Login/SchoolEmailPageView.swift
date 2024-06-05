//
//  SchoolEmailPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct SchoolEmailPageView: View {

    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
                .padding(.top, 150)

            Text("회원가입을 위해\n학교 이메일 인증이 필요해요.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            NavigationLink(
                destination: Text("Email Page View"),
                label: {
                    Text("이메일 인증하러 가기")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .frame(width: 365, height: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                })
            .navigationBarTitle("", displayMode: .inline)
            .padding(.top, 250)
        }
    }
}

#Preview {
    SchoolEmailPageView()
}
