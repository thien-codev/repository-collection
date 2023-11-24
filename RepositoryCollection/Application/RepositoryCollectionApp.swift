//
//  RepositoryCollectionApp.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import SwiftUI

@main
struct RepositoryCollectionApp: App {
    
    init() {
        AppEnvironment.bootstrap()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}
