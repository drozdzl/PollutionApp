//
//  StationSelectionViewController.swift
//  PollutionApp
//
//  Created by Łukasz Drożdż on 01.08.2018.
//  Copyright (c) 2018 Łukasz Drożdż. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StationSelectionDisplayLogic: class
{
  func displaySomething(viewModel: StationSelection.Something.ViewModel)
  func presentStationsForCity()
}

protocol StationSelectionDelegate: class {
  func didSelectStation(_ station: Station)
}

class StationSelectionViewController: UIViewController, StationSelectionDisplayLogic
{
  //MARK: Outlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var alertView: UIView!
  
  //MARK: Properties
  
  var interactor: StationSelectionBusinessLogic?
  var router: (NSObjectProtocol & StationSelectionRoutingLogic & StationSelectionDataPassing)?
  
  weak var delegate: StationSelectionDelegate?
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = StationSelectionInteractor()
    let presenter = StationSelectionPresenter()
    let router = StationSelectionRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    registerNib()
    doSomething()
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.rowHeight = 44
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    setUpHeight(self.view.frame.height)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animateAlertView()
  }
  

  // MARK: Do something
  
  @IBAction func screenTapped(_ sender: Any) {
    animateOnDismiss()
  }
  
  func doSomething()
  {
    let request = StationSelection.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func presentStationsForCity() {
   
    tableView.reloadData()
  }
  
  // MARK: View Customization
  
  func animateAlertView() {
    
    alertView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
    self.view.alpha = 0
    alertView.isHidden = false
    
    UIView.animate(withDuration: 0.5, animations: {
      self.alertView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
      self.view.alpha = 1
    })
  }
  
  func animateOnDismiss(withStation station: Station? = nil) {
    UIView.animate(withDuration: 0.5, animations: {
      
      self.view.alpha = 0
      self.alertView.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
    }, completion: { (value: Bool) in
      self.dismiss(animated: true, completion: {
        if let station = station {
          self.delegate?.didSelectStation(station)
        }
      })
    })
  }
  
  func displaySomething(viewModel: StationSelection.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}

extension StationSelectionViewController {
  
  fileprivate func setUpHeight(_ screenHeight: CGFloat) {
    
    var height: CGFloat
    guard let stations = router?.dataStore?.stations else {
      height = 100
      tableViewHeight.constant = height
      return
    }
    height = CGFloat(stations.count*44)
    let screenHeight = screenHeight * 0.8
    if height > screenHeight {
      height = screenHeight
    }
    tableViewHeight.constant = height
    alertView.layer.cornerRadius = 20
   
  }

}

extension StationSelectionViewController: UITableViewDelegate, UITableViewDataSource {
  
  fileprivate func registerNib() {
    tableView.register(UINib(nibName: StationSelectionTableViewCell.CellIdentifier, bundle: nil), forCellReuseIdentifier: StationSelectionTableViewCell.CellIdentifier)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let stations = router?.dataStore?.stations else {
      return 0
    }
    return stations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let stations = router?.dataStore?.stations else {
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: StationSelectionTableViewCell.CellIdentifier, for: indexPath) as! StationSelectionTableViewCell
    cell.station = stations[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let stations = router?.dataStore?.stations else {
      return
    }
    let station = stations[indexPath.row]
    animateOnDismiss(withStation: station)
  }
}