//
//  File.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-28.
//  Copyright © 2019 Wael. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostLocationVC : UIViewController, UITextFieldDelegate {

//Identifications
    var locationName: String!
    var locationCoordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Activityindicator: UIActivityIndicatorView!
    
    @IBOutlet weak var EnteryourLocation: UILabel!
    
    @IBOutlet weak var FindlocationButton: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindLocation" {
            let vc = segue.destination as! AddMapLocation
            vc.locationCoordinates = locationCoordinates
            vc.Location = locationName
        }
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FindLocation(_ sender: Any) {
        updateUI(processing: true)
        guard let locationName = Location.text?.trimmingCharacters(in: .whitespaces),!locationName.isEmpty
            else {
                updateUI(processing: false)
                alert(title: "Warning", message: "Location Field is empaty")
                return
        }
//   getCoordinateFrom

        GetCoordination(location: locationName) { (locationCoordinate, error) in
            if let error = error {
                self.updateUI(processing: false)
                self.alert(title: "Error", message: "Try anohter city name ")
                print(error.localizedDescription)
                return
            }
            self.locationCoordinates = locationCoordinate
            self.locationName = locationName
            self.updateUI(processing: false)
            self.performSegue(withIdentifier: "FindLocation", sender: self)
        }

}
    func GetCoordination(location: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
        
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
 // Activity Indecator
    func updateUI(processing: Bool) {
        DispatchQueue.main.async {
            if processing {
                self.Activityindicator.isHidden = !processing
                self.FindlocationButton.setTitle("", for: .normal)
            } else{
                self.FindlocationButton.setTitle("Find", for: .normal)
            }
            self.Location.isUserInteractionEnabled = !processing
            self.FindlocationButton.isEnabled = !processing
        }
    }
    
    
    
    
    
}
        

    
    
    
    


