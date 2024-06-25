//
//  SignupTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 23/02/24.
//

import UIKit

class SignupTableViewController: UITableViewController {
    
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var numEmpleadoTextfield: UITextField!
    @IBOutlet var puestoTextfield: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var roleButton: UIButton!
    
    let posibleRoles = ["user", "administrator", "scientist","scientistSr", "engineer", "engineerSr", "architect", "architectSr"]
    
    
    
    let actionClosure = { (action: UIAction) in
         print(action.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menuChildren: [UIMenuElement] = []
        let handlerAction = {
            (action: UIAction) in
            print(action.title)
        }
        for role in posibleRoles{
            menuChildren.append(UIAction(title: role, handler: handlerAction))
        }
        
        roleButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        roleButton.showsMenuAsPrimaryAction = true
        
        roleButton.changesSelectionAsPrimaryAction = true
        
        

    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        let username = usernameTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        let confirmpassword = confirmPasswordTextfield.text ?? ""
        let fullname = nameTextfield.text ?? ""
        let puesto = puestoTextfield.text ?? ""
        let numeroEmpleado = numEmpleadoTextfield.text ?? ""
        let role = roleButton.titleLabel?.text ?? ""

        Task{
            do{
                let newSession = try await SignupRequest(username: username, password: password, role: role, fullName: fullname, employeeId: Int(numeroEmpleado)! , job: puesto).send()
                
                MLModelNetwork.actualToken = newSession.token
                MLModelNetwork.actualUser = newSession.user
                
                print(MLModelNetwork.actualUser)
                print(MLModelNetwork.actualToken)
                
                let alertController = UIAlertController(title: "Cuenta creada exitosamente", message: nil, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default){
                    _ in
                    
                    self.performSegue(withIdentifier: "SignupToLogin", sender: nil)

                }
                alertController.addAction(okAction)
                self.present(alertController,animated: true)
            
                
            }catch{
                print(error)
            }
        }
    }
    
    
    


}
