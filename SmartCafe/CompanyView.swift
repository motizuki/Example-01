//
//  CompanyView.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 1/6/16.
//  Copyright © 2016 Gustavo Motizuki. All rights reserved.
//

import UIKit
import MapKit
import DFImageManager


class CompanyView: UIView {

    @IBOutlet weak var companyMapView: MKMapView!
    @IBOutlet weak var companyScrollView: UIScrollView!

    var pageCompanies: [Company] = []
    var pageViews: [DFImageView?] = []
    var delegate: CompanyViewDelegate?
    var currentCompany: Company?

    override func drawRect(rect: CGRect) {
        companyScrollView.delegate = self
        companyMapView.delegate = self
        clearCompanies()
        print(pageCompanies.count)
        pageCompanies.forEach { (company) -> () in
            companyMapView.addAnnotation(company.annotation!)
        }
        showCompanies()
    }

    func presentCompanyView(viewController: UIViewController) {
        frame = CGRect(
            x: 0,
            y: 0,
            width: viewController.view.bounds.maxX,
            height: viewController.view.bounds.maxY - 90
        )
        layer.position = CGPoint(
            x: viewController.view.bounds.midX,
            y: viewController.view.bounds.midY + 45
        )

        viewController.view.addSubview(self)
    }

    func clearCompanies() {
        companyMapView.removeAnnotations(companyMapView.annotations)
        companyScrollView.subviews.forEach { (view) -> () in
            view.removeFromSuperview()
        }
    }

    func showCompanies() {
        for _ in 0..<pageCompanies.count {
            pageViews.append(nil)
        }
        let pagesScrollViewSize = companyScrollView.bounds.size
        companyScrollView.contentSize = CGSize(
            width: pagesScrollViewSize.width * CGFloat(pageCompanies.count),
            height: pagesScrollViewSize.height * 0.5)
        loadVisiblePages()
    }

}


extension CompanyView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadVisiblePages()
    }

    private func loadPage(page: Int) {
        if page < 0 || page >= pageCompanies.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        if let _ = pageViews[page] {
            //Do nothing since the current view is already loaded
        } else {
            var frame = companyScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            let newPageView = DFImageView()
            newPageView.allowsAnimations = true
            newPageView.managesRequestPriorities = true
            newPageView.prepareForReuse()
            newPageView.setImageWithResource(pageCompanies[page].logo)
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
            newPageView.userInteractionEnabled = true
            newPageView.addGestureRecognizer(tapGesture)
            companyScrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    func handleTap() {
        delegate?.companySelected(currentCompany!)
    }
    private func purgePage(page: Int) {
        if page < 0 || page >= pageCompanies.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    private func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = companyScrollView.frame.size.width
        let pageSize = floor(companyScrollView.contentOffset.x * 2.0 + pageWidth)
        let page = Int( pageSize / (pageWidth * 2.0))
        //Set current page index, annotation and map
        currentCompany = pageCompanies[page]
        setupMap(currentCompany!.location!)
        companyMapView.selectAnnotation(currentCompany!.annotation!, animated: true)
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        // Purge anything after the last page
        for var index = lastPage+1; index < pageCompanies.count; ++index {
            purgePage(index)
        }
    }
}

extension CompanyView: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: (overlay as? MKPolyline)!)
        renderer.lineWidth = 3
        renderer.strokeColor = UIColor.blueColor()
        renderer.alpha = 0.6
        return renderer
    }

    private func setupMap(location: CLLocation) {

        var center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        var region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        center.latitude -= region.span.latitudeDelta * -0.25
        region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        companyMapView.layer.cornerRadius = 20
        companyMapView.clipsToBounds = true
        companyMapView.setRegion(region, animated: true)
    }

    func mapView(
        mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation
        ) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        let imageView = UIImageView(image: UIImage(named: "pin2")!)
        imageView.frame = CGRect(x: 0, y: 0, width: 33, height: 50)
        annotationView.frame = imageView.frame
        annotationView.canShowCallout = true
        annotationView.addSubview(imageView)
        annotationView.sizeToFit()
        return annotationView
    }
}

protocol CompanyViewDelegate {
    func companySelected(company: Company)
}
