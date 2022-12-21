//
//  CustomPickerCollectionViewCell.swift
//  Sharemil
//
//  Created by Lizan on 21/12/2022.
//

import UIKit

class CustomPickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setup() {
        self.contentView.addCornerRadius(23)
    }
}
