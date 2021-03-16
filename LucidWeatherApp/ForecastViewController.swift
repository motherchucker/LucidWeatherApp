//
//  ForecastViewController.swift
//  LucidWeatherApp
//
//  Created by mrsic on 12/03/2021.
//

import UIKit
import CoreLocation

class Cities {
    var cityName : String?
    
    init(cityN: String){
        self.cityName = cityN
    }
}

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var citiesArray = [Cities]()
    var locationManager: CLLocationManager!
    var cityName = ""
    var clickedRow = false

    
    @IBAction func btnGetLocation(_ sender: Any) {
        clickedRow = false
        getLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "showCity", sender: self)
        }
    }
    
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
        
        clickedRow = true
        performSegue(withIdentifier: "showCity", sender: self)
        
        // Log - What is chosen:
        print("You chose \(indexPath.row) with value \(String(citiesArray[indexPath.row].cityName!))")
        
    }
    
// Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowWeatherViewController{
            if segue.identifier == "showCity"{
                if(clickedRow){
                    destination.cities = citiesArray[(tableView.indexPathForSelectedRow?.row)!]
                    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
                }
                else {
                    destination.city = cityName
                }
            }
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

// location
extension ForecastViewController : CLLocationManagerDelegate{
    func getLocation(){
        // Creating a CLLocationManager will automatically check authorization
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Checking authentication status.")
        handleAuthenticalStatus(status: status)
    }
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus){
        switch status{
        
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
            self.cityName = locationCityName
            
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
