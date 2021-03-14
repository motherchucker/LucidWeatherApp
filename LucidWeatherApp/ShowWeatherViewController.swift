//
//  ShowWeatherViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 13/03/2021.
//

import UIKit


class ShowWeatherViewController: UIViewController {
    
//  MORAM:
//  - dohvatiti odabranu vrijednost, odnosno grad i sukladno s time povuci podatke iz modela za vrijeme za taj grad
//  1. URLSession otvoriti za api stranicu u kojoj prosljedujemo vrijednost grada
//  2. Nakon ostvarene veze dohvatiti i prikazati trazene podatke za taj grad
//  3. Stvoriti gumb "Spremi", i na pritisak gumba spremiti podatke u Model, iz kojeg se onda sprema u DataCore
    
    var cities : Cities?
    
//    class WeatherData{
//        var city : String
//        var tempUnit: String
//
//        init(city: String, tempUnit: String) {
//            self.city = city
//            self.tempUnit = tempUnit
//        }
//
//    }
    var city : String = ""
    var tempUnit: String = ""
//
    var weatherDetail : WeatherDetail!
    
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        city = String((cities?.cityName)!)
        self.navigationItem.title = city.capitalFirstLetter()
        tempUnit = "metric"
        let weatherDetail = WeatherDetail()

        weatherDetail.getWeatherData(city: city, tempUnit: tempUnit) {
            DispatchQueue.main.async {
                self.lblCityName.text = "City: \(weatherDetail.name)"
                self.lblTemp.text = "Temperature: \(weatherDetail.temp)"
                self.lblPressure.text = "Pressure: \(weatherDetail.pressure)"
                self.lblHumidity.text = "Humidity: \(weatherDetail.humidity)"
                self.lblWindSpeed.text = "Wind speed: \(weatherDetail.speed)"
                self.lblDescription.text = "Weather today: \(weatherDetail.descript)"
            }
        }
    }
    
    @IBAction func weatherChangeSegment(_ sender: UISegmentedControl){
        
        let weatherDetail = WeatherDetail()
        
        weatherDetail.getWeatherData(city: city, tempUnit: tempUnit) {
            DispatchQueue.main.async {
                self.lblCityName.text = "City: \(weatherDetail.name)"
                self.lblTemp.text = "Temperature: \(weatherDetail.temp)"
                self.lblPressure.text = "Pressure: \(weatherDetail.pressure)"
                self.lblHumidity.text = "Humidity: \(weatherDetail.humidity)"
                self.lblWindSpeed.text = "Wind speed: \(weatherDetail.speed)"
                self.lblDescription.text = "Weather today: \(weatherDetail.descript)"
            }
        }
        
        if sender.selectedSegmentIndex == 0{
            weatherDetail.getWeatherData(city: city, tempUnit: "metric") {
                DispatchQueue.main.async {
                    self.lblCityName.text = "City: \(weatherDetail.name)"
                    self.lblTemp.text = "Temperature: \(weatherDetail.temp)"
                    self.lblPressure.text = "Pressure: \(weatherDetail.pressure)"
                    self.lblHumidity.text = "Humidity: \(weatherDetail.humidity)"
                    self.lblWindSpeed.text = "Wind speed: \(weatherDetail.speed)"
                    self.lblDescription.text = "Weather today: \(weatherDetail.descript)"
                }
            }
        }
        else {
            weatherDetail.getWeatherData(city: city, tempUnit: "imperial") {
                DispatchQueue.main.async {
                    self.lblCityName.text = "City: \(weatherDetail.name)"
                    self.lblTemp.text = "Temperature: \(weatherDetail.temp)"
                    self.lblPressure.text = "Pressure: \(weatherDetail.pressure)"
                    self.lblHumidity.text = "Humidity: \(weatherDetail.humidity)"
                    self.lblWindSpeed.text = "Wind speed: \(weatherDetail.speed)"
                    self.lblDescription.text = "Weather today: \(weatherDetail.descript)"
                }
            }
        }
    }

}

extension String{
    func capitalFirstLetter() -> String{
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter(){
        self = self.capitalFirstLetter()
    }
}
