//
//  Alerts.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/7/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: Alerts

extension UIViewController {
    
    func showAlert(title: String, message: String, callback: @escaping () -> (), option: Int = 1) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            alertAction in
            callback()
            }))
        if option == 2 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}
