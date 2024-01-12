//
//  FileManagerServiceProtocol.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 05.01.2024.
//

import UIKit

protocol FileManagerServiceProtocol {
    
    var pathForFolder: String {get}
    
    var filePath: URL {get}
    
    var items: [String] {get}
    
    func createFile(imageName: String, image: UIImage)
    
    func createDirectory(name: String)
    
    func removeContent(at index: Int)
    
    func getPath(at index: Int) -> String
    
    func getPathForFile(at index: Int) -> URL
    
    func isDirectoryIndex(_ index: Int) -> Bool 
}
