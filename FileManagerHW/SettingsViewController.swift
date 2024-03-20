//
//  SettingsViewController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 11.03.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let keychain: KeychainServiceProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var model: [String] = ["Сортировка в алфавитном порядке", "Показывать размер фотографии", "Сменить пароль"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    init() {
        keychain = KeychainService()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(keychain: KeychainServiceProtocol) {
        self.keychain = keychain
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
    
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func switchSorting(sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "Sorting")
 
    }
    
    @objc func switchSize(sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "Size")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = model[indexPath.row]
        let switchView = UISwitch()
        switchView.setOn(true, animated: true)
        cell.accessoryView = switchView
        
        if indexPath.row == 0 {
            switchView.addTarget(self, action: #selector(switchSorting(sender:)), for: .valueChanged)
            switchView.setOn(UserDefaults.standard.bool(forKey: "Sorting"), animated: true)
        }
        
        if indexPath.row == 1 {
            switchView.addTarget(self, action: #selector(switchSize(sender:)), for: .valueChanged)
            switchView.setOn(UserDefaults.standard.bool(forKey: "Size"), animated: true)
        }
        
        if indexPath.row == 2 {
            cell.accessoryView = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let alert = AlertController()
            alert.alert.title = "Change Password"
            alert.showAlert(in: self,
                            placeholder: "New Password",
                            actionText: "Change") { text in
                if text.count > 4 {
                    self.keychain.update(newPassword: text)
                } else {
                    alert.alert.message = "Пароль должен содержать больше 4х символов"
                    alert.setupAlert(in: self)
                }
            }
        }
    }
}
