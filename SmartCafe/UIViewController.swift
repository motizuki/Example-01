//
//  UIViewExtension.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/27/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavBar() {
        //Add circular view to add the logo on top of nav bar
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        let viewBorder = UIView(frame: CGRect(x: 0, y: 13, width: 80, height: 80))
        let image = UIImage(named: "logo2")
        imageView.contentMode = .ScaleAspectFit
        imageView.center = CGPoint(x: 40, y: 40)
        viewBorder.addSubview(imageView)
        viewBorder.backgroundColor = Palette.color5a
        viewBorder.layer.cornerRadius = 40
        imageView.image = image
        iconView.addSubview(viewBorder)
        navigationItem.titleView = iconView
        cropNavViewWithCircle()
    }
    private func cropNavViewWithCircle() {
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
        let croppedView = UIView(frame: navView.bounds)
        let maskCicleLayer = CAShapeLayer()
        let radius: CGFloat = 39.9
        let path = UIBezierPath(rect: navView.bounds)
        let position = CGPoint(x: navView.center.x, y: (navView.center.y+20))
        path.addArcWithCenter(
            position,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: true
        )
        maskCicleLayer.path = path.CGPath
        maskCicleLayer.fillRule = kCAFillRuleEvenOdd
        croppedView.layer.mask = maskCicleLayer
        croppedView.clipsToBounds = true
        croppedView.backgroundColor = Palette.color5a
        navView.backgroundColor = UIColor.clearColor()
        navView.addSubview(croppedView)
        view.addSubview(navView)
    }
}
