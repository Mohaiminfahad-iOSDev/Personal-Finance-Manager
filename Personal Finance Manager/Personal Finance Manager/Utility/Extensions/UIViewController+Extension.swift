//
//  UIViewController+Extension.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 4/7/24.
//

import Foundation
import UIKit


var vSpinner : UIView?

extension UIViewController {
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}


