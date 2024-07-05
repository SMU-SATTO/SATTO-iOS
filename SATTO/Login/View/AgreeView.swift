//
//  SignUpPageView.swift
//  SATTO
//
//  Created by 황인성 on 5/31/24.
//

import SwiftUI

struct AgreeView: View {
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    @State private var isChecked0: Bool = false
    @State private var isChecked1: Bool = false
    @State private var isChecked2: Bool = false
    @State private var isChecked3: Bool = false
    @State private var isChecked4: Bool = false
    
    private let terms = [
        "(필수) 개인정보처리방침을 읽고 숙지하였습니다",
        "(필수) 개인정보 수집 및 이용 동의",
        "(필수) 이용약관 동의",
        "(선택) 개인정보 제 3자 제공 동의"
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("SATTO 이용을 위해\n이용약관에 동의해 주세요")
                    .font(.sb30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 40)
                
                Button(action: {
                    toggleAllCheckboxes()
                }, label: {
                    HStack(spacing: 0) {
                        Image("Tick Square")
                            .renderingMode(.template)
                            .foregroundStyle(isChecked0 ? Color.blue : Color.gray)
                            .padding(.trailing, 10)
                        Text("이용약관 전체 동의")
                    }
                    .frame(maxWidth: .infinity)
                    .modifier(MyTextFieldModifier())
                })
                .padding(.bottom, 47)
                
                ForEach(0..<terms.count, id: \.self) { index in
                    HStack(spacing: 0) {
                        Button(action: {
                            toggleCheckbox(index: index + 1)
                        }, label: {
                            HStack(spacing: 0) {
                                Image("Tick Square")
                                    .renderingMode(.template)
                                    .foregroundStyle(isChecked(for: index) ? Color.blue : Color.gray)
                                    .padding(.trailing, 10)
                                Text(terms[index])
                                    .font(.m14)
                            }
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            // 여기에 필요한 작업 추가
                        }, label: {
                            Image("icRight")
                        })
                    }
                    .padding(.bottom, 16)
                }

                Spacer()
                
                Button(action: {
                    navPathFinder.addPath(route: .EmailAuthView)
                }, label: {
                    Text("다음")
                        .modifier(MyButtonModifier(isDisabled: !(isChecked1 && isChecked2 && isChecked3)))
                })
                .disabled(!(isChecked1 && isChecked2 && isChecked3))
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func toggleAllCheckboxes() {
        isChecked0.toggle()
        let newValue = isChecked0
        isChecked1 = newValue
        isChecked2 = newValue
        isChecked3 = newValue
        isChecked4 = newValue
    }
    
    private func toggleCheckbox(index: Int) {
        switch index {
        case 1:
            isChecked1.toggle()
        case 2:
            isChecked2.toggle()
        case 3:
            isChecked3.toggle()
        case 4:
            isChecked4.toggle()
        default:
            break
        }
        isChecked0 = isChecked1 && isChecked2 && isChecked3 && isChecked4
    }
    
    private func isChecked(for index: Int) -> Bool {
        switch index {
        case 0:
            return isChecked1
        case 1:
            return isChecked2
        case 2:
            return isChecked3
        case 3:
            return isChecked4
        default:
            return false
        }
    }
}




struct AgreeView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginNavigationPathFinder.shared)
    }
}
