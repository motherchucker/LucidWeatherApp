//
//  HistoryTableViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 15/03/2021.
//

import UIKit


class HistoryTableViewController: UITableViewController {
    
    var date = ""
    var cityName = ""
    var temp = 0.0
    var pressure = 0
    var humidity = 0
    var speed = 0.0
    var descript = ""
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchForecast()
    }

// Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowForecastViewController{
            if segue.identifier == "showForecast"{
                destination.date = self.date
                destination.cityName = self.cityName
                destination.temp = self.temp
                destination.pressure = self.pressure
                destination.humidity = self.humidity
                destination.speed = self.speed
                destination.descript = self.descript
            }
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
        
        let formattedDate = DateFormatter()
        formattedDate.dateStyle = .medium
        formattedDate.timeStyle = .none
        formattedDate.locale = Locale(identifier: "hr")
        
        self.date = formattedDate.string(from: weather.date!)
        self.cityName = weather.cityName!
        self.temp = weather.temp
        
        cell.textLabel?.text = "\(formattedDate.string(from: weather.date!))\t\(weather.cityName!)\t\(weather.temp)°C"
        
        return cell
    }
    
    // Display forecast for row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weather = self.savedWeather![indexPath.row]
        
        let formattedDate = DateFormatter()
        formattedDate.dateStyle = .medium
        formattedDate.timeStyle = .none
        formattedDate.locale = Locale(identifier: "hr")
        
        self.date = formattedDate.string(from: weather.date!)
        self.cityName = weather.cityName!
        self.temp = weather.temp
        self.pressure = Int(weather.pressure)
        self.humidity = Int(weather.humidity)
        self.speed = weather.windSpeed
        self.descript = weather.weatherDescription!
        print("Data set.")
        
        performSegue(withIdentifier: "showForecast", sender: self)
      
        tableViewHistory.deselectRow(at: indexPath, animated: true)
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
