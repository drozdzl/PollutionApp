//
//  ParameterSelectioinPresenter.swift
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

protocol ParameterSelectioinPresentationLogic
{
  func presentSomething(response: ParameterSelectioin.Something.Response)
  func presentParameters()
  func presentError(withDescription description: String)
  func presentStatistiscForParam()
}

class ParameterSelectioinPresenter: ParameterSelectioinPresentationLogic
{
  weak var viewController: ParameterSelectioinDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ParameterSelectioin.Something.Response)
  {
    let viewModel = ParameterSelectioin.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
  
  func presentParameters() {
    viewController?.presentParameters()
  }
  
  func presentError(withDescription description: String) {
    viewController?.presentError(forError: description)
  }
  
  func presentStatistiscForParam() {
    viewController?.presentStatistics()
  }
}
