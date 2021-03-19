//
//  WeatherModel.swift
//  LucidWeatherApp
//
//  Created by mrsic on 14/03/2021.
//

import Foundation

class WeatherDetail: ShowWeatherViewController{
    
    struct Result: Codable {
        var name: String
        var dt: Double
        var weather: [Weather]
        var main: Main
        var wind: Wind
    }
    struct Weather: Codable{
        var description: String
    }
    struct Wind: Codable{
        var speed: Double
    }
    struct Main: Codable{
        var temp : Double
        var pressure: Double
        var humidity : Double
    }
    
    var dateSaved = 0.0
    var name = ""
    var temp = 0.0
    var pressure = 0
    var humidity = 0
    var speed = 0.0
    var descript = ""
    
    
    func getWeatherData(city: String, tempUnit: String, completed: @escaping()->()){
        
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=API_KEY_HERE&units=\(tempUnit)")
        
        guard url != nil else{
            print("Error while creating url object")
            completed()
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            if data != nil{
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data!)
                    self.dateSaved = result.dt
                    self.name = result.name
                    self.temp = result.main.temp
                    self.pressure = Int(result.main.pressure.rounded())
                    self.humidity = Int(result.main.humidity.rounded())
                    self.speed = result.wind.speed
                    self .descript = result.weather[0].description
                    
                } catch {
                    print("Json error")
                }
                completed()
            }
        }
        dataTask.resume()
    }
}
