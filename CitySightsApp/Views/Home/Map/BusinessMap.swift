//
//  BusinessMap.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/28/21.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable{
    
    @EnvironmentObject var model:ContentModel
    
    var locations:[MKPointAnnotation]{
         var annotations = [MKPointAnnotation]()
        
        //create a set of annotations from list of businesses
        for business in model.restaurants + model.sights {
            
            //if the business has a lat/long create an MKPointAnnotation for it
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude{
                
                //create a new annotation
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name ?? ""
                
                annotations.append(a)
            }
            
        }
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        //make the user show up on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //remove all annotations
        uiView.removeAnnotations(uiView.annotations)
        
        
        // add teh ones based on the business
        //uiView.addAnnotations(self.locations)
        uiView.showAnnotations(self.locations, animated: true)
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        
        uiView.removeAnnotations(uiView.annotations)
        
    }
    
}
