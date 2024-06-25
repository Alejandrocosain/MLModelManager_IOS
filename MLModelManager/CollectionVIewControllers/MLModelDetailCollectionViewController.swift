//
//  PlatformDetailCollectionViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 12/03/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class MLModelDetailCollectionViewController: UICollectionViewController {
        
    enum Section: Hashable {
        case description
        case owner
        case database
        case platform
        case standard
    }
    
    var modelML: ModelML
    
    init?(modelML: ModelML, coder: NSCoder) {
        self.modelML = modelML
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var descriptionItems: [MLModelDetailItem] = []
    var ownerItem: MLModelDetailItem?
    var databasesKelpelItems: [MLModelDetailItem] = []
    var platformsItems: [MLModelDetailItem] = []
    var standardsItems: [MLModelDetailItem] = []
    var standardsOfModel: [ModelMLStandardPivot] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MLModelDetailItem>!
    var sections = [Section]()
    
    var snapshot: NSDiffableDataSourceSnapshot<Section, MLModelDetailItem>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, MLModelDetailItem>()
        
        snapshot.appendSections([.description])
        snapshot.appendItems(descriptionItems,toSection: .description)
        
        snapshot.appendSections([.owner])

        if let ownerItem = ownerItem {
            snapshot.appendItems([ownerItem], toSection: .owner)
        }
        
        
            snapshot.appendSections([.database])
            snapshot.appendItems(databasesKelpelItems, toSection: .database)
       
        
    
            snapshot.appendSections([.platform])
            snapshot.appendItems(platformsItems, toSection: .platform)
        
        
            snapshot.appendSections([.standard])
            snapshot.appendItems(standardsItems, toSection: .standard)
            snapshot.reloadItems(standardsItems)
        
        print(databasesKelpelItems)
        print(platformsItems)
        
        self.sections = snapshot.sectionIdentifiers
        print(self.sections)
        return snapshot
    }
    
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            print(indexPath)
            print(item)
            let section = self.sections[indexPath.section]
            
            switch section {
            case .description:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MlModelDetailCell", for: indexPath) as! SimpleLabelMlModelCollectionViewCell
                
                let title = item.description![0]
                let subtitle = item.description![1]
                
                cell.mlModelTitleLabel.text = title
                cell.mlModelTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.mlModelSubtitleLabel.text = subtitle
                
                return cell
                
            case .owner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MlModelDetailCell", for: indexPath) as! SimpleLabelMlModelCollectionViewCell
                let user = item.owner!
                
                cell.mlModelTitleLabel.text = "Administrador:"
                cell.mlModelTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.mlModelSubtitleLabel.text = user.fullName

                return cell
            
            case .platform:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MlModelDetailCell", for: indexPath) as! SimpleLabelMlModelCollectionViewCell
                let progLanguage = item.platform!
                cell.mlModelTitleLabel.text = nil

                cell.mlModelSubtitleLabel.text = progLanguage.name
                return cell
                
            case .database:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MlModelDetailCell", for: indexPath) as! SimpleLabelMlModelCollectionViewCell
                let model = item.database!
                
                cell.mlModelTitleLabel.text = model.name
                cell.mlModelTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.mlModelSubtitleLabel.text = nil
                return cell
                
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MlModelDetailCell", for: indexPath) as! SimpleLabelMlModelCollectionViewCell
                let model = item.standard!
                
                cell.mlModelTitleLabel.text = model.name
                cell.mlModelTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.mlModelSubtitleLabel.text = nil
                
                let standardStatus = self.standardsOfModel.filter{$0.standard.id == model.id }.first
                
                if standardStatus?.validated == 0, standardStatus?.toValidate == 0 {
                    cell.mlModelSubtitleLabel.text = "No validado"
                } else if standardStatus?.toValidate == 1 {
                    cell.mlModelSubtitleLabel.text = "En espera de validación"
                } else {
                    cell.mlModelSubtitleLabel.text = "Validado"
                }
                
                return cell
                
            }
            
            
            
        }
        dataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "headerView", for: indexPath) as! NameSectionHeaderView
            
            let section = self.sections[indexPath.section]
            switch section {
            case .description:
                header.nameLabel.text = "Detalles del modelo"
            case .owner:
                header.nameLabel.text = "Administrador"
            case .database:
                header.nameLabel.text = "Bases de datos registradas"
            case .platform:
                header.nameLabel.text = "Plataformas registradss"
            case .standard:
                header.nameLabel.text = "Reglas registradas"
            }
            
            return header
            
        }
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "sectionHeader",alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout  = createLayout()
        collectionView.register(NameSectionHeaderView.self, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: "headerView")
        updateUI()
        
        
    
    }
    
    func updateUI() {
        
        
        Task {
            do {
                let updateMLModel = try await GetSpecificModelMLRequest(mlModelID: self.modelML.id).send()
                let updateStandardList = try await GetModelStandardStatusRequest(modelmlID: self.modelML.id).send()
                
                
                self.modelML = updateMLModel
                self.standardsOfModel = updateStandardList
                
                self.descriptionItems = [.description(["Nombre:", modelML.name]),
                                         .description(["Descripción:", modelML.description]),
                                         .description(["Estatus:", modelML.status]),
                                         .description(["Versión:", String(modelML.latestVersionValidated)])]
                
                self.ownerItem = .owner(modelML.owner)

                self.databasesKelpelItems = modelML.databases.map({.database($0)})
                print(self.databasesKelpelItems)
                self.platformsItems = modelML.platforms.map({.platform($0)})
                self.standardsItems = modelML.standards.map({.standard($0)})
                
                
                await dataSource.apply(snapshot)
                
                
                
                
            } catch {
                print(error)
            }
        }
        
        
    }
    
    @IBAction func actionButtonSelected(_ sender: UIBarButtonItem) {
        
        let alertContoller = UIAlertController()
        
        if MLModelNetwork.actualUser?.id == modelML.owner.id || MLModelNetwork.actualUser?.role == "administrator" || MLModelNetwork.actualUser?.id == modelML.modelCreator.id  {
            
            let assignPlatformAction = UIAlertAction(title: "Asignar plataforma", style: .default) {
                _ in
                self.performSegue(withIdentifier: "ToAssignPlatform", sender: nil)
            }
            
            alertContoller.addAction(assignPlatformAction)
            
            let assignDatabaseAction = UIAlertAction(title: "Asignar base de datos", style: .default){
            _ in
            self.performSegue(withIdentifier: "FromMLModelToAssignDatabase", sender: nil)
            }
            alertContoller.addAction(assignDatabaseAction)
            
            let assignStandardAction = UIAlertAction(title: "Asignar estándar", style: .default){
                _ in
                self.performSegue(withIdentifier: "FromMLModelToAssignStandard", sender: nil)
            }
            alertContoller.addAction(assignStandardAction)
            
            
            if modelML.status == "Listo para desplegar" {
                let deployAction = UIAlertAction(title: "Desplegar modelo en productivo", style: .default) {
                    _ in
                    let confirmController = UIAlertController(title: "¿Estás seguro de desplegar el modelo?", message: nil, preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Sí", style: .default) {
                        _ in
                        Task {
                            do {
                                try await DeployModelMLRequest(modelmlID: self.modelML.id).send()
                                self.updateUI()
                            } catch {
                                print(error)
                            }
                        }
                    }
                    let noAction = UIAlertAction(title: "Cancelar", style: .cancel)
                    
                    confirmController.addAction(yesAction)
                    confirmController.addAction(noAction)
                    self.present(confirmController, animated: true)
                    
                }
                alertContoller.addAction(deployAction)
            }
        }
//        
//        if MLModelNetwork.actualUser?.role == "administrator" {
//            if let platAdmin = platform.platAdmin {
//                let removeAdmin = UIAlertAction(title: "Quitar Administrador", style: .default){
//                    _ in
//                    let alertController2 = UIAlertController(title: "Are you sure to remove \(platAdmin.fullName) as admin?", message: nil, preferredStyle: .alert)
//                    let yesAction = UIAlertAction(title: "yes", style: .default){
//                        _ in
//                        Task {
//                            do {
//                                try await SendRemovePlatAdminRequest(platformID: self.platform.id, userID: platAdmin.id).send()
//                                let updatePlatform = try await GetSpecificPlatformRequest(platformID: self.platform.id).send()
//                                self.platform = updatePlatform
//                                
//                                self.updateUI()
//                            } catch {
//                                print(error)
//                            }
//                        }
//                        
//                        
//                    }
//                    
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//                    
//                    alertController2.addAction(yesAction)
//                    alertController2.addAction(cancelAction)
//                    self.present(alertController2,animated: true)
//                
//                }
//                alertContoller.addAction(removeAdmin)
//            } else {
//                let addAdmin = UIAlertAction(title: "Asignar Administrador", style: .default) {
//                    _ in
//                    self.performSegue(withIdentifier: "platformDetailToAssignAdmin", sender: nil)
//                }
//                alertContoller.addAction(addAdmin)
//            }
//        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alertContoller.addAction(cancelAction)
        present(alertContoller,animated: true)
//        
        
            
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPaths.count>0 else {
            return nil
    
        }
        let section = self.sections[indexPaths[0].section]
        
        guard  section == .standard else {
            return nil
        }
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {
            (elements) -> UIMenu? in
            guard let item = self.dataSource.itemIdentifier(for: indexPaths[0]) else {
                return nil
            }
            let validated = self.standardsOfModel.filter{$0.standard.id == item.standard!.id}.first!.validated
            let toValidate = self.standardsOfModel.filter{$0.standard.id == item.standard!.id}.first!.toValidate
            
            var stringAction: String = ""
            
            switch( validated, toValidate){
            case (0,0) :
                stringAction = "Mandar petición para validar"
            case (1,0):
                stringAction = "Desvalidar"
            default:
                stringAction = "No aplica"
            }
            
            guard toValidate == 0 else {return nil}
            
            let validateToggle = UIAction(title: stringAction) {
                (action) in
                
                Task{
                    do{
                        if validated == 0 {
                           try await ValidatePetitionStandardOfModelMLRequest(standardID: item.standard!.id, modelmlID: self.modelML.id).send()
                        } else {
                           try await UnvalidateStandardOfModelMLRequest(standardID: item.standard!.id, modelmlID: self.modelML.id).send()

                        }
                        self.updateUI()

                    } catch {
                        print(error)
                    }
                }
                
               
                
                
                

            }
            return UIMenu(title: "",image: nil, options: [],children: [validateToggle])
        }
        
        return config

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
   
    @IBAction func unwindToMLModelDetail(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        
        updateUI()
       
    }
    
    
    
    @IBSegueAction func modelDetailToAssignPlatform(_ coder: NSCoder, sender: Any?) -> AssignPlatformToModelTableViewController? {
        
        return AssignPlatformToModelTableViewController(modelMLID: modelML.id,assignedPlatforms: modelML.platforms, coder: coder)
    }
    
    @IBSegueAction func modelDetailToAssignDatabase(_ coder: NSCoder, sender: Any?) -> AssignDatabaseToMLModelTableViewController? {
        return AssignDatabaseToMLModelTableViewController(modelMLID: modelML.id, assignedDatabases: modelML.databases, coder: coder)
    }
    
    
    @IBSegueAction func modelDetailToAssignStandard(_ coder: NSCoder, sender: Any?) -> AssignStandardToMLModelTableViewController? {
        return AssignStandardToMLModelTableViewController(modelMLID: modelML.id, assignedStandard: modelML.standards, coder: coder)
    }
    


}


