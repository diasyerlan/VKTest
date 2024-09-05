//
//  LocationViewController.swift
//  VKTestApp
//
//  Created by Dias Yerlan on 04.09.2024.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    let cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    
    
    func setupUI() {
        view.addSubview(cityName)
        
        NSLayoutConstraint.activate([
            cityName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityName.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchCurrentCity(from: location) { city, error in
                guard let city = city, error == nil else { return }
                self.cityName.text = city
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: Failed to find current location - \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location access denied")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                break
            }
    }
    
    func fetchCurrentCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let city = placemarks?.first?.locality {
                completion(city, error)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No city found"]))
            }
        }
    }
    
}
