//
//  DefaultSheetView.swift
//  SATTO
//
//  Created by 김영준 on 3/17/24.
//

import SwiftUI

struct DefaultSheetView: View {
    @ObservedObject var timetableViewModel = TimetableViewModel()
    
    @State private var isExpanded = false
    @State private var isSubjectSelected = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(red: 0.90, green: 0.97, blue: 1).opacity(0.6))
                .frame(width: 330, height: isExpanded ? 200 : 130)
                .shadow(color: Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.25), radius: 6.23, x: 0, y: 1.22)
                .overlay(
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color(red: 0.5, green: 0.94, blue: 1))
                            .frame(width: 50, height: 23)
                            .overlay(
                                Text("전공")
                                    .foregroundStyle(.blue)
                                    .font(.sb12)
                            )
                            .padding([.leading, .top], 10)
                        VStack(spacing: 3) {
                            HStack {
                                Text("\(timetableViewModel.subjectData.name)")
                                    .font(.sb20)
                                    .foregroundStyle(.black)
                                Text("\(timetableViewModel.subjectData.name)")
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            
                            HStack {
                                Text("월 1-3")
                                    .font(.m14)
                                Text("AB012345")
                                    .font(.m14)
                                Spacer()
                            }
                            .foregroundStyle(Color(red: 0.45, green: 0.47, blue: 0.5))
                        }
                        .padding(.leading, 10)
                        
                        Rectangle()
                            .foregroundStyle(Color(red: 0.67, green: 0.75, blue: 0.94))
                            .frame(width: 260, height: 1)
                            .padding(.leading, 10)
                        HStack {
                            Text("수강정원")
                                
                            Text("200")
                            Text("담은인원")
                            Text("230")
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                )
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isSubjectSelected.toggle()
                            }) {
                                Image(systemName: isSubjectSelected ?  "checkmark.circle.fill" : "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            .padding([.top, .trailing], 20)
                        }
                        Spacer()
                    }
                )
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            //MARK: - 수강인원 그래프 구현
        }
    }
}

#Preview {
    DefaultSheetView()
}
