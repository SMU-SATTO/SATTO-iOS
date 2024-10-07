//
//  STPopup.swift
//  SATTO
//
//  Created by yeongjoon on 10/7/24.
//

/// use:
/// .STpopup(isPresented: $isPresented) {
///        View()
/// }
///

import SwiftUI

struct STPopupModifier<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: () -> PopupContent
    
    @State private var backgroundOpacity: Double = 0.0
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.clear
                        .background(.ultraThinMaterial)
                        .opacity(backgroundOpacity)
                        .ignoresSafeArea(.all)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                backgroundOpacity = 1.0
                            }
                        }
                        .onDisappear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                backgroundOpacity = 0.0
                            }
                        }
                    popupContent()
                        .background(ClearBackground())
                        .offset(y: yOffset)
                        .onAppear {
                            withAnimation(.spring()) {
                                yOffset = 0
                            }
                        }
                }
            }
            .onChange(of: isPresented) { _ in
                UIView.setAnimationsEnabled(false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIView.setAnimationsEnabled(true)
                }
            }
            .onAppear {
                UIScrollView.appearance().isScrollEnabled = true
            }
    }
}

extension View {
    func STPopup<PopupContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> PopupContent) -> some View {
        self.modifier(STPopupModifier(isPresented: isPresented, popupContent: content))
    }
}

public struct ClearBackground: UIViewRepresentable {
    public func updateUIView(_ uiView: UIView, context: Context) {}
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
}
