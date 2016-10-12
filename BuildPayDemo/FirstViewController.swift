//
//  FirstViewController.swift
//  BuildPayDemo
//
//  Created by Mark Bofill on 9/21/16.
//  Copyright © 2016 Mark Bofill. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomButton : UIButton {
    var gps : String
    var title: String
    init() {
       
       self.gps = ""
       self.title = ""
       super.init(frame: CGRectZero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

var firstzoomnotdone : Bool = true
var firstinitpinsdone : Bool  = false

var mPins : [GMSMarker] = []
var pPins : [GMSMarker] = []
var oPins : [GMSMarker] = []

var userloc : CLLocation = CLLocation()


func init_pins() {
    print ("mRecs count")
    print (mRecs.count)
    for a in mRecs {
        let p = GMSMarker()
        p.position = CLLocationCoordinate2DMake(a.latitude,a.longitude)
        p.title = a.name
        p.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        p.map = nil
        mPins.append(p)
    }
    for a in pRecs {
        let p = GMSMarker()
        p.position = CLLocationCoordinate2DMake(a.latitude,a.longitude)
        p.title = a.name
        p.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        p.map = nil
        pPins.append(p)
    }
    for a in oRecs {
        let p = GMSMarker()
        p.position = CLLocationCoordinate2DMake(a.latitude,a.longitude)
        p.title = a.name
        p.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        p.map = nil
        oPins.append(p)
    }
    

}
class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    var locationManager : CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        
        //init_pins()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        print("viewWillAppear called")
        print("in viewWillAppear")
        
        if merchantsOn {
            if !firstinitpinsdone { init_pins(); firstinitpinsdone=true; }

            for a in mPins {
                a.map = mapView
            }
        }
        else {
            for a in mPins {
                a.map = nil
            }
            
        }
        
        if projectsOn {
            for a in pPins {
                 a.map = mapView
            }
        }
        else {
            for a in pPins {
                a.map = nil
            }
        }
        if suppliersOn {
            for a in oPins {
                a.map = mapView
            }
        }
        else {
            for a in oPins {
                a.map = nil
            }
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            userloc = location
            print (userloc.coordinate.latitude)
            print (userloc.coordinate.longitude)
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        
        print ("in didtapmarker")
        if marker.title != nil {
            
            let mapViewHeight = mapView.frame.size.height
            let mapViewWidth = mapView.frame.size.width
            
            
            let container = UIView()
            //container.frame = CGRectMake(mapViewWidth - 100, mapViewHeight - 63, 65, 35)
            container.frame = CGRectMake(mapViewWidth - 100, 0, 65, 35)
            container.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(container)
            
            let googleMapsButton = CustomButton()
            //googleMapsButton.setTitle("*", forState: .Normal)
            //googleMapsButton.setImage(UIImage(named: "directions"), forState: .Normal) //googlemaps
            //googleMapsButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            //googleMapsButton.frame = CGRectMake(mapViewWidth - 80, 0, 50, 50)
            //googleMapsButton.addTarget(self, action: "markerClick:", forControlEvents: .TouchUpInside)
            googleMapsButton.gps = String(marker.position.latitude) + "," + String(marker.position.longitude)
            googleMapsButton.title = marker.title!
            googleMapsButton.tag = 0
            
            let directionsButton = CustomButton()
            
            //directionsButton.setTitle("+", forState: .Normal)
            //directionsButton.setImage(UIImage(named: "googlemapsdirection"), forState: .Normal)
            directionsButton.setImage(UIImage(named: "directions"), forState: .Normal)
            directionsButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            directionsButton.frame = CGRectMake(mapViewWidth - 110, 0, 50, 50)
            directionsButton.addTarget(self, action: #selector(FirstViewController.markerClick(_:)), forControlEvents: .TouchUpInside)
            directionsButton.gps = String(marker.position.latitude) + "," + String(marker.position.longitude)
            directionsButton.title = marker.title!
            directionsButton.tag = 1
            self.view.addSubview(googleMapsButton)
            self.view.addSubview(directionsButton)
        }
        return false
    }
    
    func markerClick(sender: CustomButton) {
        let fullGPS = sender.gps
        let fullGPSArr = fullGPS.characters.split{$0 == ","}.map(String.init)
        
        let lat1 : NSString = fullGPSArr[0]
        let lng1 : NSString = fullGPSArr[1]
        
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let slat:CLLocationDegrees = userloc.coordinate.latitude
        
        let slon:CLLocationDegrees = userloc.coordinate.longitude
        
        print ("in marker click")
        print (lat1)
        print (lng1)
        print ("comgooglemaps://?saddr=\(slat),\(slon)&daddr=\(latitude),\(longitude)&directionsmode=driving")
        if (1==0) {
        /*
        if (UIApplication.sharedApplication().openURL(NSURL(string:"comgooglemaps://")!)) {
            if (sender.tag == 1 || sender.tag == 0) {
                
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?saddr=\(slat),\(slon)&daddr=\(latitude),\(longitude)&directionsmode=driving")!)
 
            } else if (sender.tag == 6) {
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic")!)
            }
            
        }
        */
        }
        else {
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            var options = NSObject()
            if (sender.tag == 1) {
                options = [
                    MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span),
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                ]
            } else if (sender.tag == 0) {
                options = [
                    MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
                ]
            }
            
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = sender.title
            mapItem.openInMapsWithLaunchOptions(options as? [String : AnyObject])
 
            //print ("need google directions")
        }
    }
 
}

