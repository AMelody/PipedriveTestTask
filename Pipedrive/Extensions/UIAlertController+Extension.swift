//
//  UIAlertController+Extension.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 6/4/23.
//

import UIKit

// MARK: -

extension UIAlertController {

    class func presentAlert(for viewController: UIViewController, with error: PipedriveAPIError) {

        let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
