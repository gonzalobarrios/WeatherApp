//
//  ViewController.swift
//  AstroWeather
//
//  Created by Gonzalo Barrios on 2/9/19.
//  Copyright © 2019 Gonzalo Barrios. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire
import Kingfisher

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate  {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // MARK: - Properties
    
    var locationManager = CLLocationManager()
    var currentLocationActivated = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupUI()
        setupCoreLocation()
    }
    
    // MARK: - Setup
    
    func setupUI() {
        hideKeyboard()
        let locationImg = UIImage(named: "CurrentLocationIcon");
        let tintedImage = locationImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        currentLocationButton.setImage(tintedImage, for: .normal)
        currentLocationButton.tintColor = UIColor.red
    }
    
    func setupCoreLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        if let txt = searchBar.text {
            if txt.isEmpty && currentLocationActivated {
                getWeatherForLocation(cityName: nil, coordinates: location)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let cityName = searchBar.text, !cityName.isEmpty {
            getWeatherForLocation(cityName: cityName, coordinates: nil)
        }
    }
    
    func getWeatherForLocation(cityName: String?, coordinates: CLLocation?) {
        
        RequestManager.sharedInstance.getWeather(cityName: cityName, coordinate: coordinates, completion: ({ (weather, error) in
            if let weather = weather {
                self.descriptionLabel.text = weather.description
                self.tempLabel.text = weather.temp
                self.maxTempLabel.text = weather.maxTemp
                self.minTempLabel.text = weather.minTemp
                self.humidityLabel.text = weather.humidity
                self.pressureLabel.text = weather.pressure
                self.windLabel.text = weather.wind
                self.cityNameLabel.text = weather.city
                
                if let imageURL = weather.imageURL {
                    let url = URL(string: imageURL)
                    self.weatherImageView.kf.setImage(with: url)
                } else {
                    self.weatherImageView.image = UIImage(named: "AppMainIcon")
                }
                
            } else {
                let alert = UIAlertController(title: "Weather not found", message: "Please enter an existing locality name or check if you have internet conexion.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }))
    }
    
    @IBAction func activateCurrentLocationAction(_ sender: Any) {
        if currentLocationActivated {
            currentLocationActivated = false
            locationManager.stopUpdatingLocation()
            currentLocationButton.tintColor = UIColor.darkGray
        } else {
            currentLocationActivated = true
            locationManager.startUpdatingLocation()
            currentLocationButton.tintColor = UIColor.red
        }
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
