//
//  ViewController.swift
//  UberLocationSearch
//
//  Created by Ahmed Abaza on 29/08/2021.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: -UI Elements
    private let mapView = MKMapView()
    private lazy var floatingPanel: FloatingPanelController = {
        let searchController = SearchViewController()
        let panel = FloatingPanelController()
        searchController.delegate = self
        panel.set(contentViewController: searchController)
        return panel
    }()
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionSubviews()
    }

    
    //MARK: -Fucntions
    private func configureView() -> Void {
        //view configs
        self.title = "Uber"
        
        //adding subviews
        self.view.addSubview(mapView)
        self.floatingPanel.addPanel(toParent: self)
    }
    
    
    private func positionSubviews() -> Void {
        self.mapView.frame = self.view.bounds
    }
}


//MARK: -EXT(SearchViewController Delegate)
extension ViewController: SearchViewControllerDelegate {
    func searchViewController(_ vc: UIViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {return}
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        self.floatingPanel.move(to: .tip, animated: true)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(pin)
        self.mapView.setRegion(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.8,
                    longitudeDelta: 0.9
                )
            ),
            animated: true
        )
        
        
    }
    
    
}
