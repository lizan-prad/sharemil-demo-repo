//
//  HomeCusinesCollectionViewCell.swift
//  Sharemil
//
//  Created by lizan on 16/06/2022.
//

import UIKit
import SDWebImage

class HomeCusinesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cusineLabel: UILabel!
    @IBOutlet weak var cusinesImage: UIImageView!
    
    var model: CusineListModel? {
        didSet {
            cusineLabel.text = model?.name
            cusinesImage.sd_setImage(with: URL.init(string: model?.imageUrl ?? ""))
        }
    }
}
