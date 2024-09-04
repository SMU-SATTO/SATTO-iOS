//
//  AgreeView.swift
//  SATTO
//
//  Created by yeongjoon on 8/29/24.
//

import SwiftUI
import UIKit

struct AgreeView: View {
    @EnvironmentObject var navPathFinder: LoginNavigationPathFinder
    
    @State private var isAgree = [false, false, false, false]
    
    @State private var termsOfService: NSAttributedString = NSAttributedString(string: "")
    
    var body: some View {
        VStack {
            HStack {
                Text("약관 동의")
                    .font(.b20)
                    .padding(.leading, 30)
                Spacer()
            }
            .padding(.bottom, 5)
            
            termsSection(
                fileName: "SATTO 서비스 이용약관",
                title: "서비스 이용약관 동의하기 (필수)",
                index: 0
            )
            
            termsSection(
                fileName: "개인정보 수집 및 이용 동의",
                title: "개인정보 수집 및 이용 동의 (필수)",
                index: 1
            )
            
            termsSection(
                fileName: "본인 명의 동의",
                title: "본인 명의를 이용하여 가입을 진행하겠습니다.",
                index: 2
            )
            .frame(height: 100)
            
            termsSection(
                fileName: "만 14세 이상 동의",
                title: "만 14세 이상입니다.",
                index: 3
            )
            .frame(height: 70)
            
            Button(action: {
                navPathFinder.addPath(route: .EmailAuthView)
            }, label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 320, height: 60)
                    .foregroundStyle(isAllAgreed() ? .blue : .blackWhite400)
                    .overlay(
                        Text("다음으로")
                            .font(.m20)
                            .foregroundStyle(.white)
                    )
                
            })
            .disabled(!isAllAgreed())
            .padding(.bottom, 10)
        }
    }
    
    private func termsSection(fileName: String, title: String, index: Int) -> some View {
        VStack {
            TermsAgreementView(
                isAgree: $isAgree[index],
                title: title
            )
            .padding(.leading, 20)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blackWhite600, lineWidth: 1.5)
                .overlay(
                    TermsWebView(fileName: fileName)
                        .edgesIgnoringSafeArea(.all)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                )
                .padding(.horizontal, 20)
        }
    }
    
    private func isAllAgreed() -> Bool {
        return !isAgree.contains(false)
    }
}

struct TermsAgreementView: View {
    @Binding var isAgree: Bool
    let title: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    isAgree.toggle()
                }, label: {
                    HStack {
                        if isAgree {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blackWhite)
                        } else {
                            Image(systemName: "circle")
                                .foregroundStyle(.blackWhite)
                        }
                        Text(title)
                            .font(.m16)
                            .foregroundStyle(.blackWhite)
                    }
                })
            }
            Spacer()
        }
    }
}

import WebKit

struct TermsWebView: UIViewRepresentable {
    let fileName: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            let request = URLRequest(url: fileURL)
            uiView.load(request)
        }
    }
}


#Preview {
    AgreeView()
}
