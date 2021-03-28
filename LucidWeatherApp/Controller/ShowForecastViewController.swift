//
//  ShowForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 15/03/2021.
//

import UIKit



class ShowForecastViewController: UIViewController {

  var weatherInfo: WeatherInfoHistory!
 
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblCityName: UILabel!
  @IBOutlet weak var lblTemp: UILabel!
  @IBOutlet weak var lblPressure: UILabel!
  @IBOutlet weak var lblHumidity: UILabel!
  @IBOutlet weak var lblWindSpeed: UILabel!
  @IBOutlet weak var lblDescription: UILabel!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let weatherInfo = weatherInfo else {
      print("No weather info")
      return
    }
    populateWeatherData(weatherInfo)
  }

  
  // MARK: - Private methods
  
  private func populateWeatherData(_ weatherInfo: WeatherInfoHistory) {
    lblDate.text = "Date saved: \(weatherInfo.dateSaved)"
    lblCityName.text = "City: \(weatherInfo.name)"
    lblTemp.text = "Temperature: \(weatherInfo.temp)"
    lblPressure.text = "Pressure: \(weatherInfo.pressure)"
    lblHumidity.text = "Humidity: \(weatherInfo.humidity)"
    lblWindSpeed.text = "Wind speed: \(weatherInfo.speed)"
    lblDescription.text = "Weather today: \(weatherInfo.descript)"
  }

}

