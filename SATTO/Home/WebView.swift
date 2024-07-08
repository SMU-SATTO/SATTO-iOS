//
//  WebView.swift
//  SATTO
//
//  Created by 황인성 on 7/7/24.
//

import SwiftUI
import SafariServices

struct SFSafariViewPractice: View {
    @State var showSafari = false
    @State var urlString = "https://www.smu.ac.kr/kor/life/notice.do"

    var body: some View {
        Button(action: {
//            self.urlString = "https://www.smu.ac.kr/kor/life/notice.do"
            self.showSafari = true
        }) {
            Text("SFSafariView로 보여주기")
        }
        .fullScreenCover(isPresented: $showSafari) {
            SafariView(url:URL(string: self.urlString)!)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

#Preview {
    SFSafariViewPractice()
}
