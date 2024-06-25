//
//  PlatformMenuTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 28/02/24.
//

import UIKit

class PlatformMenuTableViewController: UITableViewController {
    
    
    @IBOutlet var platformNameTextField: UITextField!
    @IBOutlet var platformIPTextField: UITextField!
    @IBOutlet var platformDescriptionTextField: UITextField!
    @IBOutlet var savePlatformButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func savePressed(_ sender: Any) {
        let name = platformNameTextField.text ?? ""
        let ip = platformIPTextField.text ?? ""
        let description = platformDescriptionTextField.text ?? ""
        
        Task {
            do {
                let newPlatform = try await SendPlatformRequest(name: name, ip: ip, description: description).send()
                print(newPlatform)
                performSegue(withIdentifier: "PlatformSavedToHomescreen", sender: nil)
                
                
            } catch {
                print(error)
            }
        }
        
        
        
    }
    
    
    
   
}
