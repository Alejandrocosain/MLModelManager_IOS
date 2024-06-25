//
//  CreateStandardTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 19/03/24.
//

import UIKit

class CreateStandardTableViewController: UITableViewController {
    
    @IBOutlet var standardNameTextField: UITextField!
    
    
    @IBOutlet var standardTypeTextField: UITextField!
    
    @IBOutlet var standardDescriptionTextField: UITextField!
    
    @IBOutlet var saveStandardTextField: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonStatus()
    }
    
    func updateSaveButtonStatus() {
        let name = standardNameTextField.text ?? ""
        let type = standardTypeTextField.text ?? ""
        let description = standardDescriptionTextField.text ?? ""
        
        if !name.isEmpty, !type.isEmpty, !description.isEmpty {
            saveStandardTextField.isEnabled = true
        } else {
            saveStandardTextField.isEnabled = false
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let name = standardNameTextField.text ?? ""
        let type = standardTypeTextField.text ?? ""
        let description = standardDescriptionTextField.text ?? ""
        
        Task {
            do {
                try await SendStandardRequest(name: name, type: type, description: description).send()
                performSegue(withIdentifier: "FromCreateStandardToCreateStandard", sender: nil)
            } catch {
                print(error)
            }
        }
        
    }
    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    
    @IBAction func typeTextFieldChanged(_ sender: UITextField) {
        updateSaveButtonStatus()

    }
    
    @IBAction func descriptionTextFieldChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    
}
