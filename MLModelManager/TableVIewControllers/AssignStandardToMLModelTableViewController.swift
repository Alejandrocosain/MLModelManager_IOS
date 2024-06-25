//
//  AssignStandardToMLModelTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 15/03/24.
//

import UIKit

class AssignStandardToMLModelTableViewController: UITableViewController {
    
    var standardList: [Standards] = []
    let modelMLID: UUID
    var assignedStandard: [Standards]
    
    init?(modelMLID: UUID, assignedStandard: [Standards], coder: NSCoder) {
        self.modelMLID = modelMLID
        self.assignedStandard = assignedStandard
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
        return standardList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let standard = standardList[indexPath.row]
        content.text = standard.name
        content.secondaryText = standard.description
        
        cell.contentConfiguration = content
        
        
        if assignedStandard.contains(standard) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    

    func updateUI() {
        Task {
            do {
                let updateStandard = try await GetAllStandardRequest().send()
                self.standardList = updateStandard
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standard = standardList[indexPath.row]
        
        if !assignedStandard.contains(standard){
            let alertController = UIAlertController(title: "¿Quieres asignar este estándar al modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default){
                _ in
                Task {
                    do {
                        try await AssignStandardToModelMLRequest(standardId: standard.id, modelmlID: self.modelMLID).send()
                        self.assignedStandard.append(standard)
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController,animated: true)
        } else {
            let alertController = UIAlertController(title: "¿Quieres eliminar este estándar al modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default){
                _ in
                Task {
                    do {
                        try await RemoveStandardOfModelMLRequest(standardID: standard.id, modelmlID: self.modelMLID).send()
                                                            
                        self.assignedStandard = self.assignedStandard.filter({$0.id != standard.id})
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController,animated: true)        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToCreateStandard", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
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

    @IBAction func unwindToAssignStandard(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        updateUI()
    }
}
