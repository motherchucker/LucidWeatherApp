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
    
    var city : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = city
    }
}

