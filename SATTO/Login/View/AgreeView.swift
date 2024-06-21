//
//  SignUpPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

import SwiftUI

struct AgreeView: View {
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
//    @ObservedObject var vm: AuthVieModel
//    @EnvironmentObject var authViewModel: AuthVieModel
    @State var isChecked0: Bool = false
    @State var isChecked1: Bool = false
    @State var isChecked2: Bool = false
    @State var isChecked3: Bool = false
    @State var isChecked4: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                
                Text("SATTO 이용을 위해\n이용약관에 동의해 주세요")
                    .font(.sb30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 40)
                
                Button(action: {
                    if isChecked0 == true {
                        isChecked0 = false
                        isChecked1 = false
                        isChecked2 = false
                        isChecked3 = false
                        isChecked4 = false
                    }
                    else if isChecked0 == false {
                        isChecked0 = true
                        isChecked1 = true
                        isChecked2 = true
                        isChecked3 = true
                        isChecked4 = true
                    }
                }, label: {
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked0 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        
                        Text("이용약관 전체 동의")
                    }
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
                .padding(.bottom, 47)
                
                Button(action: {
                    isChecked1.toggle()
                    if isChecked1 && isChecked2 && isChecked3 && isChecked4 == true {
                        isChecked0 = true
                    }
                }, label: {
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked1 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        
                        Text("(필수) 개인정보처리방침을 읽고 숙지하였습니다")
                            .font(.m14)
                        
                        Spacer()
                        
                        Image("icRight")
                    }
                    
                })
                .padding(.bottom, 16)
                
                Button(action: {
                    isChecked2.toggle()
                    if isChecked1 && isChecked2 && isChecked3 && isChecked4 == true {
                        isChecked0 = true
                    }
                }, label: {
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked2 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        
                        Text("(필수) 개인정보 수집 및 이용 동의")
                            .font(.m14)
                        
                        Spacer()
                        
                        Image("icRight")
                    }
                    
                })
                .padding(.bottom, 16)
                
                Button(action: {
                    isChecked3.toggle()
                    if isChecked1 && isChecked2 && isChecked3 && isChecked4 == true {
                        isChecked0 = true
                    }
                }, label: {
                    
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked3 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        
                        Text("(필수) 이용약관 동의")
                            .font(.m14)
                        
                        Spacer()
                        
                        Image("icRight")
                    }
                })
                .padding(.bottom, 16)
                
                Button(action: {
                    isChecked4.toggle()
                    if isChecked1 && isChecked2 && isChecked3 && isChecked4 == true {
                        isChecked0 = true
                    }
                }, label: {
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked4 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        
                        Text("(선택) 개인정보 제 3자 제공 동의")
                            .font(.m14)
                        
                        Spacer()
                        
                        Image("icRight")
                    }
                    
                })
                
                Spacer()
                
                Button(action: {
                    navPathFinder.addPath(route: .EmailAuthView)
                }, label: {
                    Text("다음")
                      .foregroundColor(Color(red: 0.57, green: 0.61, blue: 0.65))
                      .padding(.vertical, 16)
                      .frame(maxWidth: .infinity)
                      .background(
                              RoundedRectangle(cornerRadius: 20)
                                .fill(!(isChecked1 && isChecked2 && isChecked3) ? Color.white: Color.blue)
                      )
                      .overlay(
                          RoundedRectangle(cornerRadius: 20)
                              .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                      )
                })
                .disabled(!(isChecked1 && isChecked2 && isChecked3))
                
                
            }
            .padding(.horizontal, 20)
        }
        
    }
}







#Preview {
    AgreeView()
        .environmentObject(NavigationPathFinder.shared)
}
