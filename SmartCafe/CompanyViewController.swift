//
//  CompanyViewController.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/24/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import DFImageManager

class CompanyViewController: UIViewController {

    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    let locationManager = CLLocationManager()
    let ref = Firebase(url: "https://tetrifier-website.firebaseio.com")
    var binding = false
    var currentLocation: CLLocation?

    lazy var loadingView: LoadingView = {
        let lazyloadingView = UINib(
            nibName: "LoadingView",
            bundle: NSBundle.mainBundle()
            ).instantiateWithOwner(nil, options: nil)[0] as? LoadingView
        return lazyloadingView!
    }()

    lazy var voucherView: VoucherView = {
        let lazyVoucherView = UINib(
            nibName: "VoucherView",
            bundle: NSBundle.mainBundle()
            ).instantiateWithOwner(nil, options: nil)[0] as? VoucherView
        return lazyVoucherView!
    }()

    lazy var companyView: CompanyView = {
        let lazyCompanyView = UINib(
            nibName: "CompanyView",
            bundle: NSBundle.mainBundle()
            ).instantiateWithOwner(nil, options: nil)[0] as? CompanyView
        return lazyCompanyView!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar(UIImage(named: "logo")!)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func refresh() {
        voucherView.removeFromSuperview()
        companyView.removeFromSuperview()
        refreshBarButton.enabled = false
        setupNavBar(UIImage(named: "logo")!)
        let loadingLocStr = NSLocalizedString("loading", comment: "Loading voucher")
        loadingView.presentLoadingView(loadingLocStr, viewController: self)
        locationManager.requestLocation()
    }

    @IBAction func login(sender: AnyObject) {

    }

    func setupCompanyLister(location: CLLocation) {
        binding = true
        var totalCompanies = 0
        var loadedCompanies: Int = 0 {
            didSet {
                if totalCompanies <= loadedCompanies && totalCompanies > 0 {
                    if companyView.pageCompanies.count == 0 {
                        let loadingLocStr = NSLocalizedString("loadingNotFound", comment: "")
                        showLoadingErrorMessage(loadingLocStr)
                    } else {
                       presentCompanyView()
                    }
                }
            }
        }
        ref.removeAllObservers()
        companyView.pageCompanies.removeAll()
        companyView.pageViews.removeAll()
        ref.childByAppendingPath("companies").observeSingleEventOfType(
            .Value,
            withBlock: { snapshot in
                totalCompanies = snapshot.value.count
            }
        )
        ref.childByAppendingPath("companies").observeEventType(.ChildAdded, withBlock: {snapshot in
            let companyID = snapshot.key
            let latitude: CLLocationDegrees = (snapshot.value["lat"] as? Double)!
            let longitude: CLLocationDegrees = (snapshot.value["long"] as? Double)!
            let companyLocation = CLLocation(latitude: latitude, longitude: longitude)
            let distance = location.distanceFromLocation(companyLocation)
            if distance < 300 && distance > 0 {
                let company = Company()
                company.name = snapshot.value["name"] as? String
                company.location = companyLocation
                company.companyId = companyID
                self.ref.childByAppendingPath("logos/\(companyID)")
                    .observeSingleEventOfType(
                        .Value,
                        withBlock: { snapshot in
                            company.logo = NSURL(string: (snapshot.value as? String)!)
                            company.annotation = self.createAnnotation(company)
                            self.companyView.pageCompanies.append(company)
                            loadedCompanies++
                        }
                    )
            } else {
                loadedCompanies++
            }
            self.binding = false
        })
    }
    private func presentCompanyView() {
        loadingView.removeFromSuperview()
        refreshBarButton.enabled = true
        companyView.delegate = self
        companyView.presentCompanyView(self)
        companyView.setNeedsDisplay()
    }
    private func showLoadingErrorMessage(message: String) {
        loadingView.removeFromSuperview()
        loadingView.presentLoadingView(message, viewController: self)
        loadingView.logo.layer.removeAllAnimations()
        refreshBarButton.enabled = true
    }

    private func loadVouchers(companyId: String) {
        voucherView.presentVoucherView(Voucher(), viewController: self)
        loadingView.removeFromSuperview()
        companyView.removeFromSuperview()
    }

    private func createAnnotation(company: Company) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = company.location!.coordinate
        annotation.title = company.name!
        return annotation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CompanyViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        if !binding {
            self.currentLocation = location
            setupCompanyLister(location)
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
        let loadingLocStr = NSLocalizedString("loadingError", comment: "Loading error")
        showLoadingErrorMessage(loadingLocStr)
    }
}

extension CompanyViewController: CompanyViewDelegate {
    func companySelected(company: Company) {
        setupNavBar(UIImage(named: "logo-sample-1")!)
        loadVouchers(company.companyId!)
    }
}
