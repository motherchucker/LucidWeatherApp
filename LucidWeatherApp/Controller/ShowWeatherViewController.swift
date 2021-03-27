//
//  ShowWeatherViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 13/03/2021.
//

import UIKit

protocol ShowWeatherViewControllerDelegate: AnyObject {
  func showWeatherViewController(_ sender: ShowWeatherViewController, didChageMetricSystemTo metricSystem: MetricSystem)
}

class ShowWeatherViewController: UIViewController {
  var city: City!
  weak var delegate: ShowWeatherViewControllerDelegate?
  
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var weatherInfo: WeatherInfo?

  private var metricSystem: MetricSystem! {
    didSet {
      UserDefaults.standard.setValue(metricSystem.rawValue, forKey: "kMetricSystem")
    }
  }
  
  @IBOutlet weak var metricSystemSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lblCityName: UILabel!
  @IBOutlet weak var lblTemp: UILabel!
  @IBOutlet weak var lblPressure: UILabel!
  @IBOutlet weak var lblHumidity: UILabel!
  @IBOutlet weak var lblWindSpeed: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let savedMetricSystemString = UserDefaults.standard.value(forKey: "kMetricSystem") as? String {
      metricSystem = MetricSystem(rawValue: savedMetricSystemString)
      
      if metricSystem! == .metric {
        metricSystemSegmentedControl.selectedSegmentIndex = 0
      } else {
        metricSystemSegmentedControl.selectedSegmentIndex = 1
      }
    } else {
      metricSystem = .metric
    }
    
    self.navigationItem.title = city.name.capitalFirstLetter()
    
    view.showActivityIndicator(true)
    WeatherAPI.shared.getWeatherDataForCity(city, tempUnit: metricSystem) { (result: GetWeatherResult) in
      self.view.showActivityIndicator(false)
      switch result {
      case .failure(let error):
        debugPrint(error)
      case .success(let weatherInfo):
        self.weatherInfo = weatherInfo
        self.populateWeatherData(weatherInfo)
      }
    }
    
    delegate?.showWeatherViewController(self, didChageMetricSystemTo: metricSystem)
  }
  
  
  // MARK: - IBActions
  
  @IBAction func weatherChangeSegment(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      metricSystem = .metric
    } else {
      metricSystem = .imperial
    }
    
    delegate?.showWeatherViewController(self, didChageMetricSystemTo: metricSystem)

    view.showActivityIndicator(true)
    WeatherAPI.shared.getWeatherDataForCity(city, tempUnit: metricSystem) { (result: GetWeatherResult) in
      self.view.showActivityIndicator(false)
      switch result {
      case .failure(let error):
        debugPrint(error)
      case .success(let weatherInfo):
        self.weatherInfo = weatherInfo
        self.populateWeatherData(weatherInfo)
      }
    }
  }
  
  // Save data button
  @IBAction func btnSaveData(_ sender: Any) {
    //save
    guard let weatherInfo = weatherInfo else {
      let alert = UIAlertController(title: "Error", message: "Weather info missing!", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
      return
    }
    
    let newCityData = CityWeather(context: context)
    newCityData.date = NSDate(timeIntervalSince1970: weatherInfo.dateSaved) as Date
    newCityData.cityName = weatherInfo.name
    newCityData.temp = weatherInfo.temp
    newCityData.pressure = Int64(weatherInfo.pressure)
    newCityData.humidity = Int64(weatherInfo.humidity)
    newCityData.windSpeed = weatherInfo.speed
    newCityData.weatherDescription = weatherInfo.descript
    do{
      try self.context.save()
      // check
      print("Data saved")
    }
    catch{
      print("Error with saving data")
    }
  }
  
  
  // MARK: - Private methods
  
  private func populateWeatherData(_ weatherInfo: WeatherInfo) {
    lblCityName.text = "City: \(weatherInfo.name)"
    lblTemp.text = "Temperature: \(weatherInfo.temp)"
    lblPressure.text = "Pressure: \(weatherInfo.pressure)"
    lblHumidity.text = "Humidity: \(weatherInfo.humidity)"
    lblWindSpeed.text = "Wind speed: \(weatherInfo.speed)"
    lblDescription.text = "Weather today: \(weatherInfo.descript)"
  }
}
