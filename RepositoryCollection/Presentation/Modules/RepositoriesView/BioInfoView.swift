//
//  BioInfoView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 10/07/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct BioInfoView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresented: Bool
    var avatarUrlString: String?
    var info: String?
    var isFullAvatar: Bool = false
    
    private var edgeWidth: CGFloat { UIScreen.width * 2 / 3 }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            if isFullAvatar {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.white)
                    .frame(width: edgeWidth, height: edgeWidth)
                    .overlay {
                        KFImage(URL(string: avatarUrlString ?? ""))
                            .placeholder {
                                Image(systemName: "person.crop.circle")
                            }
                            .resizable()
                            .scaledToFill()
                        .clipShape(Circle())}
            } else {
                VStack(alignment: .leading, spacing: -14) {
                    Circle()
                        .stroke(lineWidth: 3)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .overlay {
                            KFImage(URL(string: avatarUrlString ?? ""))
                                .placeholder {
                                    Image(systemName: "person.crop.circle")
                                }
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        }
                        .zIndex(.infinity)
                        .offset(x: -20)
                    Text(info ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lineWidth: 2)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.white)
                                }
                        }
                }
                .padding(40)
            }
        }
        .ignoresSafeArea()
        .zIndex(.infinity)
        .opacity(isPresented ? 1 : 0)
    }
}
