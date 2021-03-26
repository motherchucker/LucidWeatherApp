//
//  String+Extensions.swift
//  LucidWeatherApp
//
//  Created by Marijan Lovric on 26.03.2021..
//

import Foundation

extension String {
  func capitalFirstLetter() -> String{
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter(){
    self = self.capitalFirstLetter()
  }
}
