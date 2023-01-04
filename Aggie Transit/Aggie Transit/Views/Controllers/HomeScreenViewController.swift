//
//  HomeScreenViewController2.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/25/22.
//

import Foundation
import UIKit
import MapKit

class HomeScreenViewController: UIViewController {
    private var safeAreaHeight:Double?
    private var height: Double?
    private var width: Double?
    private var buttonSpacing = 0.0
    private var fabHeight: Double?
    private var fabWidth: Double?
    private var map: MKMapView?
    private var region: MKCoordinateRegion?
    private var superViewMargins: UILayoutGuide?
    private var homeScreenNotificationsFAB: HomeScreenFAB?
    private var homeScreenSettingsFAB: HomeScreenFAB?
    private var buttonStack: UIStackView?
    private var mapMargins: UILayoutGuide?
    private var homeScreenMenu: HomeScreenMenuView?
    private var homeScreenMenuHeight: Double?
    private var homeScreenMenuWidth: Double?
    private var animationDuration:TimeInterval = 0.5
    private var navigationBar: UINavigationBar?
    private var currentlyDisplayedPattern: MKPolyline?
    private var currentlyDisplayedStops: [MKAnnotation]?
    private var currentlyDisplayedColor: UIColor?
    private var currentlyDisplayedBuses: [BusAnnotation]?
    private var currentlyDisplayedLocation: MKAnnotation?
    private var longitudeDelta: Double?
    private var latitudeDelta: Double?
    public var menuCollapsed: Bool?
    private var keyboardDisplayed: Bool?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
        registerKeyboardNotification()
        registerCollapseNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        // hide the navigation bar
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // show the navigation bar
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
        super.viewWillDisappear(animated)
    }
    //MARK: - Register the keyboard notification
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardIsDisplayedOnScreen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editingDidBegin), name: Notification.Name("didBeginEditing"), object: nil)
    }
    //MARK: - Register collapse notification
    func registerCollapseNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissMenu), name: Notification.Name(rawValue: "collapseMenu"), object: nil)
    }
    //MARK: - layout subviews of main view
    func layoutSubviews() {
        // configure navigation bar
        if let navigationBar = navigationController?.navigationBar, let _ = navigationController {
            navigationBar.barTintColor = UIColor(named: "textColor")
            navigationBar.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
            navigationBar.prefersLargeTitles = true
        }
        // decide the height and width of items based on view size
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        if let safeAreaHeight = safeAreaHeight{
            height = self.view.frame.height - safeAreaHeight
            width = self.view.frame.width
            if let height = height, let width = width{
                buttonSpacing = 7.15 * (height/812)
                
                // configure super view backbround
                self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                // configure the map
                map = MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                longitudeDelta = 0.0125
                latitudeDelta = 0.0125
                if let latitudeDelta = latitudeDelta, let longitudeDelta = longitudeDelta {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
                    if let map = map, let region = region{
                        // configure the map
                        map.delegate = self
                        map.translatesAutoresizingMaskIntoConstraints = false
                        map.setRegion(region, animated: false)
                        map.showsCompass = false
                        // add the map to the view hierarchy
                        self.view.addSubview(map)
                        // constrain the map
                        superViewMargins = self.view.safeAreaLayoutGuide
                        if let superViewMargins = superViewMargins {
                            map.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
                            map.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
                            map.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
                            map.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
                        }
                        
                        // configure the buttons
                        buttonStack = UIStackView()
                        if let buttonStack = buttonStack{
                            fabHeight = 40 * (height/812)
                            fabWidth = fabHeight
                            if let fabHeight = fabHeight, let fabWidth  = fabWidth{
                                // configure settings button
                                homeScreenSettingsFAB = HomeScreenFAB(frame:  CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .settings, buttonName: .settings)
                                if let homeScreenSettingsFAB = homeScreenSettingsFAB{
                                    homeScreenSettingsFAB.translatesAutoresizingMaskIntoConstraints = false
                                    // constrain settings button
                                    homeScreenSettingsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
                                    homeScreenSettingsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
                                }
                                // configure notifications button
                                homeScreenNotificationsFAB = HomeScreenFAB(frame: CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .notifications, buttonName: .notifications)
                                if let homeScreenNotificationsFAB = homeScreenNotificationsFAB, let homeScreenSettingsFAB = homeScreenSettingsFAB{
                                    homeScreenNotificationsFAB.translatesAutoresizingMaskIntoConstraints = false
                                    // constrain the notifications button
                                    homeScreenNotificationsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
                                    homeScreenNotificationsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
                                    // add event handlers to the buttons
                                    homeScreenSettingsFAB.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
                                    homeScreenNotificationsFAB.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
                                    // add the buttons to a stackview
                                    buttonStack.addArrangedSubview(homeScreenNotificationsFAB)
                                    buttonStack.addArrangedSubview(homeScreenSettingsFAB)
                                }
                            }
                            // configure the stackview
                            buttonStack.axis = .vertical
                            buttonStack.spacing = buttonSpacing
                            buttonStack.alignment = .center
                            buttonStack.translatesAutoresizingMaskIntoConstraints = false
                            // add the button stack to the view hierarchy
                            map.addSubview(buttonStack)
                            // constrain the button stack
                            mapMargins = map.safeAreaLayoutGuide
                            if let mapMargins = mapMargins{
                                buttonStack.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor, constant: -10).isActive = true
                                buttonStack.topAnchor.constraint(equalTo: mapMargins.topAnchor,constant: 10).isActive = true
                            }
                        }
                        // configure home screen menu view
                        homeScreenMenuHeight = (812/3) * (height/812)
                        homeScreenMenuWidth = width
                        if let homeScreenMenuWidth = homeScreenMenuWidth, let homeScreenMenuHeight = homeScreenMenuHeight{
                            homeScreenMenu = HomeScreenMenuView(frame: CGRect(x: 0, y: 0, width: homeScreenMenuWidth, height: homeScreenMenuHeight))
                            if let homeScreenMenu = homeScreenMenu {
                                menuCollapsed = false
                                homeScreenMenu.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                homeScreenMenu.translatesAutoresizingMaskIntoConstraints = false
                                homeScreenMenu.pathDelegate = self
                                homeScreenMenu.locationIdentifierDelegate = self
                                let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(homeScreenMenuSwiped))
                                downSwipeGesture.direction = .down
                                downSwipeGesture.delegate = self
                                let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(homeScreenMenuSwiped))
                                upSwipeGesture.direction = .up
                                upSwipeGesture.delegate = self
                                homeScreenMenu.addGestureRecognizer(downSwipeGesture)
                                homeScreenMenu.addGestureRecognizer(upSwipeGesture)
                                homeScreenMenu.map = map
                                // add the home screen menu to the view hierarchy
                                map.addSubview(homeScreenMenu)
                                // constrain the home screen menu
                                if let mapMargins = mapMargins {
                                    homeScreenMenu.leadingAnchor.constraint(equalTo: mapMargins.leadingAnchor).isActive = true
                                    homeScreenMenu.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor).isActive = true
                                    homeScreenMenu.bottomAnchor.constraint(equalTo: mapMargins.bottomAnchor).isActive = true
                                    homeScreenMenu.heightAnchor.constraint(equalToConstant: homeScreenMenuHeight).isActive = true
                                }
                                
                            }
                        }
                        
                    }
                }
            }
           
           
        }
        
    }
}
//MARK: - top right buttons pressed
extension HomeScreenViewController{
    @objc func handleButtonPress(sender: HomeScreenFAB) {
        if sender.buttonName.rawValue == "Settings Button"{
            presentSettingsScreen()
        }
        
        else if sender.buttonName.rawValue == "Notifications Button" {
            presentNotificationsScreen()
        }
        else {
            print("An error has occured")
        }
    }
    func presentSettingsScreen() {
        if let navigationController = navigationController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsScreenViewController") as! SettingsScreenViewController
            navigationController.pushViewController(settingsViewController, animated: true)
        }
    }
    func presentNotificationsScreen() {
        if let navigationController = navigationController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let notificationsViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsScreenViewController") as! NotificationsScreenViewController
            navigationController.pushViewController(notificationsViewController, animated: true)
        }
    }
}
//MARK: - handle the map and creating patterns and points

