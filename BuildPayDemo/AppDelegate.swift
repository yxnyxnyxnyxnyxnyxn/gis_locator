//
//  AppDelegate.swift
//  BuildPayDemo
//
//  Created by Mark Bofill on 9/21/16.
//  Copyright © 2016 Mark Bofill. All rights reserved.
//

let googleMapsApiKey = "AIzaSyArHDPuw-SOukkCyt5yD30ftIgw74A9pyg"
let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"


import UIKit

class latlon {
    var latitude : Double
    var longitude : Double
    init() {
        latitude = 0.0
        longitude = 0.0
    }
}

class location_record {
    var latitude : Double
    var longitude : Double
    var street_adr: String
    var city: String
    var state: String
    var zip: String
    var name: String
    var category : String
    var status : String
    init() {
        self.latitude = 0.0;
        self.longitude = 0.0;
        self.street_adr = "none"
        self.city = "none"
        self.state = "none"
        self.zip = "none"
        self.name = "none"
        self.category = "none"
        self.status = "P"
    }
}

class simpleTCPConnection: NSObject, NSStreamDelegate {
    var inp: NSInputStream?
    var out: NSOutputStream?
    
    func open() {
        let addr = "184.74.15.30"
        let port = 8103
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inp, outputStream: &out)
        inp!.open()
        out!.open()
        
    }
    func read() -> String {
        let bufferSize = 1
        var inputBuffer = Array<UInt8>(count:bufferSize, repeatedValue: 0)
        var done : Bool = false
        var sawCR: Bool = false
        var sawLF: Bool = false
        var retstr : String = ""
        usleep(1000);
        while !done {
            if (sawCR && sawLF) { done = true; break }
            let bytesRead = inp!.read(&inputBuffer, maxLength: 1)
            if (bytesRead == 1) {
                if (inputBuffer[0]==13) { sawCR = true; continue }
                if (inputBuffer[0]==10) { sawLF = true; continue}
                if (sawCR && sawLF) { done = true }
                retstr.append(UnicodeScalar(inputBuffer[0]))
            }
        }
        
        return retstr;
    }
    
}


var merchantsOn : Bool = false
var projectsOn : Bool  = false
var suppliersOn : Bool  = false

var mRecs : [location_record] = []
var pRecs : [location_record] = []
var oRecs : [location_record] = []

var LaterLL : [latlon] = []

/*
 geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
 
 })
 */


func geoLocate(tmp:location_record!,completionHandler: (ll : latlon, name : String, error: NSError?) -> ()) -> Void {
    
    let gc:CLGeocoder = CLGeocoder()
    let ll = latlon()
    let lname = tmp.name
    let address = tmp.street_adr + "," + tmp.city + "," + tmp.state + "," + tmp.zip
    print (address)
    gc.geocodeAddressString(address, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        let pm = placemarks! as [CLPlacemark]
        if (placemarks!.count > 0){
            let p = pm[0]
            
            ll.latitude = p.location!.coordinate.latitude
            ll.longitude = p.location!.coordinate.longitude
        
            
            //do your stuff
            completionHandler(ll : ll, name : lname, error: nil)
        }
        print ("ok")
    })
}

