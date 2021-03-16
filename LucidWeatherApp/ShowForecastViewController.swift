//
//  ShowForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 15/03/2021.
//

import UIKit



class ShowForecastViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    var date = ""
    var cityName = ""
    var temp = 0.0
    var pressure = 0
    var humidity = 0
    var speed = 0.0
    var descript = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDate.text = "Date saved: \(date)"
        lblCityName.text = "City: \(cityName)"
        lblTemp.text = "Temperature: \(temp)°C"
        lblPressure.text = "Pressure: \(pressure)"
        lblHumidity.text = "Humidity: \(humidity)"
        lblWindSpeed.text = "Wind speed: \(speed)"
        lblDescription.text = "Weather today: \(descript)"
        
    }

}

