//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func updateUI(weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    
    func search(){
        print("Searching : ",searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        search()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == searchTextField){
            search()
            return true
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField == searchTextField){
            if textField.text != ""{
                return true
            } else {
                textField.placeholder = "Type something"
            }
        }
        return false;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == searchTextField){
            if let city = textField.text {
                weatherManager.fetchWeather(cityName: city)
            }
            
            searchTextField.text = ""
            textField.placeholder = "Search"
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("Result : ",weather.temperatureString)
        updateUI(weather: weather)
    }
    
    func didFailedWithError(_ error: Error) {
        if(error is WeatherError){
            print((error as! WeatherError).message ?? "HMM")
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
        else{
            print("No location!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
