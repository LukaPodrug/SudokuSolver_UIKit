//
//  LoadingViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 20.12.2023..
//

import UIKit

class LoadingViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.color = .systemBlue
        indicator.startAnimating()
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupUIFunctionality() {
        isModalInPresentation = true
    
        let sheetPresentationController: UISheetPresentationController = sheetPresentationController!
        sheetPresentationController.detents = [.custom(resolver: { context in
            return 150
        })]
    }
}
