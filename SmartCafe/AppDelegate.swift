//
//  AppDelegate.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/21/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?
        ) -> Bool {

        UINavigationBar.appearance().tintColor = Palette.color6
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().translucent = true
        let font = UIFont(name: "Futura-Medium", size: 18)!
        let uiBarButtonAttrb = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName:Palette.color6
            ]
        UIBarButtonItem.appearance().setTitleTextAttributes(uiBarButtonAttrb,
            forState: UIControlState.Normal)

        let yourImage = UIImage(named: "background.png")
        let imageView = UIImageView(image: yourImage)
        imageView.layer.frame = (window?.frame)!
        imageView.layer.position = CGPoint(x: (window?.frame.midX)!, y: (window?.frame.midY)!)
        window?.addSubview(imageView)
        return true
    }
}
