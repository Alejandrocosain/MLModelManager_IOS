//
//  HomeScreenTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import UIKit

class HomeScreenTableViewController: UITableViewController {
    
    var databasesKelpel: [DatabaseKelpel] = []
    var platforms: [Platform] = []
    var modelsML: [ModelML] = []
    var modelMLPlatformPivots: [ModelMLPlatformPivot] = []
    var modelMLDatabasePivots: [ModelMLDatabasePivot] = []
    var modelMLStandardPivots: [ModelMLStandardPivotPublic] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        title = MLModelNetwork.actualUser?.fullName
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return databasesKelpel.count
        case 1:
            return platforms.count
        case 2:
            return modelsML.count
        case 3:
            return modelMLPlatformPivots.count
        case 4:
            return modelMLDatabasePivots.count
        case 5:
            return modelMLStandardPivots.count
        default:
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            let databaseKelpel = databasesKelpel[indexPath.row]
            content.text = databaseKelpel.name
            content.secondaryText = "\(databaseKelpel.tables.count) tables"
        case 1:
            let platform = platforms[indexPath.row]
            content.text = platform.name
            content.secondaryText = "\(platform.codeLangs.map({$0.name}))"
        case 2:
            let modelML = modelsML[indexPath.row]
            content.text = modelML.name
            content.secondaryText =  modelML.status
        case 3:
            let modelMLPlatformPivot = modelMLPlatformPivots[indexPath.row]
            content.text = modelMLPlatformPivot.modelML.name
            content.secondaryText = modelMLPlatformPivot.platform.name
        case 4:
            let modelMLDatabasePivot = modelMLDatabasePivots[indexPath.row]
            content.text = modelMLDatabasePivot.modelML.name
            content.secondaryText = modelMLDatabasePivot.database.name
        case 5:
            let modelMLStandardPivot = modelMLStandardPivots[indexPath.row]
            content.text = modelMLStandardPivot.modelML.name
            content.secondaryText = modelMLStandardPivot.standard.name
            
