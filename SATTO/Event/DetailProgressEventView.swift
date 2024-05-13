//
//  DetailProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct DetailProgressEventView: View {
    
    var eventName: String
    var eventPeriod: String
    var eventImage: String
    var eventDeadLine: String
    var eventNumberOfParticipants: String
    var eventDescription: String
    
    @Binding var stackPath: [Route]
    
    let columns = [
        //        GridItem(.flexible(), spacing: 0),
        //                GridItem(.flexible())
        GridItem(.fixed(165), spacing: 23),
        GridItem(.fixed(165))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .frame(height: 0)
                    HStack(spacing: 0) {
                        Text("학교 사진 콘테스트")
                            .font(.m18)
                            .padding(.trailing, 7)
                        
                        Text(eventDeadLine)
                            .font(.m12)
                            .foregroundColor(Color(red: 0.84, green: 0.36, blue: 0.34))
                            .padding(.horizontal, 11)
                            .padding(.vertical, 1)
                            .background(
                                Rectangle()
                                    .fill(Color(red: 0.98, green: 0.93, blue: 0.94))
                                    .cornerRadius(5)
                            )
                    }
                    .padding(.bottom, 6)
                    
                    Text(eventPeriod)
                        .font(.m17)
                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                        .padding(.bottom, 5)
                    
                    Text("마음에 드는 사진에 좋아요를 눌러 주세요!")
                        .font(Font.custom("Pretendard", size: 12))
                        .foregroundColor(Color(red: 0.72, green: 0.25, blue: 0.25))
                        .padding(.bottom, 10)
                    
                    
                    HStack(spacing: 0) {
                        
                        Text("내 사진 자랑하기")
                            .font(.sb14)
                            .foregroundColor(Color(red: 0.28, green: 0.18, blue: 0.89))
                            .padding(.leading, 27)
                        
                        Image("VectorTrailing.blue")
                            .padding(.trailing, 16)
                    }
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(30)
                    )
                }
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Image(eventImage)
                        .resizable()
                        .frame(width: 127, height: 127)
                }
                
            }
            .padding(.leading, 25)
            .padding(.top, 22)
            .padding(.bottom, 17)
            .background(Color(red: 0.91, green: 0.95, blue: 1))
            
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 0)
                        
                        HStack(spacing: 0) {
                            Text("게시물 유형")
                                .font(.sb12)
                                .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                                .padding(.top, 10)
                                .padding(.bottom, 12)
                            
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(0..<20, id: \.self) {i in
                                EventFeedCell()
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    //                .background(Color.blue)
                }
                
                Circle()
                    .fill(Color(red: 0.28, green: 0.18, blue: 0.89))
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 30)
                
            }
            
        } // Vstsck
    }
}

struct EventFeedCell: View {
    var body: some View {
        ZStack(alignment: .bottom){
            Image("eventSampleImage")
                .resizable()
                .frame(width: 165, height: 165)
            
            ZStack {
                Rectangle()
                    .frame(width: 165, height: 28)
                HStack(spacing: 0) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 12)
                    
                    Text("12")
                        .font(.m12)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 2, height: 2)
                        .padding(.trailing, 3)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 2, height: 2)
                        .padding(.trailing, 3)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 2, height: 2)
                    
                }
                .padding(.horizontal, 12)
                .frame(width: 165)
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    DetailProgressEventView(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!", stackPath: .constant([.detailProgressEvent]))
}
