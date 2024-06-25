//
//  DatabaseDetailCollectionViewController.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 04/03/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class DatabaseDetailCollectionViewController: UICollectionViewController {

    enum Section: Hashable {
        case description
        case dbAdmin
        case tables
        case models
    }
    
    var databaseKelpel: DatabaseKelpel
    
    init?(databaseKelpel: DatabaseKelpel, coder: NSCoder) {
        self.databaseKelpel = databaseKelpel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var descriptionItems: [DatabaseDetailItem] = []
    var dbAdminItem: DatabaseDetailItem?
    var tableItems: [DatabaseDetailItem] = []
    var mlModelItems: [DatabaseDetailItem] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DatabaseDetailItem>!
    var sections = [Section]()
    
    var snapshot: NSDiffableDataSourceSnapshot<Section, DatabaseDetailItem>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, DatabaseDetailItem>()
        
        snapshot.appendSections([.description])
        snapshot.appendItems(descriptionItems,toSection: .description)
        
        if let dbAdminItem = dbAdminItem {
            snapshot.appendSections([.dbAdmin])
            snapshot.appendItems([dbAdminItem], toSection: .dbAdmin)
        }
        
        if tableItems.count > 0 {
            snapshot.appendSections([.tables])
            snapshot.appendItems(tableItems, toSection: .tables)
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseDetailCell", for: indexPath) as! SimpleLabelCollectionViewCell
                
                let title = item.description![0]
                cell.titleLabel.font = .boldSystemFont(ofSize:17 )

                let subtitle = item.description![1]
                
                cell.titleLabel.text = title
                cell.titleLabel.font = .boldSystemFont(ofSize:17 )

                cell.subtitleLabel.text = subtitle
                
                return cell
                
            case .dbAdmin:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseDetailCell", for: indexPath) as! SimpleLabelCollectionViewCell
                let user = item.dbAdmin!
                
                cell.titleLabel.text = "Administrador:"
                cell.titleLabel.font = .boldSystemFont(ofSize:17 )

                cell.subtitleLabel.text = user.fullName

                return cell
            
            case .tables:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseDetailCell", for: indexPath) as! SimpleLabelCollectionViewCell
                let table = item.table!
                cell.titleLabel.text = nil

                cell.subtitleLabel.text = table.name
                return cell
                
            case .models:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseDetailCell", for: indexPath) as! SimpleLabelCollectionViewCell
                let model = item.model!
                
                cell.titleLabel.text = model.name
                cell.titleLabel.font = .boldSystemFont(ofSize:17 )

                cell.subtitleLabel.text = nil
                return cell
                
            }
            
            
            
        }
        dataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "headerView", for: indexPath) as! NameSectionHeaderView
            
            let section = self.sections[indexPath.section]
            switch section {
            case .description:
                header.nameLabel.text = "Detalles de base de datos"
            case .dbAdmin:
                header.nameLabel.text = "Administrador"
            case .models:
                header.nameLabel.text = "Modelos registrados"
            case .tables:
                header.nameLabel.text = "Tablas registradas"
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
        

        
        self.descriptionItems = [.description(["Nombre:", databaseKelpel.name]),
                                 .description(["Ip:", databaseKelpel.ip]),
                                 .description(["Descripción:", databaseKelpel.description])]
        
        if let dbAdmin = databaseKelpel.dbAdmin {
            self.dbAdminItem = .dbAdmin(dbAdmin)

        } else {
            self.dbAdminItem = nil
        }
        
        self.tableItems = databaseKelpel.tables.map({DatabaseDetailItem.table($0)})
        
        
        dataSource.apply(snapshot)
        
        Task {
            do {
                let databaseModelList = try await GetDatabaseModelsRequest(databaseID: databaseKelpel.id).send()
                self.mlModelItems = databaseModelList.map({DatabaseDetailItem.model($0)})
                await dataSource.apply(snapshot)
                
                
            } catch {
            print(error)
            }
        }
    
        
    }
    
    @IBAction func actionButtonSelected(_ sender: UIBarButtonItem) {
        
        let alertContoller = UIAlertController()
        
        if MLModelNetwork.actualUser?.id == databaseKelpel.dbAdmin?.id || MLModelNetwork.actualUser?.role == "administrator" || MLModelNetwork.actualUser?.id == databaseKelpel.creatorUser.id {
            
            let addTableAction = UIAlertAction(title: "Agregar Tabla", style: .default) {
                _ in
                self.performSegue(withIdentifier: "DbDetailToCreateTable", sender: nil)
            }
            
            alertContoller.addAction(addTableAction)
            
        }
        
        if MLModelNetwork.actualUser?.role == "administrator" || MLModelNetwork.actualUser?.id == databaseKelpel.creatorUser.id {
            if let dbAdmin = databaseKelpel.dbAdmin {
                let removeAdmin = UIAlertAction(title: "Quitar Administrador", style: .default){
                    _ in
                    let alertController2 = UIAlertController(title: "Are you sure to remove \(dbAdmin.fullName) as admin?", message: nil, preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "yes", style: .default){
                        _ in
                        Task {
                            do {
                                try await SendRemoveDBAdminRequest(databaseID: self.databaseKelpel.id, userID: dbAdmin.id).send()
                                let updateDatabase = try await GetSpecificDatabaseRequest(databaseID: self.databaseKelpel.id).send()
                                self.databaseKelpel = updateDatabase
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
                    self.performSegue(withIdentifier: "DbDetailToAssignAdmin", sender: nil)
                }
                alertContoller.addAction(addAdmin)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alertContoller.addAction(cancelAction)
        present(alertContoller,animated: true)
        
        
            
    }
    
    
    
    
    @IBSegueAction func toCreateTableSegue(_ coder: NSCoder, sender: Any?) -> AddTableTableViewController? {
        return AddTableTableViewController(databaseID: databaseKelpel.id, coder: coder)
    }
    
    @IBAction func unwindToDatabaseDetail(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        
        Task {
            do {
                let updateDatabase = try await GetSpecificDatabaseRequest(databaseID: databaseKelpel.id).send()
                self.databaseKelpel = updateDatabase
                updateUI()
            } catch {
                print(error)
            }
        }
    }
    
    
    @IBSegueAction func toAssignAdminSegue(_ coder: NSCoder, sender: Any?) -> UsersListTableViewController? {
        return AddDatabaseAdministratorTableViewController(databaseID: databaseKelpel.id, coder: coder)
    }
    
    

}
