//
//  AssignDatabaseToMLModelTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 15/03/24.
//

import UIKit

class AssignDatabaseToMLModelTableViewController: UITableViewController {
    
    var databaseList: [DatabaseKelpel] = []
    let modelMLID: UUID
    var assignedDatabases: [DatabaseKelpel]

    init?(modelMLID:UUID,assignedDatabases: [DatabaseKelpel], coder: NSCoder) {
       
        self.modelMLID = modelMLID
        self.assignedDatabases = assignedDatabases
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      updateUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return databaseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatabaseCell", for: indexPath)
        let database = databaseList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = database.name
        content.secondaryText = "\(database.tables.count) Tables"

        cell.contentConfiguration = content
        
        if assignedDatabases.contains(database) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
            
        }
        return cell
    }
    
    func updateUI() {
        Task {
            do {
                let updateDatabase = try await DatabaseAdminRequest().send()
                self.databaseList = updateDatabase
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let database = databaseList[indexPath.row]
        
        if !assignedDatabases.contains(database){
            let alertController = UIAlertController(title: "¿Quieres asignar la base de datos \(database.name) al modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default) {
                _ in
                Task{
                    do {
                        try await AssignDatabaseoModelMLRequest(databaseID: database.id, modelmlID: self.modelMLID).send()
                        self.assignedDatabases.append(database)
                        self.updateUI()
                    } catch {
                        print(error)
                    }
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
            
            
        } else {
            let alertController = UIAlertController(title: "¿Quieres eliminar la base de datos \(database.name) del modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default) {
                _ in
                Task{
                    do {
                        try await RemoveDatabaseToModelMLRequest(databaseID: database.id, modelmlID: self.modelMLID).send()
                        self.assignedDatabases = self.assignedDatabases.filter({$0.id != database.id})
                        self.updateUI()
                    } catch {
                        print(error)
                    }
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
            
        }
      
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
