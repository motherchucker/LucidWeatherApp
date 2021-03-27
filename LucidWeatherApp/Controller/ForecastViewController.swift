//
//  ForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 12/03/2021.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowWeatherViewControllerDelegate {
  var citiesArray = [City]()
  var locationManager: CLLocationManager!
  var isUsingCurrentLocation = false
  var currentCity: City?
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var showWeatherForCurrentLocationButton: UIButton!
  @IBOutlet weak var metricSystemLabel: UILabel!
  
  @IBAction func btnGetLocation(_ sender: Any) {
    isUsingCurrentLocation = true
    self.performSegue(withIdentifier: Constants.segueShowCity, sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // add cities
    let rijeka = City(name: "rijeka")
    citiesArray.append(rijeka)
    let zagreb = City(name: "zagreb")
    citiesArray.append(zagreb)
    let london = City(name: "london")
    citiesArray.append(london)
    let chicago = City(name: "chicago")
    citiesArray.append(chicago)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    // Creating a CLLocationManager will automatically check authorization
    self.locationManager = CLLocationManager()
    self.locationManager.delegate = self
    
    // Enable showWeatherForCurrentLocationButton only after the current location if fetched
    showWeatherForCurrentLocationButton.isEnabled = false
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let showWeatherViewController = segue.destination as? ShowWeatherViewController {
      showWeatherViewController.delegate = self
      if segue.identifier == Constants.segueShowCity{
        if
          let city = currentCity,
          isUsingCurrentLocation
        {
          showWeatherViewController.city = city
        } else {
          if let selectedIndexPath = tableView.indexPathForSelectedRow {
            showWeatherViewController.city = citiesArray[selectedIndexPath.row]
            tableView.deselectRow(at: selectedIndexPath, animated: true)
          } else {
            showWeatherViewController.city = citiesArray[0]
          }
        }
      }
    }
  }
  
  // MARK: - ShowWeatherViewControllerDelegate
  
  func showWeatherViewController(_ sender: ShowWeatherViewController, didChageMetricSystemTo metricSystem: MetricSystem) {
    metricSystemLabel.isHidden = false
    metricSystemLabel.text = metricSystem.rawValue
  }
  
  //  MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isUsingCurrentLocation = false
    performSegue(withIdentifier: Constants.segueShowCity, sender: self)
    // Log - What is chosen:
    print("You chose \(indexPath.row) with value \(String(citiesArray[indexPath.row].name))")
  }
  
  //  MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return citiesArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
    cell.textLabel?.text = citiesArray[indexPath.row].name.uppercased()
    
    return cell
  }
}

// MARK: - CLLocationManagerDelegate
extension ForecastViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("Checking authentication status.")
    handleAuthenticalStatus(status: status)
  }
  
  func handleAuthenticalStatus(status: CLAuthorizationStatus) {
    switch status {
    
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app.")
    case .denied:
      break
    case .authorizedAlways:
      locationManager.requestLocation()
    case .authorizedWhenInUse:
      locationManager.requestLocation()
    @unknown default:
      print("Unknown case of status in handleAuthenticalStatus\(status)")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Deal with change in location
    let currentLocation = locations.last ?? CLLocation()
    print("Current location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.latitude)")
    
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
      var locationCityName = ""
      if placemarks != nil{
        //get the first placemark
        let placemark = placemarks?.last
        // assign placemark to locationCityName
        locationCityName = placemark?.locality ?? "City Unknown"
      } else {
        print("Error retrieving location.")
        locationCityName = "Coludn't find location"
      }
      print("Location City: \(locationCityName)")
      
      // For cities with two words in their name, for example: San Francisco
      locationCityName = locationCityName.replacingOccurrences(of: " ", with: "+")
      
      let currentCity = City(name: locationCityName)
      self.currentCity = currentCity
      
      self.showWeatherForCurrentLocationButton.isEnabled = true
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error: \(error.localizedDescription). Failed to get device location.")
  }
}


extension UIViewController {
  func oneButtonAlert(title: String, message: String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
