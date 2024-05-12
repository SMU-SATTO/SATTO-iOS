//
//  AnnouncementEventView.swift
//  SATTO
//
//  Created by 황인성 on 5/7/24.
//

import SwiftUI

struct AnnouncementEventView: View {
    
    @Binding var stackPath: [Route]
    @ObservedObject var eventViewModel: EventViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0){
                AnnouncementEvnetCell(announcementOfWinnersTitle: "개강맞이 시간표 경진대회 당첨자 발표", adminProfile: "Avatar", postDate: "Someone  글쓴이・3일 전 ")
                
            }
            .padding(.top, 27)
            
            
        }
        .padding(.horizontal, 20)
        
    }
}

struct AnnouncementEvnetCell: View {
    
    var announcementOfWinnersTitle: String
    var adminProfile: String
    var postDate: String
    
    var body: some View {
        Group {
            HStack(spacing: 0){
                
                Circle().frame(width: 5)
                    .padding(.trailing, 7)
                
                Text(announcementOfWinnersTitle)
                    .font(.m14)
                
            }
            .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                
                Image(adminProfile)
                    .padding(.trailing, 12)
                
                Text(postDate)
                    .font(.m14)
            }
            .padding(.leading, 12)
            .padding(.bottom, 24)
            
            SattoDivider()
                .padding(.bottom, 24)
        }
    }
}

#Preview {
    AnnouncementEventView(stackPath: .constant([.announcementEvent]), eventViewModel: EventViewModel())
}
