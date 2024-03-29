//
//  SearchView.swift
//  SATTO
//
//  Created by 황인성 on 3/26/24.
//

import SwiftUI

struct SearchView: View {
    
    @State var text = ""
    
    var body: some View {
        
        VStack(spacing: 0){
            ClearButtonTextField(placehold: "팔로잉 목록", text: $text)
                .padding(.horizontal, 20)

            Spacer()
            ScrollView {
                ForEach(0 ..< 10) { item in
                    FriendCell(name: "한민재", studentID: 20201499, isFollowing: false)
                        .padding(.bottom, 25)
                }
            }
//            .padding(.horizontal, 20)
        }
//        .padding(.horizontal, 20)
    }
}



struct ClearButtonTextField: View {
    
    var placehold: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            
            Image("seachIcon.gray")
                .padding(.horizontal, 12)
            
            TextField(placehold, text: $text)
            
            Spacer()
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image("Icon")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            
        }
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(Color.gray)
                .cornerRadius(30)
        )
    }
}



#Preview {
    SearchView()
}

struct FriendCell: View {
    
    var name: String
    var studentID: Int
    var isFollowing: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 63, height: 63)
                )
                .shadow(radius: 5, x: 0, y: 5)
                .padding(.trailing, 14)
                .padding(.leading, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                // m16
                Text("20201499")
                    .font(.m2)
                    .foregroundColor(Color.gray800)
                
                // m12
                Text("한민재")
                    .font(.m4)
                    .foregroundColor(Color.gray600)
            }
            
            Spacer()
            
            if isFollowing {
                Text("팔로잉")
                    .font(.m4)
                    .foregroundColor(Color.blue7)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue7, lineWidth: 1)
                            
                    )
                    .padding(.trailing, 20)
            }
            
            else {
                Text("팔로우")
                    .font(.m4)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 26)
                    .background(
                        Rectangle()
                            .fill(Color.blue7)
                            .cornerRadius(10)
                    )
                    .padding(.trailing, 20)
                
            }
            
            
            
        }
    }
}
