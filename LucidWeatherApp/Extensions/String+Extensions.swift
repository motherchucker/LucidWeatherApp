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
  
  func replace(string:String, replacement:String) -> String {
      return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }

  func removeWhitespace() -> String {
      return self.replace(string: " ", replacement: "")
  }
}
