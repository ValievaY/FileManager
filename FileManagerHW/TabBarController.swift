//
//  TabBarController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 11.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var documentsNavigationController: UINavigationController!
    private var settingsNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        tabBarSetup()
    }
    
    private func tabBarSetup() {
        
        documentsNavigationController = UINavigationController.init(rootViewController: DocumentsViewController())
        settingsNavigationController = UINavigationController.init(rootViewController: SettingsViewController())
        
        self.viewControllers = [documentsNavigationController,settingsNavigationController]
        
        documentsNavigationController.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "doc"), tag: 0)
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        UITabBar.appearance().tintColor = .systemBlue
        UITabBar.appearance().backgroundColor = .systemGray6
    }
}
