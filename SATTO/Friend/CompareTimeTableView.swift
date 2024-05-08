//
//  CompareTimeTableView.swift
//  SATTO
//
//  Created by 황인성 on 4/4/24.
//

import SwiftUI

struct CompareTimeTableView: View {
    
    @State var showFriendSheet: Bool = false
    @State var text: String = ""
    @State var compareFriendCount = 0
    @State var showResult: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb16)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
                HStack(spacing: 0) {
                    Image("info.friend")
                        .padding(.trailing, 5)
                    
                    Text("내가 팔로잉하는 친구만 확인 가능합니다.")
                        .font(.m12)
                        .foregroundColor(Color.gray500)
                }
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            if showResult == false {
                
                HStack(spacing: 0) {
                    
                    
                    ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                        .padding(.trailing, 30)
                    
                    
                    Circle().frame(width: 7, height: 7)
                        .padding(.trailing, 7)
                    Circle().frame(width: 7, height: 7)
                        .padding(.trailing, 7)
                    Circle().frame(width: 7, height: 7)
                        .padding(.trailing, 30)
                    
                    
                    
                    if compareFriendCount == 0 {
                        Button(action: {
                            showFriendSheet.toggle()
                        }, label: {
                            Image("append.friend")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                        })
                        .sheet(isPresented: $showFriendSheet) {
                            VStack(spacing: 0){
                                HStack(spacing: 0) {
                                    
                                    
                                    ClearButtonTextField(placehold: "친구 검색", text: $text)
                                        .padding(.leading, 20)
                                        .padding(.trailing, 10)
                                    
                                    Button(action: {
                                        showFriendSheet.toggle()
                                    }, label: {
                                        Text("완료")
                                    })
                                    .padding(.trailing, 20)
                                    
                                }
                                .padding(.bottom, 10)
                                .padding(.top, 20)
                                
                                Divider()
                                ScrollView {
                                    ForEach(0 ..< 10) { item in
                                        CompareFriendCell(name: "한민재", studentID: 20201499, isFollowing: false)
                                            .padding(.bottom, 15)
                                            .padding(.top, 10)
                                    }
                                }
                                .presentationDetents([.fraction(0.7), .fraction(0.9)])
                                .presentationDragIndicator(.visible)
                            }
                        }
                    }
                    else {
                        
                        ZStack {
                            ProfileImageCell(inCircleSize: 56, outCircleSize: 60)
                            ProfileImageCell(inCircleSize: 56, outCircleSize: 60)
                                .offset(CGSize(width: 20.0, height: 0))
                            
                            HStack(spacing: 0) {
                                Circle().frame(width: 3, height: 3)
                                    .padding(.trailing, 3)
                                Circle().frame(width: 3, height: 3)
                                    .padding(.trailing, 3)
                                Circle().frame(width: 3, height: 3)
                            }
                            .offset(CGSize(width: 65.0, height: 0))
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
//                .background(Color.red)
                .padding(.bottom, 14)
                
                //            .background(Color.red)
                
                
                HStack(spacing: 0) {
                    
                    Text("확인하러 가기   ")
                        .font(.sb14)
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
            
            else {
//                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(0 ..< 3) { item in
                                ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                        .padding(.horizontal, 20)
//                    }
            }
            
        }
        .background(
            Color.info60
        )
        
        Spacer()
    }
}

struct CompareFriendCell: View {
    
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
            
            Button(action: {
                
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    // m16
                    Text("20201499")
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    
                    // m12
                    Text("한민재")
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            
            Spacer()
            
            if isFollowing {
                Text("팔로잉")
                    .font(.m12)
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
                    .font(.m12)
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


struct CompareTimeTableResultView: View {
    
//    @State var showFriendSheet: Bool = false
//    @State var text: String = ""
//    @State var compareFriendCount = 0
//    @State var showResult: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb16)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            
//            HStack(spacing: 0) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< 10) { item in
                            ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                                .padding(.trailing, 30)
                        }
                    }
                    .padding(.vertical, 20)
                }
                
//            }
//            .padding(.bottom, 14)

            
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

#Preview {
    CompareTimeTableResultView()
}

