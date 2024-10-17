import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let location: Location
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = location.name_store
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                // Add a detail disclosure button to the callout.
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
            } else {
                annotationView?.annotation = annotation
            }
            
            let pinImage = UIImage(systemName: "m.square")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            annotationView?.image = pinImage
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation else { return }
            let lat = annotation.coordinate.latitude
            let lon = annotation.coordinate.longitude
            let mapURL = URL(string: "maps://?q=\(lat),\(lon)")!
            
            UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
        }
    }
}
