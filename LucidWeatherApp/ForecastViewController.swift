//
//  ForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 12/03/2021.
//

import UIKit

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    let cities = [
        "Rijeka",
        "Zagreb",
        "London",
        "Chicago"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension ForecastViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You chose \(indexPath.row)")
    }
}

extension ForecastViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row]
        
        return cell
    }
}

