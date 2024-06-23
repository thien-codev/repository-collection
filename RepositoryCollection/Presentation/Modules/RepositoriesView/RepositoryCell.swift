//
//  RepositoryCell.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation
import SwiftUI

struct RepositoryCell: View {
    
    @State var height: CGFloat
    @State var repoModel: GithubRepoModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(lineWidth: 3)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
            }
            .overlay(content: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(repoModel.fullName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Description: \(repoModel.description ?? "No")")
                            .font(.body)
                        HStack {
                            Text(repoModel.visibility)
                                .font(.body)
                            Spacer()
                            Text(repoModel.createdAt)
                                .font(.body)
                        }
                    }
                    Spacer()
                }
                .padding()
            })
            .frame(height: height)
            .foregroundColor(.black)
    }
}

#Preview {
    RepositoryCell(height: 200, repoModel: .mock)
}
