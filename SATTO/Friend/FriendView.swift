//
//  FriendView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI





struct FriendView: View {
    
    @State var show = false
    @Namespace var namespace

    @Binding var stackPath: [Route]
    var body: some View {
//        NavigationStack(path: $stackPath) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if !stackPath.isEmpty {
                        Button(action: {
                            stackPath.popLast()
                        }, label: {
                            Image("Classic")
                        })
                        .padding(.trailing, 10)
                    }
                    
                    Text("친구관리")
                        .font(.b20)
                        .foregroundColor(Color.gray900)
                    
                    Spacer()
                    
                    Button(action: {
                        stackPath.append(Route.search)
                        print(stackPath)
                    }, label: {
                        Image("searchIcon")
                    })
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 53)
                
                
                if !show {
                    
//                    Circle()
//                        .frame(width: 100, height: 100)
//                        .background(
//                            Circle()
//                                .fill(Color.white)
//                                .frame(width: 105, height: 105)
//                        )
                    ProfileImageCell(inCircleSize: 100, outCircleSize: 105)
                        .shadow(radius: 15, x: 0, y: 10)
                        .padding(.bottom, -50)
                        .zIndex(1)
                        .matchedGeometryEffect(id: "cover", in: namespace)
                    
                    
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(TopCornerRadius(radius: 40))
                        
                        // sb16
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                
                                
                                Button(action: {
                                    stackPath.append(Route.followerSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("12")
                                            .font(.sb16)
                                            .foregroundColor(Color.gray800)
                                        
                                        // sb16
                                        Text("팔로워")
                                            .font(.sb16)
                                            .foregroundColor(Color.gray500)
                                    }
                                })
                                
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    stackPath.append(Route.followingSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("12")
                                            .font(.sb16)
                                            .foregroundColor(Color.gray800)
                                        
                                        // sb16
                                        Text("팔로잉")
                                            .font(.sb16)
                                            .foregroundColor(Color.gray500)
                                    }
                                })
                            }
                            .padding(.top, 22)
                            .padding(.horizontal, 51)
                            
                            
                            Text("한민재 20201499")
                                .font(.sb16)
                                .foregroundColor(Color.gray800)
                                .matchedGeometryEffect(id: "a", in: namespace)
                            
                            Text("컴퓨터과학과")
                                .font(.m14)
                                .foregroundColor(Color.gray600)
                                .padding(.bottom, 23)
                                .matchedGeometryEffect(id: "b", in: namespace)
                            
                            HStack(spacing: 0) {
                                
                                
                                
                                Text("졸업요건 확인")
                                    .font(.m12)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 7)
                                    .background(
                                        Rectangle()
                                            .fill(Color.blue7)
                                            .cornerRadius(10)
                                    )
                                    .padding(.trailing, 32)
                                    .onTapGesture {
                                        withAnimation(.spring()){
                                            show.toggle()
                                        }
                                    }
                                
                                Text("시간표 과목수정")
                                    .font(.m12)
                                    .foregroundColor(Color.blue7)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue7, lineWidth: 1)
                                        
                                    )
                                
                            }
                            
                        }
                        
                        
                    }
                }
                else {
                    GraduationRequirementsView(namespace: namespace, show: $show)
                }
                
            }
            .background(Color.info20, ignoresSafeAreaEdges: .top)
            .navigationBarBackButtonHidden()

    }
}

struct TopCornerRadius: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define the rectangular bounds
        let width = rect.size.width
        let height = rect.size.height
        
        // Define the curve for the top corners
        path.move(to: CGPoint(x: 0, y: radius))
        path.addQuadCurve(to: CGPoint(x: radius, y: 0),
                          control: CGPoint(x: 0, y: 0))
        
        // Line to top right corner
        path.addLine(to: CGPoint(x: width - radius, y: 0))
        
        // Define the curve for the top right corner
        path.addQuadCurve(to: CGPoint(x: width, y: radius),
                          control: CGPoint(x: width, y: 0))
        
        // Line to bottom right corner
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Line to bottom left corner
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}

struct GraduationRequirementsView: View {
    
    var namespace: Namespace.ID
    @Binding var show: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Circle()
                    .frame(width: 67, height: 67)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                    )
                    .shadow(radius: 15, x: 0, y: 10)
                    .padding(.leading, 10)
                    .matchedGeometryEffect(id: "cover", in: namespace)
                VStack(alignment: .leading, spacing: 0) {
                    Text("한민재 20201499")
                        .font(.sb16)
                        .foregroundColor(Color.gray800)
                        .matchedGeometryEffect(id: "a", in: namespace)
                    
                    Text("컴퓨터과학과")
                        .font(.m14)
                        .foregroundColor(Color.gray600)
                        .matchedGeometryEffect(id: "b", in: namespace)
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                
                Text("공학인증 확인")
                    .font(.sb14)
                    .foregroundColor(.white)
                    .padding(.leading, 38)
                
                Image("VectorTrailing")
                    .padding(.trailing, 32)
            }
            .padding(.vertical,7)
            .background(
                Rectangle()
                    .cornerRadius(20)
            )
            .padding(.bottom, 14)
            
            Text("공식 홈페이지에 있는 공학인증 링크로 연결")
                .font(Font.custom("Inter", size: 8))
                .onTapGesture {
                    withAnimation(.spring()){
                        show.toggle()
                    }
                }
            
            Spacer()
            
            CircularProgressView()
                .frame(width: 116, height: 116)
            
        }
        .padding(.horizontal, 20)
        
    }
}




struct ProfileImageCell: View {
    
    var inCircleSize: CGFloat
    var outCircleSize: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: outCircleSize, height: outCircleSize)
            .overlay(
                Circle()
                    .frame(width: inCircleSize, height: inCircleSize)
            )
            .shadow(radius: 15, x: 0, y: 10)
    }
}

struct CircularProgressView: View {
    
    let progress_1: Int = 60
    let progress_2: Int = 33
    let total: Int = 130
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(red: 0.96, green: 0.96, blue: 0.96),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: Double(progress_1 + progress_2) / Double(total))
                .stroke(
                    Color(red: 0.39, green: 0.52, blue: 0),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
//                .animation(.easeOut, value: progress)
            
            Circle()
                .trim(from: 0, to: Double(progress_1) / Double(total))
                .stroke(
                    Color(red: 0.39, green: 0.52, blue: 1),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
//                .animation(.easeOut, value: progress)
            VStack(spacing: 0) {
                Text("Uncompleted")
                    .font(.m10)
                    .foregroundColor(Color.gray800)
                
                Text("\(progress_1 + progress_2) / \(total)")
            }

        }
    }
}


#Preview {
    FriendView(stackPath: .constant([.friend]))
}

