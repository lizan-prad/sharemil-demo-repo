//
//  CustomPickerViewController.swift
//  Sharemil
//
//  Created by Lizan on 21/12/2022.
//

import UIKit

class CustomPickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    
    var hours: [HoursModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupCollection()
    }
    
    private func setup() {
        self.container.addCornerRadius(8)
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let date = formatter.date(from: hour?.endTime ?? "") ?? Date()
        let sdate = formatter.date(from: hour?.startTime ?? "") ?? Date()
        
        let nowDateStr = formatter.string(from: Date())
        let nowDate = formatter.date(from: nowDateStr) ?? Date()
        let calendar = Calendar.current
        let d = calendar.dateComponents([.hour,.minute], from: nowDate, to: date)
        var h = (d.hour ?? 0)*60*60
        var m = (d.minute ?? 0)*60
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(Double(h+m))
        datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
    }
    
    @objc private func didSelectDate(_ sender: UIDatePicker) {
        
    }
    
    private func setupCollection() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "CustomPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomPickerCollectionViewCell")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
}

extension CustomPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomPickerCollectionViewCell", for: indexPath) as! CustomPickerCollectionViewCell
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
