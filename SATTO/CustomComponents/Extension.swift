//
//  extension.swift
//  SATTO
//
//  Created by 황인성 on 10/28/24.
//

import Foundation
import SwiftUI
import KeyboardToolbar

let toolbarItems: [KeyboardToolbarItem] = [
    .dismissKeyboard
]
 
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
