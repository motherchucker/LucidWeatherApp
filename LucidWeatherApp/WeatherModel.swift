//
//  WeatherModel.swift
//  LucidWeatherApp
//
//  Created by mrsic on 14/03/2021.
//

import Foundation

struct WeatherModel : Decodable{
    let name : String
    let weather : Main
    let wind : Wind
    let description : [WeatherDescription]
    
}

struct Main : Decodable {
    let temp: Double
    let pressure : Int
    let humidity: Int
}

struct Wind : Decodable {
    let speed : Double
}

struct WeatherDescription : Decodable {
    let main : String
    let description : String
}
