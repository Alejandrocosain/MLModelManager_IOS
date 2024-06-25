//
//  AssignPlatformToModelTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 15/03/24.
//

import UIKit

class AssignPlatformToModelTableViewController: UITableViewController {
    
    var platformList: [Platform] = []
    let modelMLID: UUID
    var assignedPlatforms: [Platform]

    init?(modelMLID:UUID,assignedPlatforms: [Platform], coder: NSCoder) {
       
        self.modelMLID = modelMLID
        self.assignedPlatforms = assignedPlatforms
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
        return platformList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformListCell", for: indexPath)
        let platform = platformList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = platform.name
        content.secondaryText = "\(platform.codeLangs.map({$0.name}))"
        
        cell.contentConfiguration = content
        
        if assignedPlatforms.contains(platform) {
            cell.accessoryType = .checkmark

        } else {
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    func updateUI() {
        Task{
            do {
                let updatePlatforms = try await PlatformAdminRequest().send()
                self.platformList = updatePlatforms
                tableView.reloadData()
                
            } catch {
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let platform = platformList[indexPath.row]
        
        if !assignedPlatforms.contains(platform){
            let alertController = UIAlertController(title: "¿Quieres asignar la plataforma \(platform.name) al modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default) {
                _ in
                Task{
                    do {
                        try await AssignPlatformToModelMLRequest(platformId: platform.id, modelmlID: self.modelMLID).send()
                        self.assignedPlatforms.append(platform)
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
            let alertController = UIAlertController(title: "¿Quieres eliminar la plataforma \(platform.name) del modelo?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Sí", style: .default) {
                _ in
                Task{
                    do {
                        try await RemovePlatformToModelMLRequest(platformId: platform.id, modelmlID: self.modelMLID).send()
                        self.assignedPlatforms = self.assignedPlatforms.filter({$0.id != platform.id})
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
    
    
    

}
