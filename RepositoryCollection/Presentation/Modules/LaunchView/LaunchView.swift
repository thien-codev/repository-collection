//
//  LaunchView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import SwiftUI

struct LaunchView: View {
    var body: some View {
        ViewFactory<RepositoriesView>().build(RepositoriesViewVM.init)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
