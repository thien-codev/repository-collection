//
//  RepositoryDetailView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import SwiftUI

struct RepositoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var repoModel: GithubRepoModel
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack(alignment: .leading) {
                containerView
            }
            .padding()
        }
    }
    
    private var containerView: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .stroke(lineWidth: 3)
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(radius: 0, x: 8, y: 8)
            }
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(repoModel.fullName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Description: \(repoModel.description ?? "No")")
                            .font(.body)
                        Text("HtmlURL: \(repoModel.htmlURL)")
                            .font(.body)
                        Text("GitURL: \(repoModel.gitURL)")
                            .font(.body)
                        
                        Text(repoModel.visibility)
                            .font(.body)
                        Spacer()
                        Text(repoModel.createdAt)
                            .font(.body)
                    }
                    Spacer()
                }
                .padding()
            }
    }
    
    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(.black)
                .background {
                    Circle().foregroundColor(.white)
                }
        }
    }
}

#Preview {
    RepositoryDetailView(repoModel: .mock)
}

