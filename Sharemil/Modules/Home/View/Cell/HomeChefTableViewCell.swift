//
//  HomeChefTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import UIKit
import SDWebImage

class HomeChefTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var chefDesc: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var closedView: UIView!
    @IBOutlet weak var offerBox: UIView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var offerText: UILabel!
    
    var chef: ChefListModel? {
        didSet {
            self.offerBox.isHidden = chef?.note == nil || chef?.note == ""
            self.offerText.text = chef?.note
            closedView.rounded()
            businessName.text = chef?.businessName
            
            chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            chefImage.sd_setImage(with: URL.init(string: chef?.mainImageUrl ?? ""))
            
            let formatter = DateFormatter()
            formatter.dateFormat = "eee"
            let now = formatter.string(from: Date()).lowercased()
            let hour = chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
            formatter.dateFormat = "HH:mm:ss"
            let nowStrDate = formatter.string(from: Date())
            let nowDate = formatter.date(from: nowStrDate)
            let date = formatter.date(from: hour?.endTime ?? "")
            let sdate = formatter.date(from: hour?.startTime ?? "")
            formatter.dateFormat = "hh:mm a"
            
            self.chefImage.alpha = (chef?.isOpen == true && ((sdate ?? Date())...(date ?? Date())).contains(nowDate ?? Date())) ? 1 : 0.5
            closedView.isHidden = (chef?.isOpen == true && ((sdate ?? Date())...(date ?? Date())).contains(nowDate ?? Date()))
            
            if ((sdate ?? Date())...(date ?? Date())).contains(nowDate ?? Date()) {
                chefDesc.text = "Open until \(formatter.string(from: date ?? Date())) · \(chef?.distance?.withDecimal(2) ?? "") mi"
            } else if date == nil {
                chefDesc.text = "\(chef?.distance?.withDecimal(2) ?? "") mi"
            } else {
                chefDesc.text = "Opens at \(formatter.string(from: sdate ?? Date())) · \(chef?.distance?.withDecimal(2) ?? "") mi"
            }
//            chefDesc.text = "\( date == nil ? "Opens at \(formatter.string(from: sdate ?? Date()))" : "Open until \(formatter.string(from: date ?? Date()))") · \(chef?.distance?.withDecimal(2) ?? "") mi"
        }
    }
    
    func setup() {
        offerBox.addCornerRadius(4)
        chefImage.addBorder(.black)
    }
}
