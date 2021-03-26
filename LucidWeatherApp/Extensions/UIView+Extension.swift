//
//  UIView+Extension.swift
//  Pos
//
//  Created by Marijan Lovric on 7/26/19.
//  Copyright © 2019 Dickeys. All rights reserved.
//

import UIKit

extension UIView {
  
  func showActivityIndicator(_ isShown: Bool) {
    if isShown {
      let activityIndicator = UIActivityIndicatorView()
      if #available(iOS 13.0, *) {
        activityIndicator.style = .large
      }
      activityIndicator.color = .black
      activityIndicator.hidesWhenStopped = true
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
      activityIndicator.tag = 88
      
      addSubview(activityIndicator)
      
      // Center in the middle of the superview
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
      let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
      addConstraints([horizontalConstraint, verticalConstraint])
    } else {
      if let activityIndicator = subviews.first(where: { $0.tag == 88 }) as? UIActivityIndicatorView {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      }
    }
  }
  
}
