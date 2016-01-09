//
//  VoucherView.swift
//  SmartCafe
//
//  Created by Gustavo  Motizuki on 1/3/16.
//  Copyright © 2016 Gustavo Motizuki. All rights reserved.
//

import UIKit

class VoucherView: UIView {

    @IBOutlet weak var detailScrollView: UIScrollView!

    var pageVouchers: [Voucher?] = [Voucher(), Voucher(), Voucher(), Voucher()]
    var pageViews: [VoucherDetailView?] = []
    func presentVoucherView(voucher: Voucher, viewController: UIViewController) {
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

    override func drawRect(rect: CGRect) {
        showVouchers()
    }

    func showVouchers() {
        for _ in 0..<pageVouchers.count {
            pageViews.append(nil)
        }

        let pagesScrollViewSize = detailScrollView.bounds.size

        detailScrollView.contentSize = CGSize(
            width: pagesScrollViewSize.width * CGFloat(pageVouchers.count),
            height: pagesScrollViewSize.height * 0.5)
        detailScrollView.delegate = self
        loadVisiblePages()
    }

    private func loadPage(page: Int) {
        if page < 0 || page >= pageVouchers.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        if let _ = pageViews[page] {

            //Do nothing since the current view is already loaded
        } else {
            var frameDetail = detailScrollView.frame
            frameDetail.origin.x = frameDetail.size.width * CGFloat(page)
            frameDetail.origin.y = 0.0

            let newPageView = UINib(
                nibName: "VoucherDetailView",
                bundle: NSBundle.mainBundle()
                ).instantiateWithOwner(nil, options: nil)[0] as? VoucherDetailView
            newPageView!.frame = frameDetail
            newPageView!.layer.cornerRadius = 25
            newPageView!.layer.masksToBounds = true
            detailScrollView.addSubview(newPageView!)
            pageViews[page] = newPageView
        }
    }

    private func purgePage(page: Int) {
        if page < 0 || page >= pageVouchers.count {
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

        let pageWidth = detailScrollView.frame.size.width
        let totalPageSize = floor(detailScrollView.contentOffset.x * 2.0 + pageWidth)
        let page = Int(totalPageSize / (pageWidth * 2.0))

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
        for var index = lastPage+1; index < pageVouchers.count; ++index {
            purgePage(index)
        }
    }

}

extension VoucherView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadVisiblePages()
    }
}
