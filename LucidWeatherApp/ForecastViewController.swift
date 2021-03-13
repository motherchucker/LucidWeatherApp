//
//  ForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 12/03/2021.
//

import UIKit


class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    

    let cities = [
        "rijeka",
        "zagreb",
        "london",
        "chicago"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
//  UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You chose \(indexPath.row)")
        // Prenesi u ShowWeatherViewController
        let showWeather = storyboard?.instantiateViewController(withIdentifier: "ShowWeatherViewController") as? ShowWeatherViewController
        showWeather?.cities = cities[indexPath.row].lowercased()
        self.navigationController?.pushViewController(showWeather!, animated: true)
        
        print("You chose \(indexPath.row) with value \(String(cities[indexPath.row].lowercased()))")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//  UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row].uppercased()
        
        return cell
    }
}
//
//extension ForecastViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You chose \(indexPath.row)")
//    }
//}
//
//extension ForecastViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cities.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        cell.textLabel?.text = cities[indexPath.row]
//
//        return cell
//    }
//}

