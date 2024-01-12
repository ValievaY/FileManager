//
//  AlertController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 05.01.2024.
//

import UIKit

class AlertController {
    
    func showAlert(in viewController: UIViewController, completion: @escaping (_ text: String) -> Void) {
        let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        
        alert.addTextField{ textField in
            textField.placeholder = "Folder name"
        }
        
        let actionCreate = UIAlertAction(title: "Create", style: .default) { action in
            if let text = alert.textFields?[0].text,
                text != "" {
                    completion(text)
                }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionCreate)
        alert.addAction(actionCancel)
        
        viewController.present(alert, animated: true)
    }
}
