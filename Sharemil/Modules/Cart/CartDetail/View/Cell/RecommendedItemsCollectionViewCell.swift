//
//  RecommendedItemsCollectionViewCell.swift
//  Sharemil
//
//  Created by Lizan on 19/09/2023.
//

import UIKit
import SDWebImage

class RecommendedItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    var model: ChefMenuListModel? {
        didSet {
            foodImage.sd_setImage(with: URL.init(string: model?.imageUri ?? ""))
            foodName.text = model?.name
        }
    }
}
