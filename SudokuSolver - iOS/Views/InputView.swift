//
//  InputButtonsView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

class InputButtonsView: UIView {
    let inputViewModel: InputViewModel
    
    private let manualInputButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Manual", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let galleryInputButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Gallery", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let cameraInputButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Camera", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init() {
        inputViewModel = InputViewModel()
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setupUI()
        setupUIFunctionality()
        
        super.draw(rect)
    }
    
    func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        addSubview(manualInputButton)
        
        manualInputButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
            make.height.equalTo(45)
        }
        
        addSubview(galleryInputButton)
        
        galleryInputButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(manualInputButton)
            make.leading.equalTo(manualInputButton.snp.trailing).offset(10)
            make.width.equalTo(manualInputButton)
            make.height.equalTo(manualInputButton)
        }
        
        addSubview(cameraInputButton)
        
        cameraInputButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(galleryInputButton)
            make.leading.equalTo(galleryInputButton.snp.trailing).offset(10)
            make.width.equalTo(galleryInputButton)
            make.height.equalTo(galleryInputButton)
        }
    }
    
    func setupUIFunctionality() {
        manualInputButton.addTarget(self, action: #selector(showManualInputModal(sender:)), for: .touchUpInside)
        galleryInputButton.addTarget(self, action: #selector(showGalleryInputModal(sender:)), for: .touchUpInside)
        cameraInputButton.addTarget(self, action: #selector(showCameraInputModal(sender:)), for: .touchUpInside)
    }
}

extension InputButtonsView {
    @objc func showManualInputModal(sender: UIButton) {
        sender.onButtonPressAnimation()
        inputViewModel.showManualInput()
    }
    
    @objc func showGalleryInputModal(sender: UIButton) {
        sender.onButtonPressAnimation()
        inputViewModel.showGalleryInput()
    }
    
    @objc func showCameraInputModal(sender: UIButton) {
        sender.onButtonPressAnimation()
        inputViewModel.showCameraInput()
    }
}
