//
//  CustomNavigationLink.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 28/01/2024.
//

import SwiftUI

struct CustomNavigationLink<Label, Destination> : View where Label : View, Destination : View {
    
    private let destination: Destination
    private let label: Label
    
    public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            CustomNavigationContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
            label
        }

    }
}

#Preview {
    CustomNavigationView {
        CustomNavigationLink {
            Text("Destination")
        } label: {
            Text("Navigate")
        }

    }
}
