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
    
    @IBOutlet weak var lblWeatherCity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let city = String((cities?.cityName)!)
        self.navigationItem.title = city.capitalFirstLetter()
        lblWeatherCity.text = "\(String((cities?.cityName)!))"
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
