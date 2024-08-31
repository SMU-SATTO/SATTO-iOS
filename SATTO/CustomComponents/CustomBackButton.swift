//
//  CustomBackButton.swift
//  SATTO
//
//  Created by 황인성 on 7/16/24.
//

import Foundation
import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image("Classic")
                .renderingMode(.template)
                .foregroundStyle(.backButton)
            
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
