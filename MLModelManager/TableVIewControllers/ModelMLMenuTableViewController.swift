//
//  ModelMLMenuTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 28/02/24.
//

import UIKit

class ModelMLMenuTableViewController: UITableViewController, UsersListTableViewControllerDelegate {
    var selectedUser: User?
    
    
    @IBOutlet var modelNameTextField: UITextField!
    @IBOutlet var ownerNameLabel: UILabel!
    @IBOutlet var modelDescriptionTextField: UITextField!
    @IBOutlet var saveModelButton: UIButton!
    
    func userListTableViewController(_ controller: UsersListTableViewController, didSelect user: User) {
        let selectedUser = controller.selectedUser
        self.selectedUser = selectedUser
        updateUI()
    }
    
    @IBSegueAction func toSelectUserSegue(_ coder: NSCoder, sender: Any?) -> UsersListTableViewController? {
        let userListTableViewController = UsersListTableViewController(selectedUser: selectedUser,coder: coder)
        
        userListTableViewController?.delegate = self
        
        return userListTableViewController
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateUI() {
        if let selectedUser = selectedUser {
            ownerNameLabel.text = selectedUser.fullName
            ownerNameLabel.textColor = .black
        } else {
            ownerNameLabel.text = "Seleccionar Model Owner"
            ownerNameLabel.textColor = .darkGray
        }
        
    }
    
    
    @IBAction func saveButonPressed(_ sender: Any) {
        let name = modelNameTextField.text ?? ""
        let ownerId = selectedUser?.id
        let description = modelDescriptionTextField.text ?? ""
        
        Task{
            do {
                let model = try await SendModelMLRequest(name: name, ownerID: ownerId!, description: description,status: "Nuevo modelo en desarrollo").send()
                print(model)
                performSegue(withIdentifier: "ModelSavedToHomescreen", sender: nil)
                
            } catch {
                print(error)
            }
        }
    }
    
    
    

}
