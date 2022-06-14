//
//  HomeChefTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import UIKit

class HomeChefTableViewCell: UITableViewCell {

    @IBOutlet weak var chefDesc: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    
    func setup() {
        chefImage.addBorder(.black)
    }
}
