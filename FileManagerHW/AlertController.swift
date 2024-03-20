//
//  AlertController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 05.01.2024.
//

import UIKit

class AlertController {
    
    var alert = UIAlertController(title: nil, message: nil,  preferredStyle: .alert)
    
    func showAlert(in viewController: UIViewController, placeholder text: String, actionText: String, completion: @escaping (_ text: String) -> Void) {
        
        alert.addTextField{ textField in
            textField.placeholder = text
        }
        
        let actionCreate = UIAlertAction(title: actionText, style: .default) { action in
            if let text = self.alert.textFields?[0].text,
                text != "" {
                    completion(text)
                }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionCreate)
        alert.addAction(actionCancel)
        
        viewController.present(alert, animated: true)
    }
    
    func setupAlert(in viewController: UIViewController) {
        let action = UIAlertAction(title: "OK", style: .default)
        alert.title = "Ошибка"
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