        default:
            content.text = "error"
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch section {
        case 0:
            return databasesKelpel.count > 0 ? "Bases de datos" : nil
        case 1:
            return platforms.count > 0 ? "Plataformas" : nil
        case 2:
            return modelsML.count > 0 ? "Modelos" : nil
        case 3:
            return modelMLPlatformPivots.count > 0 ? "Peticiones para asignar plataforma" : nil
        case 4:
            return modelMLDatabasePivots.count > 0 ? "Peticiones para asignar base de datos" : nil
        case 5 :
            return modelMLStandardPivots.count > 0 ? "Peticiones para aprobar funcionalidades" : nil
        default:
            return nil
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "¿Qué deseas agregar?", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let databaseAction = UIAlertAction(title: "Base de datos", style: .default){
            _ in
            self.performSegue(withIdentifier: "HomeScreenToDatabaseCreation", sender: nil)
        }

        let platformAction = UIAlertAction(title: "Plataforma", style: .default) {
            _ in
            self.performSegue(withIdentifier: "HomescreenToPlatformCreation", sender: nil)
        }
        let modelMLAction = UIAlertAction(title: "Modelo", style: .default) {
            _ in
            self.performSegue(withIdentifier: "HomescreenToModelMLCreation", sender: nil)
            
        }
    
        
        alertController.addAction(databaseAction)
        alertController.addAction(platformAction)
        alertController.addAction(modelMLAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let databaseKelpel = databasesKelpel[indexPath.row]
            performSegue(withIdentifier: "ToDatabaseInfo", sender: nil)
        case 1:
            let platform = platforms[indexPath.row]
            performSegue(withIdentifier: "ToPlatformInfo", sender: nil)
        case 2:
            let modelML = modelsML[indexPath.row]
            performSegue(withIdentifier: "ToMLModelDetail", sender: nil)
        case 3:
            let platform = modelMLPlatformPivots[indexPath.row].platform
            let model = modelMLPlatformPivots[indexPath.row].modelML
            let platformActionMenu = UIAlertController(title: "Seleccione acción", message: "¿Aceptas la solicitud del modelo \(model.name) a conectarse a la plataforma \(platform.name)?", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Aceptar", style: .default){
                _ in
                Task{
                    do{
                        try await AcceptPlatformAssignationRequest(platformID: platform.id, modelmlID: model.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let rejectAction = UIAlertAction(title: "Rechazar", style: .default){
                _ in
                Task{
                    do{
                        try await RejectPlatformAssignationRequest(platformID: platform.id, modelmlID: model.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            platformActionMenu.addAction(acceptAction)
            platformActionMenu.addAction(rejectAction)
            platformActionMenu.addAction(cancelAction)
            present(platformActionMenu, animated: true)
        case 4:
            let database = modelMLDatabasePivots[indexPath.row].database
            let model = modelMLDatabasePivots[indexPath.row].modelML
            let databaseActionMenu = UIAlertController(title: "Seleccione acción", message: "¿Aceptas la solicitud del modelo \(model.name) a conectarse a la base de datos \(database.name)?", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Aceptar", style: .default){
                _ in
                Task{
                    do{
                        try await AcceptDatabaseAssignationRequest(databaseID: database.id, modelmlID: model.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let rejectAction = UIAlertAction(title: "Rechazar", style: .default){
                _ in
                Task{
                    do{
                        try await RejectDatabaseAssignationRequest(databaseID: database.id, modelmlID: model.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            databaseActionMenu.addAction(acceptAction)
            databaseActionMenu.addAction(rejectAction)
            databaseActionMenu.addAction(cancelAction)
            present(databaseActionMenu, animated: true)
        case 5:
            let standard = modelMLStandardPivots[indexPath.row].standard
            let model = modelMLStandardPivots[indexPath.row].modelML
            let standardActionMenu = UIAlertController(title: "Seleccione acción", message: "¿Apruebas la programación de la funcionalidad \(standard.name) en el modelo \(model.name)?", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Aceptar", style: .default){
                _ in
                Task{
                    do{
                        try await AcceptStandardPetitionRequest(modelmlID: model.id,standardID: standard.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let rejectAction = UIAlertAction(title: "Rechazar", style: .default){
                _ in
                Task{
                    do{
                        try await RejectStandardPetitionRequest( modelmlID: model.id, standardID: standard.id).send()
                        self.updateUI()
                    } catch{
                        print(error)
                    }
                }
             
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            standardActionMenu.addAction(acceptAction)
            standardActionMenu.addAction(rejectAction)
            standardActionMenu.addAction(cancelAction)
            present(standardActionMenu, animated: true)

        default:
            print("error")
        }
        
    }
    
    @IBSegueAction func toDatabaseDetail(_ coder: NSCoder, sender: Any?) -> DatabaseDetailCollectionViewController? {
        let databaseKelpel = databasesKelpel[tableView.indexPathForSelectedRow!.row]
        print(databaseKelpel)
        
        return DatabaseDetailCollectionViewController(databaseKelpel: databaseKelpel, coder: coder)
    }
    
    @IBSegueAction func toPlatformDetail(_ coder: NSCoder, sender: Any?) -> PlatformDetailCollectionViewController? {
        
        let platform = platforms[tableView.indexPathForSelectedRow!.row]
        
        return PlatformDetailCollectionViewController(platform: platform, coder: coder)
    }
    
    
    @IBSegueAction func toMLModelDetail(_ coder: NSCoder, sender: Any?) -> MLModelDetailCollectionViewController? {
        let modelML = modelsML[tableView.indexPathForSelectedRow!.row]
        
        return MLModelDetailCollectionViewController(modelML: modelML, coder: coder)
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
    
    func updateUI() {
            
            Task {
                do {
                    var newDatabases: [DatabaseKelpel]
                    var newPlatform: [Platform]
                    var newModelML: [ModelML]
                    var newModelMLPlatformPivots: [ModelMLPlatformPivot]
                    var newModelMLDatabasePivots: [ModelMLDatabasePivot]
                    var newModelMLStandardPivots: [ModelMLStandardPivotPublic]
                    
                    if MLModelNetwork.actualUser?.role != "administrator"{
                         newDatabases = try await DatabaseUserRequest().send()
                         newPlatform = try await PlatformUserRequest().send()
                         newModelML = try await ModelMLUserRequest().send()
                        newModelMLPlatformPivots = try await GetModelPlatformAssignationRequest().send()
                        newModelMLDatabasePivots = try await GetModelDatabaseAssignationRequest().send()
                        newModelMLStandardPivots = try await GetAllPendingStandardsRequest().send()
        

                    } else {

                         newDatabases = try await DatabaseAdminRequest().send()
                         newPlatform = try await PlatformAdminRequest().send()
                         newModelML = try await ModelMLAdminRequest().send()
                        newModelMLPlatformPivots = try await GetModelPlatformAssignationRequestAdmin().send()
                        newModelMLDatabasePivots = try await GetModelDatabaseAssignationRequestAdmin().send()
                        newModelMLStandardPivots = try await GetAllPendingStandardsRequestAdmin().send()

                    }
                    
                    self.databasesKelpel = newDatabases
                    self.platforms = newPlatform
                    self.modelsML = newModelML
                    self.modelMLPlatformPivots = newModelMLPlatformPivots
                    self.modelMLDatabasePivots = newModelMLDatabasePivots
                    self.modelMLStandardPivots = newModelMLStandardPivots
                    self.tableView.reloadData()
                    
                } catch {
                    print(error)
                }
            }
        
    }
    
    @IBAction func unwindToHomescreen(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    

}
