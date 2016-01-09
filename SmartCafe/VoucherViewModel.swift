//
//  VoucherViewModel.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/21/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import Foundation

class VoucherViewModel {
    typealias Listener = String -> Void
    var listener: Listener?
    private var vouchers: ArraySlice<Voucher>?
    func fetchVouchersByLocation(location: String) {
        print("VM - Fetching vouchers in network...")
        listener?("listener inside VoucherModelView")
    }
    init(location: String) {
        fetchVouchersByLocation(location)
    }
    func bind(listener: Listener) {
        self.listener = listener
    }
    func getNextVoucher() -> Voucher? {
        guard let voucher = vouchers?.first else {
            return nil
        }
        vouchers = vouchers?.dropFirst()
        return voucher
    }
    func getVoucherList() -> ArraySlice<Voucher>? {
        print("VM - process data from network and return proper objects to be rendered...")
        return vouchers
    }
}
