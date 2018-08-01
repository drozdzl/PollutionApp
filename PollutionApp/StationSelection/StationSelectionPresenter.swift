//
//  StationSelectionPresenter.swift
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

protocol StationSelectionPresentationLogic
{
  func presentSomething(response: StationSelection.Something.Response)
  func presentStationsForCity()
}

class StationSelectionPresenter: StationSelectionPresentationLogic
{
  weak var viewController: StationSelectionDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: StationSelection.Something.Response)
  {
    let viewModel = StationSelection.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
  func presentStationsForCity() {
    
  }
}