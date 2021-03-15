//
//  ShowWeatherViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 13/03/2021.
//

import UIKit


class ShowWeatherViewController: UIViewController {
    
//  3. Stvoriti gumb "Spremi", i na pritisak gumba spremiti podatke u Model, iz kojeg se onda sprema u DataCore
    
    var cities : Cities?
    var city : String = ""
    var tempUnit: String = ""
//
    var weatherDetail : WeatherDetail!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
                
                //create object
                let newCityData = CityWeather(context: self.context)
                newCityData.cityName = weatherDetail.name
                newCityData.temp = weatherDetail.temp
                newCityData.pressure = Int64(weatherDetail.pressure)
                newCityData.humidity = Int64(weatherDetail.humidity)
                newCityData.windSpeed = weatherDetail.speed
                newCityData.weatherDescription = weatherDetail.descript
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
// Save data button

        @IBAction func btnSaveData(_ sender: Any) {
        //save
        do{
            try self.context.save()}
        catch{
            print("Error with saving data")
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
