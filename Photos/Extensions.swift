//
//  Extensions.swift
//  Photos
//
//  Created by Krithika Iyer 2 on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation
import UIKit

protocol CustomLoadingIndicator: class {
    var loadingIndicator: UIActivityIndicatorView? { get set }
}

extension CustomLoadingIndicator where Self: UIViewController {
    
    func showLoadingIndicator(at point: CGPoint? = nil) {
        OperationQueue.main.addOperation({
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            self.view.addSubview(loadingIndicator)
            loadingIndicator.center = point ?? self.view.center
            loadingIndicator.startAnimating()
            self.loadingIndicator = loadingIndicator
        })
    }
    
    func hideLoadingIndicator() {
        OperationQueue.main.addOperation({
            guard let _ = self.loadingIndicator else {
                return
            }
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
        })
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
      return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollToTop(animated: Bool) {
      let indexPath = IndexPath(row: 0, section: 0)
      if self.hasRowAtIndexPath(indexPath: indexPath) {
        self.scrollToRow(at: indexPath, at: .top, animated: animated)
      }
    }
}


