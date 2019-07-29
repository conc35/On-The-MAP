//
//  TableViewController.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-28.
//  Copyright © 2019 Wael. All rights reserved.
//

import Foundation
import UIKit


class TableViewController: UITableViewController {
    
    // MARK: - Properties
    let cellIdentifier = "DataCell"
    var location: [StudentLocation]!{
        return Global.shared.Studentlocations}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    @IBAction func Refresh(_ sender: Any) {
        APIudacity.getAllLocations  { (Locations, error) in if error != nil {
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location?.count ?? 0
    }

    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier , for: indexPath)
    cell.imageView?.image = UIImage(named:"icon_pin")
    cell.textLabel?.text = location[indexPath.row].firstName
    cell.detailTextLabel?.text = location[indexPath.row].mediaURL
    
    return cell
    }
    
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locations = location[(indexPath).row]
   
       guard let mediaURL = locations.mediaURL, let url = URL(string: mediaURL) else {
        alert(title: "Ops!", message: "Not a valid URL")
        return
    }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }


 
 

}
