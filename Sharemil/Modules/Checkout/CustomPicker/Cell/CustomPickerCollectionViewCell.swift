//
//  CustomPickerCollectionViewCell.swift
//  Sharemil
//
//  Created by Lizan on 21/12/2022.
//

import UIKit

class CustomPickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    let relativeDateFormatter = DateFormatter()
    
    var date: Date?
    var index: Int?
    
    func setup() {
        self.contentView.addCornerRadius(10)
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        self.dateLabel.text = dateFormatter.string(from: date ?? Date())
        dateFormatter.dateFormat = "eee"
        if relativeDateFormatter.string(from: date ?? Date()) == "Today" || relativeDateFormatter.string(from: date ?? Date()) == "Tomorrow" {
            self.dayLabel.text = relativeDateFormatter.string(from: date ?? Date())
        } else {
            self.dayLabel.text = dateFormatter.string(from: date ?? Date())
        }
    }
}
