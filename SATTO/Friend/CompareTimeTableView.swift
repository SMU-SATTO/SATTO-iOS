//
//  CompareTimeTableView.swift
//  SATTO
//
//  Created by 황인성 on 4/4/24.
//

import SwiftUI

struct CompareTimeTableView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb5)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
                HStack(spacing: 0) {
                    Image("info.friend")
                        .padding(.trailing, 5)
                    
                    Text("내가 팔로잉하는 친구만 확인 가능합니다.")
                        .font(.m4)
                        .foregroundColor(Color.gray500)
                }
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            Image("append.friend")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
                
            
            HStack(spacing: 0) {
                ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                    .frame(width: 120, alignment: .trailing)
//                    .background(Color.black)
                    .padding(.trailing, 30)
                    
                
                Circle().frame(width: 7, height: 7)
                    .padding(.trailing, 7)
                Circle().frame(width: 7, height: 7)
                    .padding(.trailing, 7)
                Circle().frame(width: 7, height: 7)
                    .padding(.trailing, 30)
                
                HStack(spacing: 0) {
                    ProfileImageCell(inCircleSize: 56, outCircleSize: 60)
                    ProfileImageCell(inCircleSize: 56, outCircleSize: 60)
                        .padding(.leading, -30)
                    ProfileImageCell(inCircleSize: 56, outCircleSize: 60)
                        .padding(.leading, -30)
                }
            }
            .padding(.bottom, 14)
            HStack(spacing: 0) {
                
                Text("확인하러 가기   ")
                    .font(.sb6)
                    .foregroundColor(.white)
                    .padding(.leading, 38)
                
                Image("VectorTrailing")
                    .padding(.bottom, 5)
                    .padding(.trailing, 32)
            }
            .padding(.vertical,10)
            .background(
                Rectangle()
                    .cornerRadius(20)
            )
            .padding(.bottom, 14)
            
        }
        .background(
            Color.info60
        )
        
        Spacer()
    }
}

#Preview {
    CompareTimeTableView()
}
