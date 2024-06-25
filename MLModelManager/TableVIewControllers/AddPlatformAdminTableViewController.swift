//
//  AddPlatformAdminTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 13/03/24.
//

import UIKit

class AddPlatformAdminTableViewController: UsersListTableViewController {
    var platformID: UUID
    override var typeRoles: String {
        get {return "architect_architectSr_administrator"}
    }
    init?(platformID: UUID,coder:NSCoder) {
        self.platformID = platformID
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
                    try await SendAssignPlatAdminRequest(platformID: self.platformID, userID: user.id).send()
                    self.performSegue(withIdentifier: "AssignAdminToPlatformDetail", sender: nil)
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
