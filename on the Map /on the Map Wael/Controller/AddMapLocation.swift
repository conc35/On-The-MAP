//
//  AddMapLocation.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-07-03.
//  Copyright © 2019 Wael. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import MapKit

class AddMapLocation: UIViewController, UITextFieldDelegate  {

// Identifications
        var Location: String!
        var locationCoordinates: CLLocationCoordinate2D!
        var annotation = MKPointAnnotation()

    @IBOutlet weak var linkSahre: UITextField!
        
    @IBOutlet weak var Maplocation: MKMapView!
    

    
// View Didload
    override func viewDidLoad() {
            super.viewDidLoad()
    linkSahre.addTarget(self, action: #selector(linkDidChange(_:)), for: .allEditingEvents)
            Maplocation.addAnnotation(annotation)
            updateAnnotation()
        }
    
    @IBAction func submit(_ sender: Any) {
        APIudacity.PostingLocations (link: linkSahre.text ?? "", locationCoordinate: locationCoordinates, locationName: Location) { (errorMessage) in
            if let errorMessage = errorMessage {
                self.alert(title: "Error", message: errorMessage as? String)
                return
            }

        }
    }

// Pin Location
    var PinLocation: MKCoordinateRegion {
        return MKCoordinateRegion(center: locationCoordinates!, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
    
// Link did Change
        @objc func linkDidChange(_ textField: UITextField) {
            updateAnnotation()
        }
        
        func updateAnnotation() {
            annotation.coordinate = locationCoordinates!
            annotation.title = Global.shared.FirstName + " " + Global.shared.LastName
            annotation.subtitle = linkSahre.text ?? ""
            
            Maplocation.setRegion(PinLocation, animated: true)
            
            let isSelected = Maplocation.selectedAnnotations.contains { $0 === self.annotation }
            if !isSelected {
                Maplocation.selectAnnotation(annotation, animated: true)
            }
        }
        
        // MARK: UITextFieldDelegate
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

// Extention

    extension AddMapLocation : MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pinId"
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
 }

