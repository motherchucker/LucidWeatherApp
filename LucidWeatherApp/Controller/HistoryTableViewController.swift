//
//  HistoryTableViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 15/03/2021.
//

import UIKit


class HistoryTableViewController: UITableViewController {
  
  var weatherInfo = WeatherInfoHistory()
  var savedWeather: [CityWeather]?
  let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
  @IBOutlet var tableViewHistory: UITableView!
  
  
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
            destination.weatherInfo = self.weatherInfo
          }
      }
  }
  
// UITableViewDataSource
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
  
// UITableViewDelegate - Display forecast for row
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let weather = self.savedWeather![indexPath.row]
    
    let formattedDate = DateFormatter()
    formattedDate.dateStyle = .medium
    formattedDate.timeStyle = .none
    formattedDate.locale = Locale(identifier: "hr")
    
    //var weatherInfo = WeatherInfoHistory()
    self.weatherInfo.dateSaved = formattedDate.string(from: weather.date!)
    self.weatherInfo.name = weather.cityName!
    self.weatherInfo.temp = weather.temp
    self.weatherInfo.pressure = Double(weather.pressure)
    self.weatherInfo.humidity = Double(weather.humidity)
    self.weatherInfo.speed = weather.windSpeed
    self.weatherInfo.descript = weather.weatherDescription!
    print("Data set.")
    
      
    performSegue(withIdentifier: "showForecast", sender: self)
    
    tableViewHistory.deselectRow(at: indexPath, animated: true)
  }
  
// Delete row
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
