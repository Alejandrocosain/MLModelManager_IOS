//
//  DatabaseMenuTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 28/02/24.
//

import UIKit

class DatabaseMenuTableViewController: UITableViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var iPTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let ip = iPTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        Task {
            do {
                let newDatabase = try await SendDatabaseRequest(name: name, ip: ip, description: description).send()
                print(newDatabase)
                performSegue(withIdentifier: "DatabaseSavedToHomescreen", sender: nil)
            } catch {
                print(error)
            }
        }
        
        
    }
    
    
    

    
}
