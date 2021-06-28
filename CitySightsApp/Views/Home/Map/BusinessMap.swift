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
    @Binding var selectedBusiness:Business?
    
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
        mapView.delegate = context.coordinator
        
        
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
    
    //MARK - Coordinatort class
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        
        var map: BusinessMap
        
        init(map: BusinessMap){
            self.map = map
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // if the annotation is he user blue dot, return nil
            if annotation is MKUserLocation{
                return nil
            }
            
            //chek if there's a resusable annotation view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
            
            if annotationView == nil {
                //create an annotation view
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else{
                // we got a resusabel one
                annotationView!.annotation = annotation
            }
            
            
            //return it
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //user tapped on the annotation view
            
            //get the business object that this annotatioin represents
            //loop through businesses in the model and find a match
            for business in map.model.restaurants + map.model.sights{
                if business.name == view.annotation?.title{
                    //set the selectedBusiness property to that business object
                    map.selectedBusiness = business
                    return
                }
            }
            
            
        }
        
    }
    
}
