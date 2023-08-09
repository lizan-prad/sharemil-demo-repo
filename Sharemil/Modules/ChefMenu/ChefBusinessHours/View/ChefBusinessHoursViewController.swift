//
//  ChefBusinessHoursViewController.swift
//  Sharemil
//
//  Created by Lizan on 13/12/2022.
//

import UIKit
import GoogleMaps

class ChefBusinessHoursViewController: UIViewController, Storyboarded {
    @IBOutlet weak var sunStack: UIStackView!
    @IBOutlet weak var satStack: UIStackView!
    @IBOutlet weak var friStack: UIStackView!
    @IBOutlet weak var thuStack: UIStackView!
    @IBOutlet weak var wedStack: UIStackView!
    @IBOutlet weak var tueStack: UIStackView!
    @IBOutlet weak var monStack: UIStackView!
    
    @IBOutlet weak var collapseTriggerView: UIView!
    @IBOutlet weak var openUntilLabel: UILabel!
    @IBOutlet weak var collapseBtn: UIButton!
    @IBOutlet weak var hourCollapsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var chefLocation: UILabel!
    @IBOutlet weak var chefName: UILabel!
    
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var sunday: UILabel!
    
    
    
    var viewModel: ChefBusinessHoursViewModel!
    var chef: ChefListModel?
    
    var polylines: [GMSPath]? {
        didSet {
            setup()
            polylines?.forEach({ path in
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                polyline.strokeWidth = 2.0
                polyline.map = self.mapView
            })
        }
    }
    
    var collapse = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monStack.isHidden = true
        self.tueStack.isHidden = true
        self.wedStack.isHidden = true
        self.thuStack.isHidden = true
        self.friStack.isHidden = true
        self.satStack.isHidden = true
        self.sunStack.isHidden = true
       
        self.setupDates()
        bindViewModel()
//        self.hourCollapsView.isHidden = collapse
        viewModel.getRoute(loc?.location?.coordinate ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0), destination: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0), longitude: Double(chef?.longitude ?? 0)))
        collapseTriggerView.isUserInteractionEnabled = true
        collapseTriggerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(collapseAction)))
      
    }
    
    @objc func collapseAction() {
        self.collapse = !self.collapse
        self.hourCollapsView.isHidden = collapse
    }
    
    @IBAction func openCollapseAction(_ sender: Any) {
        self.collapse = !self.collapse
        self.hourCollapsView.isHidden = collapse
    }
    
    private func setupDates() {
        
        chef?.hours?.filter({$0.isOpen == true}).forEach({ h in
            print(h.startTime ?? "")
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let start = formatter.date(from: "2022-11-10 " + (h.startTime ?? ""))
            let end = formatter.date(from: "2022-11-10 " + (h.endTime ?? ""))
            formatter.dateFormat = "hh:mm a"
            let startStr = formatter.string(from: start ?? Date())
            let endStr = formatter.string(from: end ?? Date())
            switch h.day ?? "" {
            case "MON":
                self.monStack.isHidden = false
                self.monday.text = "\(startStr) - \(endStr)"
            case "TUE":
                self.tueStack.isHidden = false
                self.tuesday.text = "\(startStr) - \(endStr)"
            case "WED":
                self.wedStack.isHidden = false
                self.wednesday.text = "\(startStr) - \(endStr)"
            case "THU":
                self.thuStack.isHidden = false
                self.thursday.text = "\(startStr) - \(endStr)"
            case "FRI":
                self.friStack.isHidden = false
                self.friday.text = "\(startStr) - \(endStr)"
            case "SAT":
                self.satStack.isHidden = false
                self.saturday.text = "\(startStr) - \(endStr)"
            case "SUN":
                self.sunStack.isHidden = false
                self.sunday.text = "\(startStr) - \(endStr)"
            default: break
            }
        })
    }
    
    private func bindViewModel() {
        viewModel.polylines.bind { polylines in
            self.polylines = polylines
        }
        
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func setup() {
        businessName.text = chef?.businessName
        chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
        chefLocation.text = "\(chef?.address ?? ""), \(chef?.city ?? "") \(chef?.postalCode ?? ""), \(chef?.state ?? "")"
        let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0), longitude: Double(chef?.longitude ?? 0)))
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.isFlat = true
        marker.icon = UIImage.init(named: "open_restaurant")?.withTintColor(.green, renderingMode: .alwaysTemplate)
//            marker.rotation = angle
        marker.map = self.mapView
       
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let h: [HoursModel] = chef?.hours ?? []
        let hour = h.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let nowStrDate = formatter.string(from: Date())
        let nowDate = formatter.date(from: nowStrDate)
        let date = formatter.date(from: hour?.endTime ?? "")
        let sdate = formatter.date(from: hour?.startTime ?? "")
        formatter.dateFormat = "hh:mm a"
        
        if ((sdate ?? Date())...(date ?? Date())).contains(nowDate ?? Date()) {
            openUntilLabel.text = "Open until \(formatter.string(from: date ?? Date()))"
        } else if date == nil {
            openUntilLabel.text = "Closed"
        } else {
            openUntilLabel.text = "Opens at \(formatter.string(from: sdate ?? Date()))"
        }
        
        let cor = polylines?.first?.coordinate(at: (polylines?.first?.count() ?? 0)/2)
        
        let coordinate0 = CLLocation(latitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0)
        let coordinate1 = CLLocation(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0)
        let distanceInMeters = coordinate0.distance(from: coordinate1)*0.001
        let camera = GMSCameraPosition.camera(withLatitude: cor?.latitude ?? 0, longitude: cor?.longitude ?? 0, zoom: Float(14.5 - Double(distanceInMeters )/2))
        mapView.camera = camera
        let locationMarker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0))
        locationMarker.groundAnchor = CGPoint(x: 0.5, y: 1)
        locationMarker.isFlat = true
        locationMarker.icon = UIImage.init(named: "start")
//            marker.rotation = angle
        locationMarker.map = self.mapView
    }
    
}
