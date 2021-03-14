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
    
    @IBOutlet weak var lblWeatherCity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        city = String((cities?.cityName)!)
        self.navigationItem.title = city.capitalFirstLetter()
        lblWeatherCity.text = "\(String((cities?.cityName)!))"
        getWeatherData(city: city, lblWeatherCity: lblWeatherCity)
    }
}


func getWeatherData(city: String, lblWeatherCity: UILabel){
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=00653d2fcf04771524e3d724d11805c3")
    
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
                    if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary{
                        if let temperature = mainDictionary.value(forKey: "temp") {
                            DispatchQueue.main.async {
                                lblWeatherCity.text = "Temperature: \(temperature) F"
                            }
                        }
                    } else {
                        print("Error: unable to find temperature in dictionary")
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
