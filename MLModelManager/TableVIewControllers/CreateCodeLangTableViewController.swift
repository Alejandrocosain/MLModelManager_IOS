//
//  CreateCodeLangTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 13/03/24.
//

import UIKit

class CreateCodeLangTableViewController: UITableViewController {
    
    
    @IBOutlet var langNameTextField: UITextField!
    @IBOutlet var langTypeTextField: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


    }

   
    
    
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        let name = langNameTextField.text ?? ""
        let type = langTypeTextField.text ?? ""
        Task {
            do {
               
                try await CreateCodeLangRequest(name: name, type: type).send()
                performSegue(withIdentifier: "ToAssignLang", sender: nil)
            } catch {
                print(error)
            }
        }
        
        
        
    }
    
    
}
