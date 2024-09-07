//
//  WeatherViewController.swift
//  VKTestApp
//
//  Created by Dias Yerlan on 04.09.2024.
//

import UIKit
import CoreLocation
import Alamofire
import SnapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let apiKey = "ab3b3fccf2b75183232a8fed1bb320e3"
    
    let weatherView = WeatherView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupLocationManager()
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    func setupUI() {
        view.addSubview(weatherView)
        view.addSubview(activityIndicator)
        
        weatherView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            startLoading()
            fetchWeatherData(for: location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func fetchWeatherData(for coordinate: CLLocationCoordinate2D) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: [String: Any] = [
            "lat": coordinate.latitude,
            "lon": coordinate.longitude,
            "units": "metric",
            "appid": apiKey
        ]
        
        // Use Alamofire to fetch weather data
        AF.request(urlString, parameters: parameters).responseData { response in
            self.stopLoading()
            switch response.result {
            case .success(let res):
                do {
                    let value = try JSONSerialization.jsonObject(with: res)
                    if let json = value as? [String: Any],
                       let main = json["main"] as? [String: Any],
                       let temperature = main["temp"] as? Double,
                       let name = json["name"] as? String,
                       let weatherArray = json["weather"] as? [[String: Any]],
                       let weather = weatherArray.first,
                       let description = weather["description"] as? String {
                        // Update the UI with weather data on the main thread
                        DispatchQueue.main.async {
                            self.weatherView.updateWeather(cityName: name, temperature: temperature, weatherDescription: description)
                        }
                    }
                } catch {
                    print("Error in decoding proccess - \(error)")
                }
                
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: Failed to get user location - \(error.localizedDescription)")
    }
}
