//
//  ForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 12/03/2021.
//

import UIKit

class Cities {
    var cityName : String?
    
    init(cityN: String){
        self.cityName = cityN
    }
}

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var citiesArray = [Cities]()
//    let cities = [
//        "rijeka",
//        "zagreb",
//        "london",
//        "chicago"
//    ]
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add cities
        let rijeka = Cities(cityN: "rijeka")
        citiesArray.append(rijeka)
        let zagreb = Cities(cityN: "zagreb")
        citiesArray.append(zagreb)
        let london = Cities(cityN: "london")
        citiesArray.append(london)
        let chicago = Cities(cityN: "chicago")
        citiesArray.append(chicago)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//  UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "showCity", sender: self)
        
        // What is chosen:
        print("You chose \(indexPath.row) with value \(String(citiesArray[indexPath.row].cityName!))")
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
// Seg
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowWeatherViewController{
            destination.cities = citiesArray[(tableView.indexPathForSelectedRow?.row)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
//  UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = citiesArray[indexPath.row].cityName?.uppercased()
        
        return cell
    }
}

