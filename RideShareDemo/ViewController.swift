//
//  ViewController.swift
//  RideShareDemo
//
//  Created by Varender Singh on 15/05/19.
//  Copyright © 2019 Varender Singh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var startRideBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var coordinatedOfRiderHome = CLLocationCoordinate2D.init();
    var coordinatedOfRiderOffice = CLLocationCoordinate2D.init();
    
    var coordinatedOfSharerHome = CLLocationCoordinate2D.init();
    var coordinatedOfSharerOffice = CLLocationCoordinate2D.init();
    
    var routeForRider:MKRoute? = nil
    var routeForSharer:MKRoute? = nil
    
    
    //MARK:- ************ METHODS *************
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let region = MKCoordinateRegionMakeWithDistance(coordinatedOfRiderHome,  CLLocationDistance(exactly: 5000)!,  CLLocationDistance(exactly: 5000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        var mkAnnotation = MKPointAnnotation.init()
        mkAnnotation.coordinate = coordinatedOfRiderHome
        mkAnnotation.title = "Rider Home"
        self.mapView.addAnnotation(mkAnnotation)
        
        var mkAnnotation2 = MKPointAnnotation.init()
        mkAnnotation2.coordinate = coordinatedOfRiderOffice;
        mkAnnotation2.title = "Rider Office"
        self.mapView.addAnnotation(mkAnnotation2)
        mkAnnotation = MKPointAnnotation.init()
        mkAnnotation.coordinate = coordinatedOfSharerHome
        mkAnnotation.title = "Requester Home"
        self.mapView.addAnnotation(mkAnnotation)
        
        mkAnnotation2 = MKPointAnnotation.init()
        mkAnnotation2.coordinate = coordinatedOfSharerOffice;
        mkAnnotation2.title = "Requester Office"
        self.mapView.addAnnotation(mkAnnotation2)
       
        self.addPathBetweenStartAndEnd(startCoordinates: coordinatedOfRiderHome, endCoordinates: coordinatedOfRiderOffice, rider: true)
        self.addPathBetweenStartAndEnd(startCoordinates: coordinatedOfSharerHome, endCoordinates: coordinatedOfSharerOffice, rider: false)
    }

    
    func addPathBetweenStartAndEnd(startCoordinates:CLLocationCoordinate2D,endCoordinates:CLLocationCoordinate2D,rider:Bool) {
        let mkDirRequest = MKDirectionsRequest.init()
        mkDirRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: startCoordinates))
        mkDirRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: endCoordinates))
        mkDirRequest.transportType = .automobile
        let directions = MKDirections.init(request: mkDirRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                return
            }
            
            let routes = response.routes[0]
            if rider {
                self.routeForRider = routes;
            }
            else{
                  self.routeForSharer = routes;
            }
            self.mapView.add(routes.polyline, level: .aboveRoads)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- ACTIONS
    @IBAction func startRideBtnClicked(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Alert", message: "Do you really want to ride with this rider?", preferredStyle: .alert);
        let alertActionYes = UIAlertAction.init(title: "Yes", style: .default) { (alertAction) in
               self.foundRouteBetweenRiderHomeAndSharerHome()
        };
        let alertActionNo = UIAlertAction.init(title: "No", style: .cancel) { (alertAction) in
             let timeOfRider = "Rider Time To Reach His Office = \(Int.init((self.routeForRider?.expectedTravelTime)!)/60) minutes "
             let distanceOfRider = " Total Distance He Travelled is = \(self.routeForRider?.distance as! Double) meters"
            
            self.showAlertViewWithAlert(message:timeOfRider+distanceOfRider, title: "Rider Alone Trip")
        }
        alertController.addAction(alertActionNo);
        alertController.addAction(alertActionYes);
        self.present(alertController, animated: true, completion: nil);
    }
    
    func foundRouteBetweenRiderHomeAndSharerHome() {  // Rider Home->Sharer Home -> Sharer Office -> Rider Office
        self.findTimeTakenToTravelBetween(startCoordinates: coordinatedOfRiderHome, endCoordinates: coordinatedOfSharerHome) { (timeTook, error,distance) in
            if error != nil {
                self.showAlertViewWithAlert(message: error!, title: "")
            }
            else {
                self.findTimeTakenToTravelBetween(startCoordinates: self.coordinatedOfSharerOffice, endCoordinates: self.coordinatedOfRiderOffice, completionHandler: { (timeTookFromSharerOfficeToRiderOffice, error,distanceFromSharerOfficeToRiderOffice) in
                    if error != nil {
                        self.showAlertViewWithAlert(message: error!, title: "")
                    }
                    else {
                        let newDist = distance!+distanceFromSharerOfficeToRiderOffice!+(self.routeForSharer?.distance)!
                        let newDistanceStr = "Total Distance =\(newDist) meters"
                        let timeFromShareHomeToHisOffice = Int.init((self.routeForSharer?.expectedTravelTime)!/60)
                         let totalTime = "\nTotal Time =\(timeTook!+timeTookFromSharerOfficeToRiderOffice!+timeFromShareHomeToHisOffice) minutes"
                        let extraDistance = "\n Extra Distance travelled = \(newDist-(self.routeForRider?.distance)!)"
                        
                        var messageIfCannotGo = ""
                        if newDist-(self.routeForRider?.distance)!>2000 {
                            messageIfCannotGo = "\n Rider Cannot Come Due to Extra distance > 1 Km"
                        }
                        
                           self.showAlertViewWithAlert(message: newDistanceStr+totalTime+extraDistance+messageIfCannotGo, title: "Round Trip")
                        
                    }
                })
            }
        }
    }
    
    
    func  findTimeTakenToTravelBetween(startCoordinates:CLLocationCoordinate2D,endCoordinates:CLLocationCoordinate2D,completionHandler:@escaping (_ timeTaken:Int?,_ error:String?,_ distanceTravelledInMeters:Double?)->Void) {
        let mkDirRequest = MKDirectionsRequest.init()
        mkDirRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: startCoordinates))
        mkDirRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: endCoordinates))
        mkDirRequest.transportType = .automobile
        let directions = MKDirections.init(request: mkDirRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    completionHandler(nil,error?.localizedDescription,nil)
                }
                return ;
            }
            
            if response.routes.count == 0 {
                completionHandler(nil, "No Route Found",nil)
            }
            else {
                let routes = response.routes[0]
                let timeToReachSharerHouse = Int.init(routes.expectedTravelTime/60);
                completionHandler(timeToReachSharerHouse,nil,routes.distance);
            }
        }
    }
    
    //MARK:- <MKMapViewDelegate>
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        annotationView?.annotation = annotation;
        annotationView?.canShowCallout = true;
        if (annotation.title!?.contains("Requester"))!
        {
             annotationView?.image = UIImage.init(named: "placeholder")
        }
        else {
            annotationView?.image = UIImage.init(named: "RedPin")
        }
        return annotationView;
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer.init(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 1.2;
        return render;
    }
    
    //MARK:- ALERT VIEW
    func showAlertViewWithAlert(message:String,title:String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
         let alertActionOk = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
         alertController.addAction(alertActionOk);
         self.present(alertController, animated: true, completion: nil);
    }
    
}

