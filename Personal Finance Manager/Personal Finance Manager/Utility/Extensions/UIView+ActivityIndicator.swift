//
//  UIView+ActivityIndicator.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 4/7/24.
//

import Foundation
import UIKit

extension UIView{

    func activityStartAnimating(activityColor: UIColor = .white, backgroundColor: UIColor = .black.withAlphaComponent(0.5)) {
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        backgroundView.addSubview(activityIndicator)
        DispatchQueue.main.async {
            self.addSubview(backgroundView)
        }
        
    }

    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
