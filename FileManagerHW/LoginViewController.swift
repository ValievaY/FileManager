//
//  LoginViewController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 16.01.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var buttonCounter = 0
    
    private let keychain: KeychainServiceProtocol
    
    private var passwordText = ""
    
    private lazy var password: UITextField = {
        let password = UITextField()
        password.textColor = .black
        password.backgroundColor = .systemGray6
        password.textAlignment = .left
        password.placeholder = "  Password"
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.clearButtonMode = .whileEditing
        password.layer.cornerRadius = 10
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector (buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setButtonTitle()
    }
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(password)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            password.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setButtonTitle() {
        if passwordIsExist() {
            loginButton.setTitle("Введите пароль", for: .normal)
        } else {
            loginButton.setTitle("Создать пароль", for: .normal)
        }
    }
    
    func passwordIsExist() -> Bool {
        if keychain.load() != "" {
            return true
        } else {
            return false
        }
    }
    
    @objc func buttonAction() {
        buttonCounter += 1
        
        let alert = AlertController()
        
        switch buttonCounter {
        
        case 1:
            if password.text!.count > 4 {
                passwordText = password.text!
                password.text = ""
                loginButton.setTitle("Повторите пароль", for: .normal)
                print("\(passwordText)")
            } else {
                buttonCounter -= 1
                alert.alert.message = "Пароль должен содержать больше 4х символов"
                alert.setupAlert(in: self)
            }
        case 2:
            if password.text == passwordText {
                if passwordIsExist() {
                    if keychain.load() == password.text {
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                    } else {
                        alert.alert.message = "Неверный пароль"
                        alert.setupAlert(in: self)
                        buttonCounter = 0
                        password.text = ""
                        setButtonTitle()
                    }
                } else {
                    keychain.save(password: password.text!)
                    self.navigationController?.pushViewController(TabBarController(), animated: true)
                }
            } else {
                alert.alert.message = "Повторите попытку"
                alert.setupAlert(in: self)
                buttonCounter = 0
                password.text = ""
                setButtonTitle()
            }
        default:
            break
        }
    }
}

