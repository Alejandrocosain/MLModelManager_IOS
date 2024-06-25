//
//  AddDatabaseAdministratorTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 06/03/24.
//

import UIKit

class AddDatabaseAdministratorTableViewController: UsersListTableViewController {
    
    var databaseID: UUID
    override var typeRoles: String {
        get {return "engineer_engineerSr_administrator"}
    }
    init?(databaseID: UUID,coder:NSCoder) {
        self.databaseID = databaseID
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "¿Estas seguro?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Sí", style: .default) {
            _ in
            Task {
                do {
                    try await SendAssignDBAdminRequest(databaseID: self.databaseID, userID: user.id).send()
                    self.performSegue(withIdentifier: "AdminAssignToDBDetail", sender: nil)
                } catch {
                    print(error)
                }
            }
        }
        let cancelAction = UIAlertAction(title:"Cancelar", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
    }


  

}
