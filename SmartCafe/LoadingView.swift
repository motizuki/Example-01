//
//  LoadingView.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/26/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!

    func animateLogo() {
        UIView.animateWithDuration(2,
            delay: 0,
            usingSpringWithDamping: 0.25,
            initialSpringVelocity: 0.1,
            options: [.Repeat, .Autoreverse],
            animations: { () -> Void in
                self.logo.transform = CGAffineTransformRotate(self.logo.transform, CGFloat(M_PI))
                self.logo.transform = CGAffineTransformRotate(self.logo.transform, CGFloat(M_PI))
            },
            completion: nil
        )
    }

    func presentLoadingView(message: String, viewController: UIViewController) {
        hidden = false
        frame = CGRect(
            x: 0,
            y: 0,
            width: viewController.view.bounds.maxX,
            height: viewController.view.bounds.maxY - 120
        )
        layer.position = CGPoint(
            x: viewController.view.bounds.midX,
            y: viewController.view.bounds.midY + 30
        )
        label.text = message
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        animateLogo()
        viewController.view.addSubview(self)
    }

}
