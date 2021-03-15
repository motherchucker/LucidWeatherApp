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
                // check
                print("Data reloaded inside fetch")
            }
        }
        catch{
            print("Error while fetching data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check
        print("Data reloaded tab")
        fetchForecast()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.savedWeather?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        
        let weather = self.savedWeather![indexPath.row]
        
        let formattedDate = DateFormatter()
        formattedDate.dateStyle = .medium
        formattedDate.timeStyle = .none
        formattedDate.locale = Locale(identifier: "hr")
        
        cell.textLabel?.text = "\(formattedDate.string(from: weather.date!))\t\(weather.cityName!)\t\(weather.temp)°C"
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
