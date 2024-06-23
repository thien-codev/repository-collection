//
//  HistoryView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import SwiftUI

struct HistoryView: GeneralView {
    @ObservedObject var viewModel: HistoryViewModel
    
    init(viewModel: HistoryViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("HistoryView")
    }
}
