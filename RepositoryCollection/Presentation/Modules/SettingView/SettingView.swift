//
//  SettingView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 08/07/2024.
//

import Foundation
import SwiftUI

struct SettingView: GeneralView {
    
    @ObservedObject var viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        Text("SettingView")
    }
}
