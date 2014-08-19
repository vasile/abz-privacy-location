//
//  ViewController.swift
//  AppBuildersLocationDemo
//
//  Created by Vasile Cotovanu on 19/08/14.
//  Copyright (c) 2014 local.ch ag. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var authorizationStatusLabel: UILabel!
    @IBOutlet var locationTimestampLabel: UILabel!
    @IBOutlet var locationCoordinatesLabel: UILabel!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        authorizationStatusLabel.adjustsFontSizeToFitWidth = true
        locationTimestampLabel.adjustsFontSizeToFitWidth = true
        locationCoordinatesLabel.adjustsFontSizeToFitWidth = true
        
        println("The device is able to report significant location changes: \(CLLocationManager.significantLocationChangeMonitoringAvailable())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        locationTimestampLabel.text = "Time: \(formatter.stringFromDate(locations[0].timestamp!))"
        locationCoordinatesLabel.text = "Coords: \(locations[0].coordinate!.latitude), \(locations[0].coordinate!.longitude)"
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Whoops, errors occured \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var statusHumanValue : String;
        
        switch (status) {
            case CLAuthorizationStatus.NotDetermined:
                statusHumanValue = "NotDetermined"
            case CLAuthorizationStatus.Restricted:
                statusHumanValue = "RESTRICTED"
            case CLAuthorizationStatus.Denied:
                statusHumanValue = "DENIED"
            case CLAuthorizationStatus.Authorized:
                statusHumanValue = "ALWAYS"
            case CLAuthorizationStatus.AuthorizedWhenInUse:
                statusHumanValue = "When in Use"
            default:
                statusHumanValue = "n/a CLAuthorizationStatus"
        }
        
        authorizationStatusLabel.text = "Authorization Status: \(statusHumanValue)"
    }
    
    func checkAuthorization() {
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined) {
            println("Go to app settings and switch manually ")
        }
    }
    
    @IBAction func handleWhenInUse(AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        checkAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func handleAlways(AnyObject) {
        locationManager.requestAlwaysAuthorization()
        checkAuthorization()

        locationManager.startUpdatingLocation()
    }
    
    @IBAction func launchAppSettings(AnyObject) {
        let url = NSURL(string:UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url)
    }
    
}

