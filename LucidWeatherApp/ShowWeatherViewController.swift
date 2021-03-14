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
    
    var city : String = ""
        
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        city = String((cities?.cityName)!)
        self.navigationItem.title = city.capitalFirstLetter()
        lblTemp.text = "\(String((cities?.cityName)!))"

        getWeatherData(city: city, showTemp: lblTemp, showPressure: lblPressure, showHumidity: lblHumidity, showWind: lblWindSpeed, tempUnit: "metric")
    }
    
    @IBAction func weatherChangeSegment(_ sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            getWeatherData(city: city, showTemp: lblTemp, showPressure: lblPressure, showHumidity: lblHumidity, showWind: lblWindSpeed, tempUnit: "metric")
        }
        else {
            getWeatherData(city: city, showTemp: lblTemp, showPressure: lblPressure, showHumidity: lblHumidity, showWind: lblWindSpeed, tempUnit: "imperial")
        }
    }

}


func getWeatherData(city: String, showTemp: UILabel, showPressure: UILabel, showHumidity : UILabel, showWind: UILabel, tempUnit: String){
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=00653d2fcf04771524e3d724d11805c3&units=\(tempUnit)")
    
    guard url != nil else{
        print("Error creating url object")
        return
    }
    
    let session = URLSession.shared
    
    let dataTask = session.dataTask(with: url!){ (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error{
            print("Error: \n\(error)")
        }else {
            if let data = data {
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("Weather Data: \(dataString!)")
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as?
                    NSDictionary{
                    
                    //temp, humidity, pressure
                    if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary{
                        if let pressure = mainDictionary.value(forKey: "pressure"){
                            DispatchQueue.main.async {
                                showPressure.text = "Pressure: \(pressure)"
                            }
                        }
                        if let temperature = mainDictionary.value(forKey: "temp") {
                            DispatchQueue.main.async {
                                
                                showTemp.text = "Temperature: \(temperature)" // °C or °F
                            }
                        }
                        if let humidity = mainDictionary.value(forKey: "humidity"){
                            DispatchQueue.main.async {
                                showHumidity.text = "Humidity: \(humidity)"
                            }
                        }
                    } else {
                        print("Error: unable to find temperature, pressure and humidity in dictionary")
                    }
                    // wind
                    if let windDictionary = jsonObj.value(forKey: "wind") as? NSDictionary{
                        if let speed = windDictionary.value(forKey: "speed"){
                            DispatchQueue.main.async {
                                showWind.text = "Wind speed: \(speed)"
                            }
                        }
                    }
                } else {
                    print("Error: unable to convert json data")
                }
            } else {
                print("Error: did not recieve data")
            }
        }
    }
    dataTask.resume()
}



extension String{
    func capitalFirstLetter() -> String{
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter(){
        self = self.capitalFirstLetter()
    }
}
