//
//  RepositoriesView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct RepositoriesView: View {
    let data = (1...10).map { "Item \($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 400))
    ]
    
    var body: some View {
        LazyHGrid(rows: columns, spacing: 20) {
            ForEach(data, id: \.self) { item in
                Text(item)
            }
        }
        .scrollDisabled(false)
        .frame(height: 300)
    }
}

#Preview {
    RepositoriesView()
}
