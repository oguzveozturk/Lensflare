//
//  UIViewController.swift
//  Lensflare
//
//  Created by Oguz on 22.08.2020.
//
import UIKit
extension UIViewController {
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