/*
func geoLocate(address:String!) -> latlon {
var geocoder = CLGeocoder()
var ll = latlon()
geocoder.geocodeAddressString(address) {
    if let placemarks = $0 {
        print ("here")
        print (placemarks)
    } else {
        print ("there")
        print($1)
    }
}
    return ll
}
*/
func init_location_records() {
    var s : String = ""
    let c = simpleTCPConnection()
    
    c.open()
    s = c.read()
    print (s)
    let numEntries : Int = Int(s)!
    for _ in 1...numEntries {
        let tmp = location_record()
        s = c.read(); tmp.name = s
        s = c.read(); tmp.street_adr = s
        s = c.read(); tmp.city = s
        s = c.read(); tmp.state = s
        s = c.read(); tmp.zip = s
        s = c.read(); tmp.status = s
        s = c.read(); tmp.category = s
        print ("loading record " + tmp.name)
        if tmp.category == "Merchants" {
           mRecs.append(tmp)
           print ("adding to merchants")
        }
        if tmp.category == "Projects" {
            pRecs.append(tmp)
            print ("adding to projects")
        }
        if tmp.category == "Suppliers" {
            oRecs.append(tmp)
            print ("adding to suppliers")
        }
    }
    
    for x in mRecs {
        //ll = geoLocate(tmp.street_adr + "," + tmp.city + "," + tmp.state + "," + tmp.zip)
        geoLocate(x) { ll, tmnp, error in
            if error != nil {
                // handle the error here
            } else {
                print ("in my completion handlers")
            
                print (tmnp)
                print (x.name)
                print (ll.latitude)
                print (ll.longitude)
                
                x.latitude = ll.latitude
                x.longitude = ll.longitude
                
            }
        }

    }
    for x in pRecs {
        //ll = geoLocate(tmp.street_adr + "," + tmp.city + "," + tmp.state + "," + tmp.zip)
        geoLocate(x) { ll, tmnp, error in
            if error != nil {
                // handle the error here
            } else {
                print ("in my completion handlers")
                
                print (tmnp)
                print (x.name)
                print (ll.latitude)
                print (ll.longitude)
                
                x.latitude = ll.latitude
                x.longitude = ll.longitude
                
            }
        }
        
    }
    for x in oRecs {
        //ll = geoLocate(tmp.street_adr + "," + tmp.city + "," + tmp.state + "," + tmp.zip)
        geoLocate(x) { ll, tmnp, error in
            if error != nil {
                // handle the error here
            } else {
                print ("in my completion handlers")
                
                print (tmnp)
                print (x.name)
                print (ll.latitude)
                print (ll.longitude)
                
                x.latitude = ll.latitude
                x.longitude = ll.longitude
                
            }
        }
        
    }

    

    /*
    tmp.latitude = 42.729914
    tmp.longitude = -73.690902
    tmp.name = "Ace Hardware of Troy"
    tmp.street_adr = "63 3rd St"
    tmp.city = "Troy"
    tmp.state = "NY"
    tmp.zip = "12180"
    mRecs.append(tmp)
    /*
    var annotation = ColorPointAnnotation(pinColor: MKPinAnnotationColor.Green)
    annotation.coordinate = CLLocationCoordinate2DMake(42.729914, -73.690902)
    annotation.title = "Ace Hardware of Troy"
    mAnnt.append(annotation)
    */
    tmp = location_record()
    tmp.latitude = 42.683429
    tmp.longitude = -73.688409
    tmp.name = "Country True Value Hardware & Rental"
    tmp.street_adr = "217 N Greenbush Rd"
    tmp.city = "Troy"
    tmp.state = "NY"
    tmp.zip = "12180"
    mRecs.append(tmp)
    
    /*
    //let annotation = MKPointAnnotation()
    annotation = ColorPointAnnotation(pinColor: MKPinAnnotationColor.Green)
    annotation.coordinate = CLLocationCoordinate2DMake(tmp.latitude, tmp.longitude)
    annotation.title = tmp.name
    
    mAnnt.append(annotation)
    */
    //St. Timothy Lutheran Church
    tmp = location_record()
    tmp.latitude = 42.679528
    tmp.longitude = -73.681902
    tmp.name = "St. Timothy Lutheran Church"
    tmp.street_adr = "470 Winter St. Extension"
    tmp.city = "Greenbush"
    tmp.state = "NY"
    tmp.zip = "12180"
    pRecs.append(tmp)
    /*
    annotation = ColorPointAnnotation(pinColor: MKPinAnnotationColor.Purple)
    annotation.coordinate = CLLocationCoordinate2DMake(tmp.latitude, tmp.longitude)
    annotation.title = tmp.name
    
    pAnnt.append(annotation)
    */
    */
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // 1
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleMapsApiKey)
        print ("Calling init_location_records")
        init_location_records()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

