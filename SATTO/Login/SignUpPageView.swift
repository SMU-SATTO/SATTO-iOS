//
//  SignUpPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

import SwiftUI

struct SignUpPageView: View {
    @State var isChecked: Bool = false
    @State var Checked: Bool = false
    @State private var isTextBoxVisible = false
    
    var body: some View {
        VStack {
            Text("반가워요! 가입하려면\n\n약관에 동의해주세요 :)")
                .font(.headline)
                .padding()
            
            HStack {
                Button(action: {
                    isChecked = !isChecked
                }, label: {
                    Image(systemName: isChecked ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
                
                Text("개인정보 수집 이용 동의 (필수)")
                    .font(.body)
                    .padding(.leading, 10)
                
                Button(action: {
                    Checked = !Checked
                    isTextBoxVisible.toggle()
                }, label: {
                    Image(systemName: Checked ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 15, height: 15)
                })
                .padding()
            }
            
            if isTextBoxVisible {
                Image(systemName: "doc.text")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            Spacer()
            
            NavigationLink(
                destination: Text("School Email Page"),
                label: {
                    Text("확인")
                        .foregroundColor(isChecked ? Color.white : Color.gray)
                        .font(.headline)
                        .frame(width: 365, height: 50)
                        .background(isChecked ? Color.orange : Color.gray)
                        .cornerRadius(10)
                }).disabled(!isChecked)
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}







#Preview {
    SignUpPageView()
        .environmentObject(NavigationPathFinder.shared)
}
