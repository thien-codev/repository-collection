//
//  RepositoryCell.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation
import SwiftUI

struct RepositoryCell: View {
    
    enum PresentationMode {
        case large
        case medium
        
        var showFork: Bool {
            return self == .large
        }
        
        var showTopic: Bool {
            return self == .large
        }
        
        var titleFont: CGFloat {
            return self == .large ? 22 : 18
        }
        
        var descFont: CGFloat {
            return self == .large ? 16 : 14
        }
        
        var backgroundColor: Color {
            return self == .large ? .white : Color(hex: "90D5FF").opacity(0.2)
        }
        
        var limitTextLine: Int {
            return self == .large ? 4 : 1
        }
    }
    
    let paddingHorizontal: CGFloat
    @State var repoModel: GitHubRepoModel
    let presentationMode: PresentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(repoModel.name)
                            .font(.system(size: presentationMode.titleFont, weight: .semibold))
                            .lineLimit(presentationMode.limitTextLine)
                        if repoModel.fork, presentationMode.showFork {
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
                    HStack(spacing: 2) {
                        Text(repoModel.visibility.uppercasedFirstLetter())
                            .font(.system(size: 12, weight: .semibold))
                        if repoModel.isTemplate {
                            Text("template")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        
                        if repoModel.archived {
                            Text("archived")
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    .padding(.horizontal, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                            .fill(repoModel.archived ? Color(hex: "ff4d01") : .gray)
                            .frame(height: 24)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color(hex: "90D5FF").opacity(0.4))
                            }
                    }
                    .foregroundColor(repoModel.archived ? Color(hex: "ff4d01") : .black)
                    .offset(y: -6)
                    
                    Spacer()
                }
                if let description = repoModel.description {
                    Text(description)
                        .font(.system(size: presentationMode.descFont, weight: .medium))
                        .foregroundColor(Color(UIColor.darkGray))
                        .lineLimit(presentationMode.limitTextLine)
                } else {
                    Text("No description").font(.system(size: 14)).italic().foregroundColor(.gray)
                }
                
                if !repoModel.topics.isEmpty, presentationMode.showTopic {
                    drawTopicListView(topics: repoModel.topics, width: UIScreen.width - paddingHorizontal * 2)
                        .padding(.bottom, 10)
                        .padding(.top, 6)
                }
                HStack(spacing: 14) {
                    if let language = repoModel.language, !language.isEmpty {
                        HStack(spacing: 4) {
                            Circle()
                                .frame(width: 11, height: 11)
                                .foregroundColor(Color.orange)
                            Text(language)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(UIColor.darkGray))
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    if repoModel.forksCount != .zero {
                        HStack(spacing: 4) {
                            Image("ic-forked")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                            Text("\(repoModel.forksCount)")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color(UIColor.darkGray))
                    }
                    
                    if repoModel.watchersCount != .zero {
                        HStack(spacing: 4) {
                            Image(systemName: "eye")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                                .fontWeight(.semibold)
                            Text("\(repoModel.watchersCount)")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color(UIColor.darkGray))
                    }
                    
                    if repoModel.stargazersCount != .zero {
                        HStack(spacing: 4) {
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
                        .foregroundColor(repoModel.archived ? Color(hex: "fff2e5") : presentationMode.backgroundColor)
                }
        })
        .foregroundColor(.black)
        .contentShape(Rectangle())
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
    RepositoryCell(paddingHorizontal: 20, repoModel: .mock, presentationMode: .large)
}
