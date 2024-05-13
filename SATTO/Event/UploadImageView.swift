//
//  UploadImageView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct UploadImageView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .frame(height: 0)
            
            Text("이벤트에 참여하기 위해\n학교 사진을 올려주세요!")
                .font(.sb16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 28)
                .padding(.top, 32)
            
            Rectangle()
                .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                .frame(width: 167, height: 173)
                .cornerRadius(10)
                .overlay(
                    VStack(spacing: 0) {
                        Image("union")
                            .padding(.bottom, 14)
                        
                        Text("사진  선택")
                            .font(.m14)
                            .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.5))
                    }
                        .padding(.top, 20)
                    
                )
                .padding(.bottom, 26)
            
            
            Text("욕설, 비방 등 해당 주제와 관련 없는 내용은 통보 없이 삭제될 수 있습니다.")
                .font(.m14)
                .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.5))
                .padding(.bottom, 36)
            
            Text("사진 등록하기")
                .font(.sb16)
                .foregroundColor(Color.white)
                .padding(.horizontal, 69)
                .padding(.vertical, 9)
                .background(
                    Rectangle()
                        .fill(Color(red: 0.11, green: 0.33, blue: 1))
                        .cornerRadius(8)
                )
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    UploadImageView(eventViewModel: EventViewModel())
}
