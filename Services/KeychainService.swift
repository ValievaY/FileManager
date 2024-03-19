//
//  KeychainService.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 13.01.2024.
//

import KeychainSwift

class KeychainService: KeychainServiceProtocol {
    
    let keychain = KeychainSwift()
    
    func save(password: String)  {
        
        keychain.set(password, forKey: "User Password")
    }
    
    func load() -> String {

        return keychain.get("User Password") ?? ""
        
    }
    
    func update(newPassword: String) {
        
        keychain.clear()
        keychain.set(newPassword, forKey: "User Password")
    }
}
