//
//  ActivityControllerView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 04/07/2024.
//

import Foundation
import SwiftUI

struct ActivityControllerView: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityControllerView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityControllerView>) { }
    
}
