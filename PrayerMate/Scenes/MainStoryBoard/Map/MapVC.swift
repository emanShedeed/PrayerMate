//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}
protocol maplLocationView:class {
    func locationIsSeleted(at lat:Double,lng:Double,selectedPlace:String,cityName:String)
}
class MapVC: UIViewController {
    
    var selectedPin: MKPlacemark?
    var selectedPlaceTitle:String?
    var cityName:String?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    weak var delegate:maplLocationView?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        //
        //  let subView = UIView(frame: CGRect(x: 0, y: 64.0, width: 350.0, height: 45.0))
        
        //////
        
        //////
        /* subView.addSubview((resultSearchController.searchBar))
         view.addSubview(subView)
         resultSearchController.searchBar.sizeToFit()
         resultSearchController.hidesNavigationBarDuringPresentation = false*/
        ///
        let searchBar=resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        setupNavBar()
        /////
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            var mark=MKPlacemark(coordinate: newCoordinates)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Complete address as PostalAddress
                // print(placeMark.postalAddress as Any)  //  Import Contacts
                
                // Location name
                if let locationName = placeMark.name  {
                    print(locationName)
                }
                
                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                }
                
                // Country
                if let country = placeMark.country {
                    print(country)
                }
                if let addressDict = placeMark.addressDictionary, let coordinate = placeMark.location?.coordinate {
                    mark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as? [String : Any])
                }
                self.dropPinZoomIn(placemark: mark)
            })
            
        }
        
    }
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

extension MapVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        // print(locations.last?.coordinate.latitude)
        // print(locations.last?.coordinate.longitude)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: \(error)")
    }
    
}

extension MapVC: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        var title=""
        
        
        if let thoroughfare = placemark.thoroughfare {
            title +=  thoroughfare + " , "
        }
        if let city=placemark.locality{
            title += city + " , "
            cityName = city
        }
        if let country = placemark.country{
            title +=  country 
        }
        selectedPlaceTitle = title
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}
extension MapVC{
    
    func setupNavBar(){
        
        // self.navigationItem.leftBarButtonItems = UIBarButtonItem(customView: button)
        //  button.setAttributedTitle(([ NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15 )!], for: .normal), for: .normal)
        let button = UIButton.init(type: .custom)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
        imageView.image = UIImage.backwhiteArrow
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(imageView)
        //  buttonView.addSubview(label)
        button.addTarget(self, action:#selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: buttonView)
        barButton.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem = barButton
        ////
        let save = UIBarButtonItem(title: "OK".localized, style: .done, target: self, action:#selector(okBtnPressed))
        save.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        self.navigationItem.rightBarButtonItems = [save]
        save.tintColor=UIColor.white
        
    }
    @objc func okBtnPressed(){
        delegate?.locationIsSeleted(at: selectedPin?.coordinate.latitude ?? 0.0, lng: selectedPin?.coordinate.longitude ?? 0.0,selectedPlace:selectedPlaceTitle ?? "",cityName:cityName ?? "")
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func backButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
