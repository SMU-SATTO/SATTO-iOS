//
//  ProfileImageCell.swift
//  SATTO
//
//  Created by 황인성 on 7/16/24.
//

import SwiftUI

struct ProfileImageCell: View {
    
    var inCircleSize: CGFloat
    var outCircleSize: CGFloat
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: outCircleSize, height: outCircleSize)
            .overlay(
                Group {
                    if authViewModel.user.profileImg == nil {
                        Image("profileImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: inCircleSize, height: inCircleSize)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: authViewModel.user.profileImg!)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: inCircleSize, height: inCircleSize)
                        .clipShape(Circle())
                    }
                }
            )
            .shadow(radius: 15, x: 0, y: 10)
    }
}

struct FriendProfileImageCell: View {
    
    var inCircleSize: CGFloat
    var outCircleSize: CGFloat
    var friend: Friend
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: outCircleSize, height: outCircleSize)
            .overlay(
                Group {
                    if friend.profileImg == nil {
                        Image("profileImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: inCircleSize, height: inCircleSize)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: friend.profileImg!)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: inCircleSize, height: inCircleSize)
                        .clipShape(Circle())
                    }
                }
            )
//            .shadow(radius: 15, x: 0, y: 10)
    }
}

#Preview {
    ProfileImageCell(inCircleSize: 67, outCircleSize: 70)
}
