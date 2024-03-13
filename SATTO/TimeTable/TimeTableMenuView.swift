//
//  TimeTableMenuView.swift
//  SATTO
//
//  Created by 김영준 on 3/14/24.
//

import SwiftUI

struct TimeTableMenuView: View {
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            isMenuOpen.toggle()
                        }) {
                            Text("Menu Item 1")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        
                        Button(action: {
                            // Handle button action
                        }) {
                            Text("Menu Item 2")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .padding(.trailing, isMenuOpen ? 0 : -250) // Slide out animation
                }
                Spacer()
            }
            .offset(x: isMenuOpen ? 0 : UIScreen.main.bounds.width)
            .animation(.easeInOut)
            // Button to open the menu
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isMenuOpen.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    TimeTableMenuView(isMenuOpen: .constant(true))
}
