//
//  MapViewController.swift
//  Phase 1
//
//  Created by Narcis Zait on 04/02/2019.
//  Copyright © 2019 Narcis Zait. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var carMarkers = Car()
    var mapView = GMSMapView()
    var chargersArray = Charger()
    var closestChargers = Charger()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Routes", style: .plain, target: self, action: #selector(showRoutes))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItems?.forEach({ (button) in
            button.tintColor = UIColor.white
        })
        
        let camera = GMSCameraPosition.camera(withLatitude: 55.6761, longitude: 12.5683, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        chargersArray = ChargerElement.parseFromLocal()
        
        loadCarsOnMap()
//        loadChargersOnMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let origins = mapView.myLocation {
            loadChargersOnMap()
        }
    }

    func loadCarsOnMap() {
        for car in carMarkers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!)
            marker.title = "Battery \(car.batteryPercentage) %"
            marker.snippet = "Interest: \(car.interestInTheCar) %"
            marker.map = mapView
            
            let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!)
            let circ = GMSCircle(position: circleCenter, radius: 1000)
            circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
            circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
            circ.strokeWidth = 2.5;
            circ.map = mapView;
        }
    }
    
    func loadChargersOnMap() {
        print("loading chargers")
        if let origins = mapView.myLocation {
            print("loading chargers 1")
            for car in carMarkers {
                for charger in chargersArray {
                    if CLLocation(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!).distance(from: CLLocation(latitude: charger.latitude, longitude: charger.longitude)) < 1000
                    && CLLocation(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!).distance(from: CLLocation(latitude: charger.latitude, longitude: charger.longitude)) > 700
                    && charger.history > 500
                    && charger.interest > 50 {
                        print("distance \(CLLocation(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!).distance(from: CLLocation(latitude: charger.latitude, longitude: charger.longitude)))")
                        print("loading chargers 2")
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: Double(charger.latitude), longitude: Double(charger.longitude))
                        marker.title = "Charger \(Int(CLLocation(latitude: Double(car.latitude)!, longitude: Double(car.longitude)!).distance(from: CLLocation(latitude: charger.latitude, longitude: charger.longitude)))) m"
                        marker.snippet = "Rented prev. \(charger.history)"
                        marker.icon = GMSMarker.markerImage(with: UIColor.green)
                        marker.map = mapView
                        closestChargers.append(charger)
                        print("loading chargers 3")
                    }
                }
            }
        }
    }
    
    @objc func showRoutes(){
        //shortest route between user location and the selected cars
        //Hellerup St. 55.731201,12.567642
        //Vesterport St. 55.675802,12.562530
        
        if let origins = mapView.myLocation?.coordinate {
            var destinations = ""
            
            for car in carMarkers {
                destinations.append(car.latitude + "," + car.longitude + "|")
            }
            
            for charger in closestChargers {
                destinations.append("\(charger.latitude),\(charger.longitude)|")
            }
            
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origins.latitude),\(origins.longitude)&destination=\(origins.latitude),\(origins.longitude)&waypoints=optimize:true|\(destinations)&key="
            let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
            let searchURL = URL(string: urlStr as String)!
            
            print("url: \(url)")
            
            let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) -> Void in
                
                do {
                    if data != nil {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]
                        print(dic)
                        
                        let status = dic["status"] as! String
                        var routesArray:String!
                        if status == "OK" {
                            routesArray = ((((dic["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as! String)
                        }
                        
                        DispatchQueue.main.async {
                            let path = GMSPath.init(fromEncodedPath: routesArray!)
                            let singleLine = GMSPolyline.init(path: path)
                            singleLine.strokeWidth = 6.0
                            singleLine.strokeColor = .blue
                            singleLine.map = self.mapView
                        }
                        
                    }
                } catch {
                    print("Error")
                }
            }
            task.resume()
        }
    }
}
