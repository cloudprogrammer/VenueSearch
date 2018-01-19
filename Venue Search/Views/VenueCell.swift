//
//  VenueCell.swift
//  Venue Search
//
//  Created by Mudasar Javed on 15/1/18.
//  Copyright © 2018 RA1N ENTERTAINMENT. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
    
    // Create cell labels
    let titleLabel: UILabel = {
        let attributes = UILabel()
        attributes.translatesAutoresizingMaskIntoConstraints = false
        attributes.textColor = UIColor.black
        return attributes
    }()
    
    let addressLabel: UILabel = {
        let attributes = UILabel()
        attributes.translatesAutoresizingMaskIntoConstraints = false
        attributes.textColor = UIColor.black
        return attributes
    }()
    
    let distanceLabel: UILabel = {
        let attributes = UILabel()
        attributes.translatesAutoresizingMaskIntoConstraints = false
        attributes.textColor = UIColor.black
        return attributes
    }()
    
    // Initialize cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(addressLabel)
        self.addSubview(distanceLabel)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up constraints
    func setUpViews() {
        addressLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        addressLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -5).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5).isActive = true
    }
    
}