extension HomeScreenViewController: PathMakerDelegate, MKMapViewDelegate{
    // this dispalys the route on the current map
    func displayBusRoutePatternOnMap(color: UIColor, points: [BusPattern]) {
        var wayPoints: [CLLocationCoordinate2D] = []
        for point in points {
            wayPoints.append(point.location)
        }
        if let map = map, let homeScreenMenuHeight = homeScreenMenuHeight {
            if let currentlyDisplayedPattern = currentlyDisplayedPattern, let _ = currentlyDisplayedColor {
                DispatchQueue.main.async {
                    map.removeOverlay(currentlyDisplayedPattern)
                }
                let boundedLine = MKPolyline(coordinates: wayPoints, count: points.count)
                self.currentlyDisplayedColor = color
                self.currentlyDisplayedPattern = boundedLine
                DispatchQueue.main.async {
                    map.addOverlay(boundedLine)
                    // change the region of the map based on currently displayed bus route
                    map.visibleMapRect = map.mapRectThatFits(boundedLine.boundingMapRect, edgePadding: UIEdgeInsets(top: homeScreenMenuHeight * 0.33, left: 10, bottom: homeScreenMenuHeight * 0.33, right: 10))
                }
            }
            else {
                let boundedLine = MKPolyline(coordinates: wayPoints, count: points.count)
                self.currentlyDisplayedPattern = boundedLine
                self.currentlyDisplayedColor = color
                DispatchQueue.main.async {
                    map.addOverlay(boundedLine)
                    // change the region of the map based on currently displayed bus route
                    map.visibleMapRect = map.mapRectThatFits(boundedLine.boundingMapRect, edgePadding: UIEdgeInsets(top: homeScreenMenuHeight * 0.33, left: 10, bottom: homeScreenMenuHeight * 0.33, right: 10))
                }
            }
        }
    }
    // this returns an appropriate renderer for overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            if let _ = currentlyDisplayedPattern, let color = currentlyDisplayedColor {
                let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
                renderer.lineWidth = 5
                renderer.strokeColor = color
                renderer.alpha = 1.0
                return renderer
            }
        }
        fatalError("Overlay is of the wrong type")
    }
    // this displays the stops on the current map
    func displayBusRouteStopsOnMap(color: UIColor, stops: [BusStop]) {
        if let map = map {
            if let currentlyDisplayedStops = currentlyDisplayedStops, let _ = currentlyDisplayedColor {
                DispatchQueue.main.async {
                    map.removeAnnotations(currentlyDisplayedStops)
                }
                var stopAnnotations: [MKAnnotation] = []
                for stop in stops {
                    let stopAnnotation = MKPointAnnotation()
                    stopAnnotation.coordinate = stop.location
                    stopAnnotation.title = stop.name
                    stopAnnotation.title = stop.name
                    stopAnnotation.subtitle = stop.isTimePoint ? "Time Point":"Waypoint"
                    stopAnnotations.append(stopAnnotation)
                }
                self.currentlyDisplayedStops = stopAnnotations
                self.currentlyDisplayedColor = color
                DispatchQueue.main.async {
                    map.addAnnotations(stopAnnotations)
                }
            }
            else {
                var stopAnnotations: [MKAnnotation] = []
                for stop in stops {
                    let stopAnnotation = MKPointAnnotation()
                    stopAnnotation.coordinate = stop.location
                    stopAnnotation.title = stop.name
                    stopAnnotation.subtitle = stop.isTimePoint ? "Time Point":"Waypoint"
                    stopAnnotations.append(stopAnnotation)
                }
                self.currentlyDisplayedStops = stopAnnotations
                self.currentlyDisplayedColor = color
                DispatchQueue.main.async {
                    map.addAnnotations(stopAnnotations)
                }
            }
        }
    }
    // this provides the annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: BusAnnotation.self), let annotation = annotation as? BusAnnotation, let direction = annotation.direction {
            let view = MKAnnotationView()
            view.image = UIImage(named: "bus")?.rotate(radians: rad(direction))
            view.canShowCallout = true
            return view
        }
        else if annotation.isKind(of: LocationAnnotation.self){
            let view = MKMarkerAnnotationView()
            view.canShowCallout = true
            return view
        }
        else if annotation.isKind(of: MKPointAnnotation.self) {
            if let currentlyDisplayedColor = currentlyDisplayedColor {
                let view = MKPinAnnotationView()
                view.canShowCallout = true
                view.pinTintColor = annotation.subtitle == "Waypoint" ? currentlyDisplayedColor:currentlyDisplayedColor.inverseColor()
                return view
            }
        }
        fatalError("Annotation is of the wrong kind")
    }
    // this displays the buses on the map
    func displayBusesOnMap(buses: [Bus]) {
        if let map = map {
            if let currentlyDisplayedBuses = currentlyDisplayedBuses, let _ = currentlyDisplayedColor {
                DispatchQueue.main.async {
                    map.removeAnnotations(currentlyDisplayedBuses)
                }
                var busAnnotations:[BusAnnotation] = []
                for bus in buses {
                    let busAnnotation = BusAnnotation()
                    busAnnotation.coordinate = bus.location
                    busAnnotation.direction = bus.direction
                    busAnnotation.title = "Route - \(bus.name)"
                    busAnnotation.subtitle = "next stop - \(bus.nextStop)"
                    busAnnotations.append(busAnnotation)
                }
                self.currentlyDisplayedBuses = busAnnotations
                DispatchQueue.main.async {
                    map.addAnnotations(busAnnotations)
                }
            } else {
                var busAnnotations:[BusAnnotation] = []
                for bus in buses {
                    let busAnnotation = BusAnnotation()
                    busAnnotation.coordinate = bus.location
                    busAnnotation.direction = bus.direction
                    busAnnotation.title = "Route - \(bus.name)"
                    busAnnotation.subtitle = "next stop - \(bus.nextStop)"
                    busAnnotations.append(busAnnotation)
                }
                self.currentlyDisplayedBuses = busAnnotations
                DispatchQueue.main.async {
                    map.addAnnotations(busAnnotations)
                }
            }
        }
    }
  
}
//MARK: - handle home screen menu gestures

