//
//  AppleMapsViewController.swift
//  AppleMapView
//
//  Created by Mickey Goga on 3/25/18.
//  Copyright © 2018 Magy Elias. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class AppleMapsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapPoint()
        
        let sourceLocation = CLLocationCoordinate2DMake(30.111381, 31.345810)
        let destinationLocation = CLLocationCoordinate2DMake(30.118200, 31.348874)
        let sourcePin = CustomPin(pinTitle: "El Hegaz Square", pinSubTitle: "", location: sourceLocation)
        let destinationPin = CustomPin(pinTitle: "IoTBlue", pinSubTitle: "", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("We have error getting directions")
                }
                return
            }
            
            let route = directionResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        self.mapView.delegate = self
    }
    
//    func mapPoint() {
//        let location = CLLocationCoordinate2DMake(30.118200, 31.348874)
//        let span = MKCoordinateSpanMake(0.002, 0.002)
//        let region = MKCoordinateRegionMake(location,span)
//        mapView.setRegion(region, animated: true)
//        mapView.mapType = .satellite
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "IoTBlue"
//        mapView.addAnnotation(annotation)
//    }

    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

