//
//  SearchViewController.swift
//  UberLocationSearch
//
//  Created by Ahmed Abaza on 13/09/2021.
//

import UIKit
import CoreLocation

fileprivate let cellReuseId: String = "locationCell"

class SearchViewController: UIViewController {
    //MARK: -Properties
    private var locations: [Location] = []
    
    public weak var delegate: SearchViewControllerDelegate?
    
    //MARK: -UI Elements
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24.0, weight: .bold)
        lbl.text = "Where to?"
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    private lazy var searchText: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter location..."
        txt.layer.cornerRadius = 10
        txt.backgroundColor = .tertiarySystemBackground
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16.0, height: 50))
        txt.leftViewMode = .always
        txt.delegate = self
        txt.clearButtonMode = .always
        return txt
    }()
    
    private lazy var locationsTableView: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .secondarySystemBackground
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tbl.dataSource = self
        tbl.delegate = self
        return tbl
    }()
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionSubViews()
    }

    
    
    //MARK: -Functions
    private func configureView() -> Void {
        //view config
        self.view.backgroundColor = .secondarySystemBackground
        
        //adding subviews
        self.view.addSubview(titleLabel)
        self.view.addSubview(searchText)
        self.view.addSubview(locationsTableView)
    }
    
    private func positionSubViews() -> Void {
        //base screen coordinates
        let initialXMargin: CGFloat = 16.0
        let initialYMargin: CGFloat = 16.0
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        //title label
        self.titleLabel.sizeToFit()
        let titleWidth: CGFloat = self.titleLabel.frame.size.width
        let titleHeight: CGFloat = self.titleLabel.frame.size.height
        self.titleLabel.frame = CGRect(x: initialXMargin, y: initialYMargin, width: titleWidth, height: titleHeight)
        
        
        //search text
        let searchTextHeight: CGFloat = 52.0
        self.searchText.frame = CGRect(x: initialXMargin,
                                       y: (initialXMargin * 2) + titleHeight,
                                       width: viewWidth - (initialXMargin * 2),
                                       height: searchTextHeight)
        
        
        //table view
        let tableOriginY: CGFloat = self.searchText.frame.origin.y + searchTextHeight
        self.locationsTableView.frame = CGRect(x: 0,
                                               y: tableOriginY,
                                               width: viewWidth,
                                               height: viewHeight - tableOriginY)
        
    }
}

//MARK: -EXT(Search Text Delegate)
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchText.resignFirstResponder()
        if let text = textField.text , !text.isEmpty{
            LocationManger.shared.findLocations(with: text) { [weak self] locationsList in
                DispatchQueue.main.async {
                    self?.locations = locationsList
                    self?.locationsTableView.reloadData()
                }
            }
        }
        return true
    }
}


//MARK: -EXT(Tableview Delegate)
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //notify map controller to show pin at location....
        let coordinates = locations[indexPath.row].flatCoordinates
        delegate?.searchViewController(self, didSelectLocationWith: coordinates)
    }
}


//MARK: -EXT(Tableview DataSource)
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
}



//MARK: -Search Delegate (Protocol)
protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: UIViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D? ) -> Void
}