extension HomeScreenViewController: UIGestureRecognizerDelegate {
    @objc func homeScreenMenuSwiped(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            self.presentMenu()
        }
        else if sender.direction == .down {
            self.dismissMenu()
        }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let keyboardDisplayed = keyboardDisplayed {
            return !keyboardDisplayed
        }
        return true
    }
}
//MARK: - Create methods to dismiss and present the menu

extension HomeScreenViewController {
    @objc func dismissMenu(){
        if let homeScreenMenu = homeScreenMenu, let menuCollapsed = menuCollapsed, let homeScreenMenuHeight = homeScreenMenuHeight{
            if !menuCollapsed {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                        homeScreenMenu.frame.origin.y += homeScreenMenuHeight/1.33
                    } completion: { _ in
                        self.menuCollapsed = true
                    }
                }
            }
        }
    }
    @objc func presentMenu(){
        if let homeScreenMenu = homeScreenMenu, let menuCollapsed = menuCollapsed, let homeScreenMenuHeight = homeScreenMenuHeight {
            if menuCollapsed {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
                        homeScreenMenu.frame.origin.y -= homeScreenMenuHeight/1.33
                        NotificationCenter.default.post(Notification(name: Notification.Name("invalidateTimer")))
                        self.clearBusRoutePatternFromMap()
                        self.clearBusRouteStopsFromMap()
                        self.clearBusesFromMap()
                        self.clearDisplayedLocationFromMap()
                    }completion: { _ in
                        self.menuCollapsed = false
                    }
                }
            }
        }
    }
}
//MARK: - Allow a way to deselect bus route
extension HomeScreenViewController {
    // this function cleans the map and sets it to the default region
    func clearBusRoutePatternFromMap(){
        if let map = map, let _ = currentlyDisplayedColor, let currentlyDisplayedPattern = currentlyDisplayedPattern , let region = region{
            DispatchQueue.main.async {
                map.removeOverlay(currentlyDisplayedPattern)
                map.setRegion(region, animated: true)
                self.currentlyDisplayedColor = nil
                self.currentlyDisplayedPattern = nil
            }
        }
    }
    // this function cleans the bus stops from the map
    func clearBusRouteStopsFromMap() {
        if let map = map, let currentlyDisplayedStops = currentlyDisplayedStops, let region = region {
            DispatchQueue.main.async {
                map.removeAnnotations(currentlyDisplayedStops)
                map.setRegion(region, animated: true)
                self.currentlyDisplayedStops = nil
                self.currentlyDisplayedColor = nil
            }
        }
    }
    // this function cleans the buses from the map
    func clearBusesFromMap(){
        if let map = map, let currentlyDisplayedBuses = currentlyDisplayedBuses, let region = region {
            DispatchQueue.main.async {
                map.removeAnnotations(currentlyDisplayedBuses)
                map.setRegion(region, animated: true)
                self.currentlyDisplayedBuses = nil
                self.currentlyDisplayedColor = nil
            }
        }
    }
    // this function removes the currently displayed location from the map
    func clearDisplayedLocationFromMap(){
        if let map = map, let currentlyDisplayedLocation = currentlyDisplayedLocation, let region = region {
            DispatchQueue.main.async {
                map.removeAnnotation(currentlyDisplayedLocation)
                map.setRegion(region, animated: true)
                self.currentlyDisplayedLocation = nil
            }
        }
    }
}
//MARK: - Handle Keyboard popping up on screen

