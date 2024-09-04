//
//  SettingView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

enum SettingRoute: Hashable {
    case editProfile
    case editPassword
}

final class SettingNavigationPathFinder: ObservableObject {
    static let shared = SettingNavigationPathFinder()
    private init() { }
    
    @Published var path: [SettingRoute] = []
    
    func addPath(route: SettingRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}

struct SettingView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navPathFinder: SettingNavigationPathFinder
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State var selectedImage: UIImage? = nil
    @State var isImagePickerPresented = false
    
    var body: some View {

        NavigationStack(path: $navPathFinder.path) {
            ZStack {
                background
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        ProfileImageCell(inCircleSize: 125, outCircleSize: 130)
                            .padding(.top, 130)
                            .padding(.bottom, 14)
                        
//                        Button(action: {
//                            isImagePickerPresented.toggle()
//                        }, label: {
//                            Text("이미지편집")
//                        })
//                        Button(action: {
//                            authViewModel.deleteProfileImage {
//                                authViewModel.userInfoInquiry { }
//                            }
//                        }, label: {
//                            Text("이미지삭제")
//                        })
                        
                        Text(authViewModel.user.name)
                            .font(.sb18)
                        Text(authViewModel.user.email)
                            .font(.m14)
                            .padding(.bottom, 14)
                        
                        VStack(spacing: 18) {
                            VStack(spacing: 0) {
                                // 계정공개
                                SettingToggle(isOn: $authViewModel.user.isPublic, toogleTitle: "계정 공개", toggleImage: "account")
                                    .onChange(of: authViewModel.user.isPublic) { newValue in
                                        if newValue == true {
                                            authViewModel.setAccountPublic()
                                        }
                                        else {
                                            authViewModel.setAccountPrivate()
                                        }
                                    }
                                // 다크모드
                                SettingToggle(isOn: $isDarkMode, toogleTitle: "다크모드", toggleImage: "darkmode")
                            }
                            .padding(.vertical, 5)
                            .background(
                                border
                            )
                            
                            VStack(spacing: 0) {
                                Button(action: {
                                    isImagePickerPresented.toggle()
                                }, label: {
                                    SettingOptionCell(settingImageName: "edit", settingName: "프로필 이미지 수정하기")
                                })
                                Button(action: {
                                    authViewModel.deleteProfileImage {
                                        authViewModel.userInfoInquiry { }
                                    }
                                }, label: {
                                    SettingOptionCell(settingImageName: "edit", settingName: "프로필 이미지 삭제하기")
                                })
                                // 개인정보 수정
                                Button(action: {
                                    navPathFinder.addPath(route: .editProfile)
                                }, label: {
                                    SettingOptionCell(settingImageName: "edit", settingName: "개인정보 수정하기")
                                })
                                // 비밀번호 수정
                                Button(action: {
                                    navPathFinder.addPath(route: .editPassword)
                                }, label: {
                                    SettingOptionCell(settingImageName: "info", settingName: "비밀번호 수정하기")
                                })
                            }
                            .padding(.vertical, 5)
                            .background(
                                border
                            )
                            
                            VStack(spacing: 0) {
                                // 아직 작동안함
                                SettingOptionCell(settingImageName: "ask", settingName: "문의하기")
                                SettingOptionCell(settingImageName: "version", settingName: "현재 버전")
                                
                                // 로그아웃
                                Button(action: {
                                    authViewModel.logout()
                                }, label: {
                                    SettingOptionCell(settingImageName: "logout", settingName: "로그아웃")
                                })
                                // 회원탈퇴
                                Button(action: {
                                    authViewModel.signOut()
                                }, label: {
                                    SettingOptionCell(settingImageName: "delete", settingName: "탈퇴하기")
                                })
                            }
                            .padding(.vertical, 5)
                            .background(
                                border
                            )
                            .padding(.bottom, 100)
                        }
                        .padding(.horizontal, 25)
                    }
                    .foregroundStyle(Color.cellText)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                authViewModel.userInfoInquiry { }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                SingleImagePickerView(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage) { _ in
                if let image = selectedImage {
                    authViewModel.uploadProfileImage(image: image) {
                        authViewModel.userInfoInquiry { }
                    }
                }
            }
            .navigationDestination(for: SettingRoute.self) { route in
                switch route {
                case .editProfile:
                    EditProfileView()
                case .editPassword:
                    EditPasswordView()
                }
            }
        }
    }
    
    // 아래만 둥근 배경
    var background: some View {
        ZStack{
            Color.background
            
            VStack(spacing: 0) {
                MySquare()
                    .fill(Color.settingBackground)
                    .frame(maxWidth: .infinity, maxHeight: 230)
                
                Spacer()
            }
        }
    }
    
    var border: some View {
        Rectangle()
            .foregroundColor(.cellBackground)
            .cornerRadius(8)
            .shadow(radius: 5, x: 0, y: 0)
    }
}


struct SettingToggle: View {
    @Binding var isOn: Bool
    var toogleTitle: String
    var toggleImage: String
    
    var body: some View {
            Toggle(isOn: $isOn) {
                HStack(spacing: 0) {
                    Image(toggleImage)
                        .renderingMode(.template)
                        .foregroundStyle(Color.cellText)
                        .padding(.leading, 5)
                        .padding(.trailing, 14)
                    
                    Text(toogleTitle)
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundStyle(Color.cellText)
                }
            }
            .tint(Color(red: 0.18, green: 0.5, blue: 0.93))
            .padding(.horizontal, 23)
            .padding(.vertical, 7)
    }
}

struct SettingOptionCell: View {
    
    var settingImageName: String
    var settingName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(settingImageName)
                .renderingMode(.template)
                .foregroundStyle(Color.cellText)
                .padding(.leading, 5)
                .padding(.trailing, 14)
            
            Text(settingName)
                .font(Font.custom("Pretendard", size: 14))
                .foregroundColor(Color.cellText)
            
            Spacer()
        }
        .padding(.horizontal, 23)
        .padding(.vertical, 8)
    }
}

// 아래만 둥근 도형
struct MySquare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height * 0.8))
        path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.height), control: CGPoint(x: rect.size.width * 0.8, y: rect.size.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.size.height * 0.8), control: CGPoint(x: rect.size.width * 0.2, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        
        return path
    }
}



