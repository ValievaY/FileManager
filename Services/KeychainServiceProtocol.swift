//
//  KeychainServiceProtocol.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 13.01.2024.
//

import Foundation

protocol KeychainServiceProtocol {
 
    func save(password: String)

    func load() -> String
    
    func update(newPassword: String)
}

