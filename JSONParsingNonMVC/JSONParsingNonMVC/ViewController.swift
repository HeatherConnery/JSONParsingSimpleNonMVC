//
//  ViewController.swift
//  JSONParsingNonMVC
//
//  Created by Heather Connery on 2015-11-11.
//  Copyright © 2015 HConnery. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var mapPins = [MapPin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: API_URL)
        var lati:Double = 0.0
        var long:Double = 0.0
        var stationName:String = ""
        
        //location manager code
        self.locationManager.delegate = self
        self.mapView.delegate = self
        //start updating location
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        ///AlamoFire API (request is enum - choose .GET, do on: url!)
        //JSON response is fn composition
        Alamofire.request(.GET, url!).responseJSON { (response) -> Void in
            //return  value of .Get request
            let result = response.result
            print(result)
            //get some data from teh API
            if let dict = result.value as? Dictionary<String,AnyObject> {
                //print(dict)
                if let routes = dict["locations"] as? NSArray {
                    //print("\(routes)")
                    for route in routes {
                        if let name = route["name"] as? String {
                            stationName = name
                            //print(name)
                        }
                        if let lat = route["lat"]  as? Double {
                            lati = lat
                        }
                        if let lng = route["lng"] as? Double {
                            long = lng
                        }
                        //print("End of Data set")
                        let pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long), title: stationName, subtitle: "Set name")
                        self.mapPins.append(pin)
                        //print(self.mapPins)
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

