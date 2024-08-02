//
//  FriendsViewHelper.swift
//  SATTO
//
//  Created by 황인성 on 7/16/24.
//

import SwiftUI


struct GraduationRequirementsView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                Button(action: {
                    navPathFinder.path.popLast()
                }, label: {
                    Image("Classic")
                })
                .padding(.trailing, 10)
                .padding(.leading, 20)
                
                
                Text("졸업 요건 확인하기")
                    .font(.b20)
                    .foregroundColor(Color.gray900)
                
                Spacer()
            }
            
            Spacer()
            
            Image("GraduationRequirement")
                .padding(.bottom, 26)
            
            // m16
            Text("들었던 과목이 존재하지 않아 \n졸업 요건을 확인할 수 없어요.")
                .font(.m16)
                .lineSpacing(4)
                .foregroundColor(Color.gray400)
                .padding(.bottom, 57)
            
            // sb14
            Text("들었던 과목 선택하기")
                .font(.sb14)
                .foregroundColor(Color.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 75)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue7)
                )
            
            Spacer()
            Spacer()
        }
    }
}

struct SelectCompletedSubjectsView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @State var selection = 1
    @State var text = ""
    
    var body: some View {
        ZStack {
            
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    Button(action: {
                        navPathFinder.path.popLast()
                    }, label: {
                        Image("Classic")
                    })
                    .padding(.trailing, 10)
                    
                    
                    Text("졸업 요건 확인하기")
                        .font(.b20)
                        .foregroundColor(Color.gray900)
                    
                    Spacer()
                }
                .padding(.bottom, 25)
                
                Picker(selection: $selection, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("24학년도 1학기 시간표")
                        .tag(1)
                    Text("1").tag(2)
                    Text("2").tag(3)
                }
                .tint(Color.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
                
                ClearButtonTextField(placehold: "들었던 과목을 입력해 주세요", text: $text)
                    .padding(.bottom, 20)
                
                
                LectureTable()
                
                Spacer()
                
                
                // sb14
                Text("들었던 과목 저장하기")
                    .font(.sb14)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 13)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue7)
                            .padding(.horizontal, 40)
                    )
                    .padding(.bottom, 20)
                
                Text("해당 학기 시간표 수정하기")
                    .font(.sb14)
                    .foregroundColor(Color.blue7)
                    .padding(.vertical, 13)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue7, lineWidth: 1)
                            .padding(.horizontal, 40)
                    )
                
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ClearButtonTextField: View {
    
    var placehold: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "magnifyingglass")
                .padding(.horizontal, 12)
            
            TextField(placehold, text: $text)
            
            Spacer()
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image("Icon")
                        .padding(.trailing, 10)
                }
            }
            
        }
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(Color(red: 0.91, green: 0.92, blue: 0.93))
                .cornerRadius(30)
        )
    }
}

//#Preview {
//    GraduationRequirementsView()
//        .environmentObject(FriendNavigationPathFinder.shared)
//}
//
//#Preview {
//    SelectCompletedSubjectsView()
//        .environmentObject(FriendNavigationPathFinder.shared)
//}

#Preview {
    ClearButtonTextField(placehold: "asd", text: .constant("a"))
}


struct LectureTable: View {
    var body: some View {
        
        
        ScrollView(showsIndicators: true) {
            ZStack(alignment: .top) {
                
                
                Text("\u{200B}")
                    .font(.m11)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.89, green: 0.91, blue: 1.00)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 10,
                                topTrailingRadius: 10
                            )
                        ))
                
                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("학수번호-분반")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("HAAC0012-1")
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.leading, 18)
                    
                    
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학년")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("3")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("교과목명")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("경제학의이해")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("이수구분")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("1전심")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학점")
                            .padding(.vertical, 8)
                            .padding(.trailing, 29)
                        
                        ForEach(0..<100){_ in
                            HStack(spacing: 0) {
                                Text("3")
                                    .padding(.vertical, 8)
                                    .padding(.trailing, 15)
                                
                                Image(systemName: "plus.circle.dashed")
                                    .frame(width: 14, height: 14)
                                
                            }
                        }
                    }
                }
                .font(.m11)
            }
        }
    }
}
