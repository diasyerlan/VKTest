//
//  WeatherView.swift
//  VKTestApp
//
//  Created by Dias Yerlan on 04.09.2024.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: - UI elements
    
    let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(weatherIcon)
        addSubview(cityName)
        addSubview(temperature)
        
        NSLayoutConstraint.activate([
            weatherIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            
            cityName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityName.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 20),
            
            temperature.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperature.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 20)

        ])
    }
    
    func updateWeather(cityName: String, temperature: Double, weatherDescription: String) {
        self.cityName.text = cityName
        self.temperature.text = "\(String(format: "%.1f", temperature))°C"
        print(weatherDescription)
        updateWeatherIcon(for: weatherDescription)
        
    }
    
    func updateWeatherIcon(for description: String) {
        var systemIconName: String
        
        switch description.lowercased() {
                case "clear sky", "sunny":
                    systemIconName = "sun.max"
                case "few clouds", "scattered clouds", "broken clouds":
                    systemIconName = "cloud.sun"
                case "cloudy", "overcast clouds":
                    systemIconName = "cloud"
                case "shower rain", "rain":
                    systemIconName = "cloud.rain"
                case "thunderstorm":
                    systemIconName = "cloud.bolt.rain"
                case "snow":
                    systemIconName = "snow"
                case "mist", "fog":
                    systemIconName = "cloud.fog"
                default:
                    systemIconName = "questionmark.circle"
                }
        weatherIcon.image = UIImage(systemName: systemIconName)
    }
}
