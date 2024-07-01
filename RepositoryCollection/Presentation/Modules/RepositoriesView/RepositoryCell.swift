//
//  RepositoryCell.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation
import SwiftUI

struct RepositoryCell: View {
    
    let paddingHorizontal: CGFloat
    @State var height: CGFloat
    @State var repoModel: GithubRepoModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(repoModel.name)
                            .font(.system(size: 22, weight: .semibold))
                        if repoModel.fork {
                            HStack(alignment: .center, spacing: 2) {
                                Image("ic-fork-color")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22)
                                Text("Forked")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.blue)
                            .underline()
                        }
                    }
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .fill(.gray)
                        .frame(width: 56, height: 24)
                        .overlay {
                            Text(repoModel.visibility.uppercasedFirstLetter())
                                .font(.system(size: 12, weight: .medium))
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 56, height: 24)
                                .foregroundColor(Color(hex: "90D5FF").opacity(0.4))
                        }
                    Spacer()
                }
                if let description = repoModel.description {
                    Text(description).font(.system(size: 16, weight: .medium)).foregroundColor(Color(UIColor.darkGray))
                } else {
                    Text("No description").font(.system(size: 14)).italic().foregroundColor(.gray)
                }
                
                if !repoModel.topics.isEmpty {
                    drawTopicListView(topics: repoModel.topics, width: UIScreen.width - paddingHorizontal * 2)
                        .padding(.bottom, 10)
                        .padding(.top, 6)
                }
                HStack {
                    if let language = repoModel.language, !language.isEmpty {
                        HStack(spacing: 4) {
                            Circle()
                                .frame(width: 11, height: 11)
                                .foregroundColor(Color.orange)
                            Text(language)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(UIColor.darkGray))
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    if repoModel.stargazersCount != .zero {
                        HStack(spacing: 4) {
                            Spacer()
                            Image("ic-bling-star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            Text("\(repoModel.stargazersCount)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor.darkGray))
                        }
                    }
                }
            }
            .multilineTextAlignment(.leading)
        }
        .padding(10)
        .background(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                }
        })
        .foregroundColor(.black)
    }
}

private extension RepositoryCell {
    func drawTopicListView(topics: [String], width: CGFloat) -> some View {
        FlexibleView(
            availableWidth: width, data: topics,
            hSpacing: 10,
            vSpacing: 20,
            alignment: .listRowSeparatorLeading
        ) { topic in
            Text(topic)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "003ef9"))
                .padding([.leading, .trailing], 10)
                .background {
                    RoundedRectangle(cornerRadius: 13)
                        .frame(height: 26)
                        .foregroundColor(Color(hex: "90D5FF").opacity(0.4))
                }
        }
    }
}

#Preview {
    RepositoryCell(paddingHorizontal: 20, height: 200, repoModel: .mock)
}
