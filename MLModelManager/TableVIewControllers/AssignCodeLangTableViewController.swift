//
//  AssignCodeLangTableViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 13/03/24.
//

import UIKit




class AssignCodeLangTableViewController: UITableViewController {

    var acceptedCodeLangs: [CodeLang]
    var codeLangList: [CodeLang] = []
    var platformID: UUID
    

    
    init?(acceptedCodeLangs: [CodeLang], platformID: UUID,coder:NSCoder){
        self.acceptedCodeLangs = acceptedCodeLangs
        self.platformID = platformID
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        updateUI()

    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeLangList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "codeLangCell", for: indexPath)
        let codeLang = codeLangList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = codeLang.name
        content.secondaryText = codeLang.type
        
        cell.contentConfiguration = content
        
        if acceptedCodeLangs.contains(codeLang) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let codeLang = codeLangList[indexPath.row]
        
        let stringMessage = acceptedCodeLangs.contains(codeLang) ? "¿Estás seguro de remover este lenguaje?" : "¿Estás seguro de asignar este lenguaje?"
        
        let alertController = UIAlertController(title: nil, message: stringMessage, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Sí", style: .default){
            _ in
            Task {
                do {
                    if self.acceptedCodeLangs.contains(codeLang){
                        try await RemoveLanguageToPlatformRequest(platformId: self.platformID, codelangId: codeLang.id).send()
                        
                        self.acceptedCodeLangs = self.acceptedCodeLangs.filter({$0.id != codeLang.id})
                        self.tableView.reloadData()
                    } else {
                        try await AssignLanguageToPlatformRequest(platformId: self.platformID, codelangId: codeLang.id).send()
                        
                        self.acceptedCodeLangs.append(codeLang)
                        self.tableView.reloadData()
                    }
                    
                    
                } catch {
                    print(error)
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)

    }
    
    @IBAction func unwindToLanguangeAssignation(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        updateUI()
    }
    
    func updateUI() {
        Task {
            do {
                let allLanguages = try await GetAllCodeLangRequest().send()
                
                self.codeLangList = allLanguages
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToCreateCodeLang", sender: nil)
    }
}
