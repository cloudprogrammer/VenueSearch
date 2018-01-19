//
//  SearchViewController.swift
//  Venue Search
//
//  Created by Mudasar Javed on 15/1/18.
//  Copyright © 2018 RA1N ENTERTAINMENT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol LocationProtocol {
    func setLocation(location: JSON)
}

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    //Search bar
    let searchBar: UISearchBar = {
        let attributes = UISearchBar()
        attributes.placeholder = "Eg. Cafe"
        attributes.translatesAutoresizingMaskIntoConstraints = false
        return attributes
    }()
    
    //Array of near by venues
    var nearbyVenues: [JSON] = []
    
    //Current lat & long (passed from previous view)
    var currentLat = 0.0
    var currentLong = 0.0
    
    //Location protocol
    var locationProtocol: LocationProtocol?
    
    //Set background color
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.white
        layoutConstraints()
    }
    
    //Client_id/Secret
    let clientId = ""
    let clientSecret = ""

    //Called when search button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Dismiss keyboard
        self.searchBar.resignFirstResponder()
        let text = searchBar.text!
        if (text != "") {
            //Call foursquare api using Alamofire
            let string = "https://api.foursquare.com/v2/venues/explore?client_id=\(clientId)&client_secret=\(clientSecret)&ll=\(currentLat),\(currentLong)&query=\(text)&v=20180115&limit=50&radius=2000"
            Alamofire.request(string, method: .get).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    //User SwiftyJSON to get the items array from the response
                    let json = JSON(value)
                    let venues = json["response"]["groups"][0]["items"].arrayValue
                    //Sort items array by distance then set nearbyVenues array to it
                    self.nearbyVenues = venues.sorted(by: { (a, b) -> Bool in
                        return a["venue"]["location"]["distance"].intValue < b["venue"]["location"]["distance"].intValue
                    })
                    //Update tableView
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set searchBar inside navBar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        //Register the tableView cell
        tableView.register(VenueCell.self, forCellReuseIdentifier: "VenueCell")
        tableView.separatorColor = UIColor.black
    }
    
    //Cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //Called when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect the row then set the location using the location protocol and pop back to the previous view controller
        tableView.deselectRow(at: indexPath, animated: true)
        locationProtocol?.setLocation(location: nearbyVenues[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    //Render cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = nearbyVenues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
        cell.titleLabel.text = item["venue"]["name"].string!
        //If address key exists then use it else return "Private Address"
        cell.addressLabel.text = item["venue"]["location"]["address"].exists() ? item["venue"]["location"]["address"].string! : "Private Address"
        cell.distanceLabel.text = "\(item["venue"]["location"]["distance"].intValue)m"
        
        return cell
    }
    
    //Row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyVenues.count
    }
    
    //Constraints layout
    func layoutConstraints() {
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }

}
