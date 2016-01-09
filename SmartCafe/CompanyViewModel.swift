//
//  CompanyViewModel.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 12/27/15.
//  Copyright © 2015 Gustavo Motizuki. All rights reserved.
//

import Foundation

class CompanyViewModel {
    typealias Listener = () -> Void
    var listener: Listener?
    private var companies: ArraySlice<Company>?

    func fetchCompaniesByLocation(location: String) {
        print("VM - Fetching vouchers in network...")
        listener?()
    }

    init(location: String) {
        fetchCompaniesByLocation(location)
    }

    func bind(listener: Listener) {
        self.listener = listener
    }

    func getCompanyList() -> ArraySlice<Company>? {
        print("VM - process data from network and return proper objects to be rendered...")
        return companies
    }
}
