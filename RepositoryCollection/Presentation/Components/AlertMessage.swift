//
//  AlertMessage.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation

struct AlertMessage {
    var title: String = ""
    var message: String = ""
    var isShowing: Bool = false
    
    init() {}
    
    init(title: String, message: String, isShowing: Bool) {
        self.title = title
        self.message = message
        self.isShowing = isShowing
    }
    
    init(error: Error) {
        let message = error.localizedDescription
        self.init(title: "Error", message: message, isShowing: !message.isEmpty)
    }
}
