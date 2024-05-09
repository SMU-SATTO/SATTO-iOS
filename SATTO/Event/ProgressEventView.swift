//
//  ProgressEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct ProgressEventView: View {
    @State private var selectedPage: EventTab = .progressEvent
    @Namespace var namespace
    
    @Binding var stackPath: [Route]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
                
                ScrollView {
                    
                    VStack(spacing: 0){
                        
                        ProgressEventCell(eventName: "개강맞이 시간표 경진대회", eventPeriod: "2024.02.15 - 2024.03.28", eventImage: "sb", eventDeadLine: "6일 남음", eventNumberOfParticipants: "256명 참여", eventDescription: "내 시간표를 공유해 시간표 경진대회에 참여해 보세요!")
                            .onTapGesture {
                                stackPath.append(.detailProgressEvent)
                            }
                            .padding(.top, 27)
                        
                        
                        
                    }
                    
                }
                .padding(.horizontal, 20)
                
        }
        
    }
}

struct ProgressEventCell: View {
    
    var eventName: String
    var eventPeriod: String
    var eventImage: String
    var eventDeadLine: String
    var eventNumberOfParticipants: String
    var eventDescription: String
    
    var body: some View {
        Rectangle()
            .frame(height: 180)
            .overlay(
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(red: 0.98, green: 0.93, blue: 0.79))
                        .frame(height: 100)
                        .overlay(
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(eventName)
                                        .font(.m18)
                                        .padding(.bottom, 10)
                                    
                                    Text(eventPeriod)
                                        .font(.m17)
                                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                }
                                .padding(.leading, 24)
                                .padding(.trailing, 27)
                                
                                Image(eventImage)
                            }
                            ,alignment: .leading
                        )
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 80)
                        .overlay(
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
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
                                    
                                    Spacer()
                                    
                                    Text(eventNumberOfParticipants)
                                        .font(.m12)
                                    
                                }
                                .padding(.bottom, 8)
                                
                                Text(eventDescription)
                                    .font(.m14)
                                
                                
                            }
                                .padding(.horizontal, 24)
                        )
                }
            )
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.bottom, 37)
    }
}



#Preview {
    ProgressEventView(stackPath: .constant([.progressEvent]))
}
