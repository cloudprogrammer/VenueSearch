//
//  Annotation.swift
//  Venue Search
//
//  Created by Mudasar Javed on 15/1/18.
//  Copyright © 2018 RA1N ENTERTAINMENT. All rights reserved.
//

import MapKit

class Annotation: NSObject, MKAnnotation {
    
    //Annotation variables
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    //Initialize annotation
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
