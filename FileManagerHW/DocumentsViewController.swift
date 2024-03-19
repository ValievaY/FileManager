//
//  DocumentsViewController.swift
//  FileManagerHW
//
//  Created by Apple Mac Air on 05.01.2024.
//

import UIKit

final class DocumentsViewController: UIViewController {
    
    private var fileManager: FileManagerServiceProtocol
    private let userDefaults = UserDefaults()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
    
    private lazy var newFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addButtonAction))
    
    init() {
        fileManager = FileManagerService()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(fileManager: FileManagerServiceProtocol) {
        self.fileManager = fileManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        let barItems = [addButton, newFolderButton]
        navigationItem.rightBarButtonItems = barItems
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addButtonAction(button: UIButton) {
        switch button {
        case addButton:
            showImagePicker()
        case newFolderButton:
            let alert = AlertController()
            alert.alert.title = "Create new folder"
            alert.showAlert(in: self,
                            placeholder: "Folder Name",
                            actionText: "OK") { [self] text in
                fileManager.createDirectory(name: text)
                tableView.reloadData()
            }
        default:
            break
        }
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileManager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = fileManager.items[indexPath.row]
        content.secondaryText = fileManager.isDirectoryIndex(indexPath.row) ? "" : fileManager.getSizeOfFile(at: indexPath.row)
        cell.contentConfiguration = content
        if fileManager.isDirectoryIndex(indexPath.row) == true {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.textLabel?.textColor = .black
        header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        header.textLabel?.text = "Documents"
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = fileManager.getPath(at: indexPath.row)
        let pathForFile = fileManager.getPathForFile(at: indexPath.row)
        
        if fileManager.isDirectoryIndex(indexPath.row) == true {
        let fileManager = FileManagerService(pathForFolder: path, filePath: pathForFile)
            let nextViewController = DocumentsViewController(fileManager: fileManager)
            navigationController?.pushViewController(nextViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
       }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManager.removeContent(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
       
        guard let imageUrl = info[.imageURL] as? URL else { return }
            
        let name = imageUrl.lastPathComponent
        
        fileManager.createFile(imageName: name, image: image)
        tableView.reloadData()
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
