//
//  LoginViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 22/02/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressLoginButton(_ sender: UIButton) {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        print(username)
        print(password)
        Task {
            do {
                let newSession = try await LoginRequest(username: username, password: password ).send()
                
                MLModelNetwork.actualToken = newSession.token
                MLModelNetwork.actualUser = newSession.user
                
                print(MLModelNetwork.actualToken)
                
                performSegue(withIdentifier: "LoginToHomeScreenSegue", sender: nil)
                
            } catch {
                print(error)
            }
        }
        
    }
    
    
    @IBSegueAction func loginToHomeScreenSegue(_ coder: NSCoder, sender: Any?) -> HomeScreenTableViewController? {
        return HomeScreenTableViewController(coder: coder)
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    

}
