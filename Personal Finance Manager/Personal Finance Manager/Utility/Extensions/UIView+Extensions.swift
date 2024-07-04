//
//  UIView+Extensions.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 27/6/24.
//

import Foundation
import UIKit

public extension UIView{
    /**
     Sets anchor of current view with the provided anchors with padding
     - Parameters:
        - top: Receives  `NSLayoutYAxisAnchor?` as the anchor. Default value is `nil`
        - leading: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - bottom: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - trailing: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - paddingTop: Receives  `CGFloat` as constant. Default value is 0
        - paddingLeading: Receives  `CGFloat` as constant. Default value is 0
        - paddingBottom: Receives  `CGFloat` as constant. Default value is 0
        - paddingTrailing: Receives  `CGFloat` as constant. Default value is 0
        - width: Receives  `CGFloat?` as constant. Default value is `nil`
        - height: Receives  `CGFloat?` as constant. Default value is `nil`
        - multiplier: Receives  `CGFloat?` as value. Default value is `nil`
     */
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeading: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingTrailing: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                multiplier:CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let multiplier = multiplier{
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier, constant: 0).isActive = true
        }
        
    }
    
    /**
     Sets centerX of current view with centerX of the provied view with a constant
     - Parameters:
        - view: Receives  `UIView` as the parent view
        - constant: Receives  `CGFloat` as constant. Default value is 0
     */
    func centerX(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    /**
     Sets centerY of current view with centerY of the provied view with a constant
     - Parameters:
        - view: Receives  `UIView` as the parent view
        - constant: Receives  `CGFloat` as constant. Default value is 0
     */
    
    func centerY(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    /**
     Sets width, height  of a view
     - Parameters:
        - height: Receives  `CGFloat` as height
        - width: Receives  `CGFloat` as width
     */
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /**
     Sets maximum width, minimum width, maximum height, minimum height of a view
     - Parameters:
        - minWidth: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - maxWidth: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - minHeight: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - maxHeight: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
     */
    func setDimensions(minWidth: CGFloat?, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let minWidth = minWidth {
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }
        fillSuperview()
        if let minHeight = minHeight {
            heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        }
        
        
        if let maxWidth = maxWidth {
            widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        }
        
        if let maxHeight = maxHeight {
            heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
    }
    /**
    Sets Top, Bottom, Leading, Trailing anchor with specifit edge insets
    - Parameters:
       - padding: Receives `UIEdgeInsets`, Default value is .zero
     */
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}





//MARK: Border
extension UIView {
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
