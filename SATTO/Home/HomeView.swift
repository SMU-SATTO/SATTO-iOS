//
//  HomeVIew.swift
//  SATTO
//
//  Created by 황인성 on 3/14/24.
//

import SwiftUI

struct HomeView: View {
    
    
    
    var body: some View {
        
        let todayDate = getCurrentDate()
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(todayDate.day)
                .font(
                Font.custom("Pretendard", size: 40)
                .weight(.medium)
                )
                .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(todayDate.dayOfTheWeek)
                        
                    Text(todayDate.month + " " + todayDate.year)
                }
                .font(.m3)
                .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
    }
    
    func getCurrentDate() -> (year: String, month: String, day: String, dayOfTheWeek: String) {
        
        print("called getCurrentDate()")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy, MMM, d, E"
        let dateString = dateFormatter.string(from: Date())
        let components = dateString.components(separatedBy: ", ")
        
        guard components.count == 4 else {
                return ("", "", "", "")
            }
            
            return (components[0], components[1], components[2], components[3])
    }
}

#Preview {
    HomeView()
}