extension HomeScreenViewController {
    @objc func keyboardIsDisplayedOnScreen(){
        keyboardDisplayed = true
        if let homeScreenMenu = homeScreenMenu, let homeScreenMenuHeight = homeScreenMenuHeight {
            DispatchQueue.main.async{
                UIView.animate(withDuration: 0.25, delay: 0) {
                        homeScreenMenu.frame.origin.y -= homeScreenMenuHeight
                }
            }
        }
    }
}

//MARK: - Handle Keyboard disappearing from screen
extension HomeScreenViewController {
    @objc func keyboardDidDisappear() {
        keyboardDisplayed = false
        if let homeScreenMenu = homeScreenMenu, let homeScreenMenuHeight = homeScreenMenuHeight {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0, delay: 0) {
                        homeScreenMenu.frame.origin.y += homeScreenMenuHeight
                }
            }
        }
    }
}
//MARK: - Handle editing did begin
extension HomeScreenViewController {
    @objc func editingDidBegin() {
        if let menuCollapsed = menuCollapsed {
            if menuCollapsed {
                self.presentMenu()
            }
        }
        
    }
}
//MARK: - Handle showing search location
extension HomeScreenViewController: LocationIdentifierDelegate {
    func showLocationOnMap(location: CLLocationCoordinate2D, name: String, address: String) {
        if let map = map {
            if let currentlyDisplayedLocation = currentlyDisplayedLocation {
                DispatchQueue.main.async {
                    map.removeAnnotation(currentlyDisplayedLocation)
                }
                let locationAnnotation = LocationAnnotation()
                locationAnnotation.coordinate = location
                locationAnnotation.title = name
                locationAnnotation.subtitle = address
                self.currentlyDisplayedLocation = locationAnnotation
                DispatchQueue.main.async {
                    map.addAnnotation(locationAnnotation)
                    map.selectAnnotation(locationAnnotation, animated: true)
                    
                }
            } else {
                let locationAnnotation = LocationAnnotation()
                locationAnnotation.coordinate = location
                locationAnnotation.title = name
                locationAnnotation.subtitle = address
                self.currentlyDisplayedLocation = locationAnnotation
                DispatchQueue.main.async {
                    map.addAnnotation(locationAnnotation)
                    map.selectAnnotation(locationAnnotation, animated: true)
                }
            }
        }
    }
    
    
}
