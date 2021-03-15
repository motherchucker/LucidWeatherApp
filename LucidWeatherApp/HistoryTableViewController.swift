//
//  HistoryTableViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 15/03/2021.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    @IBOutlet var tableViewHistory: UITableView!
    
    // Retrieve data from CoreData
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var savedWeather: [CityWeather]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHistory.dataSource = self
        tableViewHistory.delegate = self
        
        fetchForecast()
        
    }
    
    func fetchForecast(){
        do{
            self.savedWeather = try context.fetch(CityWeather.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableViewHistory.reloadData()
            }
        }
        catch{
            print("Error while fetching data")
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.savedWeather?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        
        let weather = self.savedWeather![indexPath.row]
        cell.textLabel?.text = "\(weather.cityName!) temp: \(weather.temp)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // data to remove
            let savedWeatherToRemove = self.savedWeather![indexPath.row]
            // remove
            self.context.delete(savedWeatherToRemove)
            do{
                try self.context.save()
            }
            catch{
                print("Error while saving data after deleting row")
            }
            // re-fetch data
            self.fetchForecast()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    

}