//
//  FileManagerService.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 05.01.2024.
//

import UIKit

class FileManagerService: FileManagerServiceProtocol {
    
    var pathForFolder: String
    
    var filePath: URL
    
    var items: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: pathForFolder)) ?? []
    }
    
    init(pathForFolder: String, filePath: URL) {
        self.pathForFolder = pathForFolder
        self.filePath = filePath
    }
    
    init() {
        pathForFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func createFile(imageName: String, image: UIImage) {
    
            let fileURL = filePath.appendingPathComponent(imageName)
            guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }
    }
    
    func createDirectory(name: String) {
        try? FileManager.default.createDirectory(atPath: pathForFolder + "/" + name, withIntermediateDirectories: true)
    }
    
    func removeContent(at index: Int) {
        let path = pathForFolder + "/" + items[index]
        try? FileManager.default.removeItem(atPath: path)
    }
    
    func getPath(at index: Int) -> String {
        pathForFolder + "/" + items[index]
    }
    
    func getPathForFile(at index: Int) -> URL {
        filePath.appending(path: "/" + items[index]) 
    }
    
    func isDirectoryIndex(_ index: Int) -> Bool {
        let item = items[index]
        let path = pathForFolder + "/" + item
        
        var objCBool: ObjCBool = false
        
        FileManager.default.fileExists(atPath: path, isDirectory: &objCBool)
        return objCBool.boolValue
    }
}
