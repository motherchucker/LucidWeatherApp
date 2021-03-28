//
//  WeatherModel.swift
//  LucidWeatherApp
//
//  Created by mrsic on 14/03/2021.
//

import Foundation

class WeatherService {
  struct ResultJson: Codable {
    var name: String
    var dt: Double
    var weather: [WeatherJson]
    var main: MainJson
    var wind: WindJson
  }
  
  struct WeatherJson: Codable {
    var description: String
  }
  
  struct WindJson: Codable {
    var speed: Double
  }
  
  struct MainJson: Codable {
    var temp : Double
    var pressure: Double
    var humidity : Double
  }
    
  func getWeatherDataForCity(_ city: City, tempUnit: MetricSystem, completion: @escaping (GetWeatherResult) -> ()) {
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=00653d2fcf04771524e3d724d11805c3&units=\(tempUnit)")
    
    guard url != nil else {
      let error = WeatherError.urlError("Error while creating url object")
      debugPrint(error)
      DispatchQueue.main.async {
        completion(.failure(error))
      }
      return
    }
    
    let session = URLSession.shared
    
    let dataTask = session.dataTask(with: url!) { (data, response, error) in
      if let error = error {
        debugPrint(error)
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      
      if data != nil {
        do {
          let result = try JSONDecoder().decode(ResultJson.self, from: data!)
          var weatherInfo = WeatherInfo()
          weatherInfo.dateSaved = result.dt
          weatherInfo.name = result.name
          weatherInfo.temp = result.main.temp
          weatherInfo.pressure = result.main.pressure.rounded()
          weatherInfo.humidity = result.main.humidity.rounded()
          weatherInfo.speed = result.wind.speed
          weatherInfo.descript = result.weather[0].description
          
          DispatchQueue.main.async {
            completion(.success(weatherInfo))
          }
          return
        } catch {
          debugPrint(error)
          DispatchQueue.main.async {
            completion(.failure(error))
          }
          return
        }
      }
    }
    dataTask.resume()
  }
}
