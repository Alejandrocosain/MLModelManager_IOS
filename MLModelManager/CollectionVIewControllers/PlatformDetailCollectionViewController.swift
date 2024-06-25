//
//  PlatformDetailCollectionViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 12/03/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class PlatformDetailCollectionViewController: UICollectionViewController {
        

 
    enum Section: Hashable {
        case description
        case platAdmin
        case models
        case progLanguages
    }
    
    var platform: Platform
    
    init?(platform: Platform, coder: NSCoder) {
        self.platform = platform
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var descriptionItems: [PlatformDetailItem] = []
    var platAdminItem: PlatformDetailItem?
    var progLanguagesItems: [PlatformDetailItem] = []
    var mlModelItems: [PlatformDetailItem] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PlatformDetailItem>!
    var sections = [Section]()
    
    var snapshot: NSDiffableDataSourceSnapshot<Section, PlatformDetailItem>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlatformDetailItem>()
        
        snapshot.appendSections([.description])
        snapshot.appendItems(descriptionItems,toSection: .description)
        
        if let platAdminItem = platAdminItem {
            snapshot.appendSections([.platAdmin])
            snapshot.appendItems([platAdminItem], toSection: .platAdmin)
        }
        
        if progLanguagesItems.count > 0 {
            snapshot.appendSections([.progLanguages])
            snapshot.appendItems(progLanguagesItems, toSection: .progLanguages)
        }
        
        if mlModelItems.count > 0 {
            snapshot.appendSections([.models])
            snapshot.appendItems(mlModelItems, toSection: .models)
        }
        
        self.sections = snapshot.sectionIdentifiers
        
        return snapshot
    }
    
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let section = self.sections[indexPath.section]
            
            switch section {
            case .description:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformDetailCell", for: indexPath) as! SimpleLabelPlatformCollectionViewCell
                
                let title = item.description![0]
                let subtitle = item.description![1]
                
                cell.platformTitleLabel.text = title
                cell.platformTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.platformSubtitleLabel.text = subtitle
                
                return cell
                
            case .platAdmin:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformDetailCell", for: indexPath) as! SimpleLabelPlatformCollectionViewCell
                let user = item.platAdmin!
                
                cell.platformTitleLabel.text = "Administrador:"
                cell.platformTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.platformSubtitleLabel.text = user.fullName

                return cell
            
            case .progLanguages:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformDetailCell", for: indexPath) as! SimpleLabelPlatformCollectionViewCell
                let progLanguage = item.progLanguages!
                cell.platformTitleLabel.text = nil

                cell.platformSubtitleLabel.text = progLanguage.name
                return cell
                
            case .models:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformDetailCell", for: indexPath) as! SimpleLabelPlatformCollectionViewCell
                let model = item.model!
                
                cell.platformTitleLabel.text = model.name
                cell.platformTitleLabel.font = .boldSystemFont(ofSize:17 )

                cell.platformSubtitleLabel.text = nil
                return cell
                
            }
            
            
            
        }
        dataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "headerView", for: indexPath) as! NameSectionHeaderView
            
            let section = self.sections[indexPath.section]
            switch section {
            case .description:
                header.nameLabel.text = "Detalles de Plataforma"
            case .platAdmin:
                header.nameLabel.text = "Administrador"
            case .models:
                header.nameLabel.text = "Modelos registrados"
            case .progLanguages:
                header.nameLabel.text = "Lenguajes registradss"
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
                let updatePlatform = try await GetSpecificPlatformRequest(platformID: platform.id).send()
                self.platform = updatePlatform
                
                self.descriptionItems = [.description(["Nombre:", platform.name]),
                                         .description(["Ip:", platform.ip]),
                                         .description(["Descripción:", platform.description])]
                
                if let platAdmin = platform.platAdmin {
                    self.platAdminItem = .platAdmin(platAdmin)

                } else {
                    self.platAdminItem = nil
                }
                
                self.progLanguagesItems = platform.codeLangs.map({PlatformDetailItem.progLanguages($0)})
                
                
                await dataSource.apply(snapshot)
                
                
                Task {
                    do {
                        let platformModelList = try await GetPlatformModelsRequest(platformID: platform.id).send()
                        self.mlModelItems = platformModelList.map({PlatformDetailItem.model($0)})
                        await dataSource.apply(snapshot)
                        
                    } catch {
                 print(error)
                    }
                }
                
                
                
            } catch {
                print(error)
            }
        }
        
       
    
        
    }
    
    @IBAction func actionButtonSelected(_ sender: UIBarButtonItem) {
        
        let alertContoller = UIAlertController()
        
        if MLModelNetwork.actualUser?.id == platform.platAdmin?.id || MLModelNetwork.actualUser?.role == "administrator" || MLModelNetwork.actualUser?.id == platform.platformCreator.id  {
            
            let addProgLanguageAction = UIAlertAction(title: "Agregar Lenguaje", style: .default) {
                _ in
                self.performSegue(withIdentifier: "PlatformDetailToCreateLanguage", sender: nil)
            }
            
            alertContoller.addAction(addProgLanguageAction)
            
        }
        
        if MLModelNetwork.actualUser?.role == "administrator" || MLModelNetwork.actualUser?.id == platform.platformCreator.id {
            if let platAdmin = platform.platAdmin {
                let removeAdmin = UIAlertAction(title: "Quitar Administrador", style: .default){
                    _ in
                    let alertController2 = UIAlertController(title: "Are you sure to remove \(platAdmin.fullName) as admin?", message: nil, preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "yes", style: .default){
                        _ in
                        Task {
                            do {
                                try await SendRemovePlatAdminRequest(platformID: self.platform.id, userID: platAdmin.id).send()
                                let updatePlatform = try await GetSpecificPlatformRequest(platformID: self.platform.id).send()
                                self.platform = updatePlatform
                                
                                self.updateUI()
                            } catch {
                                print(error)
                            }
                        }
                        
                        
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    alertController2.addAction(yesAction)
                    alertController2.addAction(cancelAction)
                    self.present(alertController2,animated: true)
                
                }
                alertContoller.addAction(removeAdmin)
            } else {
                let addAdmin = UIAlertAction(title: "Asignar Administrador", style: .default) {
                    _ in
                    self.performSegue(withIdentifier: "platformDetailToAssignAdmin", sender: nil)
                }
                alertContoller.addAction(addAdmin)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alertContoller.addAction(cancelAction)
        present(alertContoller,animated: true)
        
        
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
   
    @IBAction func unwindToPlatformDetail(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        updateUI()
       
    }
    
    

    @IBSegueAction func toAssignPlatAdmin(_ coder: NSCoder, sender: Any?) -> AddPlatformAdminTableViewController? {
        return AddPlatformAdminTableViewController(platformID: platform.id, coder: coder)
    }
    

    
    @IBSegueAction func toAssignCodeLang(_ coder: NSCoder, sender: Any?) -> AssignCodeLangTableViewController? {
        
        let assignCodeLangTableViewController =  AssignCodeLangTableViewController(acceptedCodeLangs: platform.codeLangs,platformID: platform.id, coder: coder)
        
    
        
        return assignCodeLangTableViewController
        
        
    }
    

}
