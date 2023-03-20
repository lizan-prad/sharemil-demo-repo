//
//  DateListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 23/12/2022.
//

import UIKit

class DateListTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var index: Int?
    var date: Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            formatter.dateFormat = "HH:mm"
            let new = date?.addingTimeInterval(1800) ?? Date()
            self.dateLabel.text = "\(formatter.string(from: date ?? Date())) - \(formatter.string(from: new))"
        }
    }

}
