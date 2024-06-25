//
//  SimpleLabelCollectionViewCell.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 06/03/24.
//

import UIKit

class SimpleLabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    
}

class SimpleLabelPlatformCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var platformTitleLabel: UILabel!
    @IBOutlet var platformSubtitleLabel: UILabel!
    
}

class SimpleLabelMlModelCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var mlModelTitleLabel: UILabel!
    
    @IBOutlet var mlModelSubtitleLabel: UILabel!
    
}
