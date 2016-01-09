//
//  VoucherViewController.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/21/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

class VoucherViewController: UIViewController {

    @IBOutlet weak var detail: UILabel!
    lazy var voucherViewModel: VoucherViewModel = {
        print("VC - Lazy initializing viewmodel...")
        let lazyModelView = VoucherViewModel(location: "Current location")
        return lazyModelView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC - View did load...")
        voucherViewModel.bind() { [unowned self] value in
            print("VC - \(value)")
            self.voucherViewModel.getVoucherList()
            print("VC - Update ui...")
            self.detail.text = "Updating ui \(rand())"
        }

        voucherViewModel.getVoucherList()
        print("VC - Rendering voucher list...")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func forceLocationChange(sender: AnyObject) {
        voucherViewModel.fetchVouchersByLocation("VC - Simulating update backend")
    }

}
