//
//  UIApplication.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 10/07/2024.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
        .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
        .first(where: { $0 is UIWindowScene })
        // Get its associated windows
        .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
        .first(where: \.isKeyWindow)
    }
}
