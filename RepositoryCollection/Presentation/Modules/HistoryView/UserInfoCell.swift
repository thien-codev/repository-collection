//
//  UserInfoCell.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct UserInfoCell: View {
    var model: GitHubUserModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                HStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: "000072"))
                        .overlay {
                            KFImage(URL(string: model.avatarURL))
                                .placeholder {
                                    Image(systemName: "person.crop.circle")
                                }
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        }
                    VStack(alignment: .leading,spacing: 0) {
                        if let bio = model.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(4)
                        }
                        if let name = model.name, !name.isEmpty {
                            Text(name)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        if !model.login.isEmpty {
                            Text(model.login)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "000072").opacity(0.7))
                        }
                    }
                    .foregroundColor(Color(hex: "000072"))
                    Spacer()
                }
                .padding(.bottom, 4)
                
                if model.following != .zero || model.followers != .zero {
                    HStack {
                        Image(systemName: "person.2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .fontWeight(.medium)
                        
                        if model.followers != .zero {
                            Text("\(model.followers)").font(.system(size: 16, weight: .bold)) + Text(" follower").font(.system(size: 16))
                        }
                        
                        if model.following != .zero {
                            Text("\(model.following)").font(.system(size: 16, weight: .bold)) + Text(" following").font(.system(size: 16))
                        }
                    }
                    .foregroundColor(Color(hex: "000072"))
                }
                
                HStack {
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .fontWeight(.medium)
                    
                    Text("Repositories").font(.system(size: 16))
                    Text("\(model.publicRepos)").font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(Color(hex: "000072"))
            }
            .multilineTextAlignment(.leading)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hex: "90D5FF").opacity(0.4))
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}
