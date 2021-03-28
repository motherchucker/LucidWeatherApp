//
//  WeatherAPI.swift
//  LucidWeatherApp
//
//  Created by Marijan Lovric on 26.03.2021..
//

import Foundation

enum Constants {
  static let cellIdentifier = "cell"
  static let kMetricSystem = "kMetricSystem"
  static let segueShowCity = "showCity"
}

enum MetricSystem: String {
  case metric = "metric"
  case imperial = "imperial"
}

enum GetWeatherResult {
  case success(WeatherInfo)
  case failure(Error)
}

enum WeatherError: Error {
  case urlError(String)
}
extension WeatherError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .urlError(let message):
      return NSLocalizedString(message, comment: "URL error")
    }
  }
}

class WeatherAPI {
  static var shared = WeatherAPI()
  
  init() {
    
  }
    
  private let weatherService = WeatherService()
  
  
  // MARK: - Public methods
  
  func getWeatherDataForCity(_ city: City, tempUnit: MetricSystem, completion: @escaping (GetWeatherResult) -> ()) {
    weatherService.getWeatherDataForCity(city, tempUnit: tempUnit, completion: completion)
  }
}
