//
//  ViewController.swift
//  pro
//
//  Created by Sureckaa on 13/05/2020.
//  Copyright © 2020 Sureckaa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var getDirections: UIButton!
    @IBOutlet weak var map: MKMapView!

    //Writtin by developer
    var locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    
  override func viewDidLoad() {
          super.viewDidLoad()
          

          textField.delegate = self
          //this is used to find the location of the user
          textField.delegate = self
          //this is used to find the location of the user
          locationManager.delegate = self
          //this is used to make the location found as accurate as possible
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          //this requests authorization from the user to gain the location
          locationManager.requestAlwaysAuthorization()
          locationManager.requestWhenInUseAuthorization()
          //this updates the user's location as they move
          locationManager.startUpdatingLocation()

          //this shows the blue dot where the user is located
          map.delegate = self
          map.showsUserLocation = true
                  
                  
              }
              
              //Writtin by developer
              //When the user taps on the return key, the keyboard disappears
              func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                  textField.resignFirstResponder()
                  
                  return true
              }
              
                //Writtin by developer
              //enables user to search the location once they click on get directions
              @IBAction func getDirectionsTapped(_ sender: Any) {
                  getAddress()
              }
              
              
              //this identifies the location and places a mark on where the user is
              func getAddress() {
                  let geoCoder = CLGeocoder()
                  //using geocoder to get the longitude and latitude of the place requested
                  geoCoder.geocodeAddressString(textField.text!) { (placemarks, error)
                  in
                  //this finds the location and prints the longitude and latitude on the output screen
                  guard let placemarks = placemarks, let location = placemarks.first?.location
                      else {
                      //if no location was found this error message is printed on the output screen
                          print("No location was found")
                          return
                  }
                   
                      //this prints the longitude and latitude on the output screen
                  print(location)
                      self.mapThis(destinationCord: location.coordinate)
                      
              }

          }
              

              // this ensures that the location is updated everytime the user moves
              func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                  print(locations)
                  
              }
              
              //the function identifies the source and destination coordinates of where the user is and is intending to go.
              func mapThis(destinationCord : CLLocationCoordinate2D){
              
              let sourceCoordinate = (locationManager.location?.coordinate)!
              let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
              let destPlaceMark = MKPlacemark(coordinate: destinationCord)
              
                //this stores longitude and latitude of the source and destination
                let sourceItem = MKMapItem(placemark: sourcePlaceMark)
                let destItem = MKMapItem(placemark: destPlaceMark)
                  
                  //this requests the destination to the place required from Apple. It identifies which method of transport they are using and the route is set to go to the destination. It allows for multiple routes
                  let destinationRequest = MKDirections.Request ()
                  destinationRequest.source = sourceItem
                  destinationRequest.destination = destItem
                  destinationRequest.transportType = .automobile
                  destinationRequest.requestsAlternateRoutes = true
                  //adds a pin to the requested location
                  annotation.coordinate =  destinationCord
                  map.addAnnotation(annotation)
                  
                  //this calculates the direction to the destination and if there was no route found, it prints an error.
                  let directions = MKDirections(request: destinationRequest)
                  directions.calculate { (response, error) in
                      guard let response = response else {
                          if error != nil {
                              print("something is wrong")
                          }
                          return
                      }
                      
                      //removes the previous direction so when a new location is searched it gives a new directions line
                      self.map.removeOverlays(self.map.overlays)

                      
                      // creates an overlay of the map and makes the line visible on the map.
                      let route = response.routes[0]
                      self.map.addOverlay(route.polyline)
                      self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                  }
                  
              
          }
                  
              //this creates a line between the source address and the destination route. It specifies the colour and the width of the line
              func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                  let render = MKPolylineRenderer(overlay: overlay)
                  render.strokeColor = UIColor.blue
                  render.lineWidth = 4.0
                  
                  return render
              }
    
}




