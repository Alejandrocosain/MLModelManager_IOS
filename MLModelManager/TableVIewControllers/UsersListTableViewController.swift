//
//  UsersListTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 29/02/24.
//

import UIKit

protocol UsersListTableViewControllerDelegate: AnyObject {
    func userListTableViewController(_ controller: UsersListTableViewController, didSelect user: User)
}

class UsersListTableViewController: UITableViewController {
    
    var userList: [User] = []
    var selectedUser: User?
    var delegate: UsersListTableViewControllerDelegate?
    var typeRoles: String {
        get {return "scientist_scientistSr_administrator"}
    }
    
    init?( selectedUser: User? = nil, coder: NSCoder) {
        self.selectedUser = selectedUser
        super.init(coder: coder)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                print("obteniendo usuarios")
                if typeRoles == "all" {
                    userList = try await AllUsersRequest().send()
                } else {
                    userList = try await RolesUsersRequest(roles: typeRoles).send()
                }
                
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let user = userList[indexPath.row]
        content.text = user.fullName
        content.secondaryText = user.job
        cell.contentConfiguration = content
        
        if user == selectedUser {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    

    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedUser = user
        
        delegate?.userListTableViewController(self, didSelect: user)
        
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
}
