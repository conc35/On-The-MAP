//
//  MapVc.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-21.
//  Copyright © 2019 Wael. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
       @IBOutlet weak var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    @IBAction func Refresh(_ sender: Any) {
        APIudacity.getAllLocations { (Locations, error) in if error != nil {
            _ = self.alert(title: "Error", message: "errormessage")
            return}}}
    
    
    @IBAction func Post(_ sender: Any) {
        let postLocationController = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationVC") as! PostLocationVC
        self.present(postLocationController, animated: true, completion: nil)
    }
    
    
    @IBAction func Logout(_ sender: Any) {
        APIudacity.DeleteSession { (errorMessage) in
            if let errorMessage = errorMessage {
                self.alert(title: "Error", message: "errorMessage")
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        APIudacity.getAllLocations  {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation] ()
                
                guard let locationsArray = studentsLocations else {
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                }
                
                for locationStruct in locationsArray {
                    
                    let long = CLLocationDegrees (locationStruct.longitude ?? 0)
                    let lat = CLLocationDegrees (locationStruct.latitude ?? 0)
                    
                    let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    
         
                    let mediaURL = locationStruct.mediaURL ?? " "
                    
      
                    let first = locationStruct.firstName ?? " "
         
                    let last = locationStruct.lastName ?? " "
                    
             
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append (annotation)
                }
                self.MapView.addAnnotations (annotations)
            }
            
        }//end getAllLocations
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
