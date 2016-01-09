//
//  VoucherDetailView.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 1/3/16.
//  Copyright © 2016 Gustavo Motizuki. All rights reserved.
//

import UIKit

class VoucherDetailView: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dateRange: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBAction func getOffer(sender: UIButton) {
        print("get offer")
    }
}
