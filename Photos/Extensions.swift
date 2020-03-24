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

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}
