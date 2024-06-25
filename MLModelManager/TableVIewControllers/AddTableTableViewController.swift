//
//  AddTableTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 06/03/24.
//

import UIKit

class AddTableTableViewController: UITableViewController {
    
     
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
     
    var databaseID: UUID!
    
    init?(databaseID: UUID!, coder: NSCoder) {
        self.databaseID = databaseID
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        Task {
            do {
                let saveTable = try await SendTableRequest(databaseID:databaseID , name: name, description: description).send()
                performSegue(withIdentifier: "TableSavedToDBDetail", sender: nil)
                
            } catch {
                print(error)
            }
        }
        
        
    }
    


}
