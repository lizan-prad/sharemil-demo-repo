//
//  CustomPickerViewController.swift
//  Sharemil
//
//  Created by Lizan on 21/12/2022.
//

import UIKit

class CustomPickerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    
    var hours: [HoursModel]?
    
    var filteredHour: HoursModel? {
        didSet {
            if filteredHour?.isOpen == true {
                    self.getHours()
            } else {
                self.dateList = []
            }
        }
    }
    var selectedIndex = 0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var dateList: [Date]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var selectedDate: (String, String)?
    
    var selectedIndexTable: Int = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var collectionDates: [Date] = []
    
    var didSelectDate: ((String,String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupTable()
        self.setupCollection()
    }
    
    private func setup() {
        self.container.setStandardShadow()
        [1,2,3,4].forEach { num in
            self.collectionDates.append(Date().addingTimeInterval((num - 1)*86400))
        }
        self.collectionView.reloadData()
        self.filteredHour = hours?.filter({ h in
            let formatter = DateFormatter()
            formatter.dateFormat = "eee"
            return h.day?.lowercased() == formatter.string(from: Date()).lowercased()
        }).first
    }
    
    private func getHours() {
        let formatter1 = DateFormatter()
        let calendar = Calendar.current
        var nDate = Date()
        let minutes = calendar.component(.minute, from: nDate)
        let remaining = (minutes%15) == 0 ? 0 : (15 - (minutes%15))
        nDate = nDate.addingTimeInterval(Double(remaining*60))
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let nowStrDate = "\(formatter.string(from: nDate)) GMT"
        formatter.dateFormat = "HH:mm:ss Z"
        let end = formatter.date(from: hour?.endTimeGmt ?? "") ?? Date()
        let sDate = formatter.date(from: hour?.startTimeGmt ?? "") ?? Date()
        let nowDate = (sDate...end).contains((formatter.date(from: nowStrDate) ?? Date())) ? (formatter.date(from: nowStrDate) ?? Date()) : sDate
        if (formatter.date(from: nowStrDate) ?? Date()) > end {
            self.dateList = []
        } else {
            
            let quarter: TimeInterval = 15 * 60
            
            var dateInterval = DateInterval(start: nowDate, end: end)
            var date = nowDate
            var result = [Date]()
            while dateInterval.contains(date) {
                result.append(date)
                date = date.addingTimeInterval(quarter)
            }
            self.dateList = result
        }
    }
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
        self.dismiss(animated: true) {
            self.didSelectDate?(self.selectedDate?.0 ?? "", self.selectedDate?.1 ?? "")
        }
    }
    
}

extension CustomPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList?.count == 0 ? 1 : dateList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dateList?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClosedBusinessTableViewCell") as! ClosedBusinessTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateListTableViewCell") as! DateListTableViewCell
            cell.index = indexPath.row
            cell.selectionImage.isHidden = indexPath.row != self.selectedIndexTable
            cell.date = self.dateList?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dateList?.count == 0 {
            return
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! DateListTableViewCell
            self.selectedIndexTable = cell.index ?? 0
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM"
            let m = formatter.string(from: collectionDates[selectedIndex])
            formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd"
            let str = formatter.string(from: collectionDates[selectedIndex])
            formatter.dateFormat = "HH:mm:ss"
            let str2 = formatter.string(from: cell.date ?? Date())
            
            self.selectedDate = ("\(m) (\(cell.dateLabel.text ?? ""))", "\(str) \(str2) GMT")
        }
    }
}

extension CustomPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomPickerCollectionViewCell", for: indexPath) as! CustomPickerCollectionViewCell
        cell.date = self.collectionDates[indexPath.row]
        cell.index = indexPath.row
        cell.setup()
        cell.contentView.addBorderwith(selectedIndex == indexPath.row ? .black : .lightGray.withAlphaComponent(0.5), width: selectedIndex == indexPath.row ? 2 : 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 160, height: 88)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomPickerCollectionViewCell
        self.filteredHour = hours?.filter({ h in
            let formatter = DateFormatter()
            formatter.dateFormat = "eee"
            return h.day?.lowercased() == formatter.string(from: cell.date ?? Date()).lowercased()
        }).first
        self.selectedIndex = cell.index ?? 0
    }
}
