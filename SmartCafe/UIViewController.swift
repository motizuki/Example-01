//
//  UIViewExtension.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/27/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavBar(image: UIImage) {
        //Add circular view to add the logo on top of nav bar
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.center = CGPoint(x: 40, y: 40)
        imageView.image = image
        iconView.addSubview(imageView)
        navigationItem.titleView = iconView
    }
}
