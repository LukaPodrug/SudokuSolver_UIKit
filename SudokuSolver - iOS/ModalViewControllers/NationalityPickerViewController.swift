//
//  NationalityPickerViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 12.12.2023..
//

import UIKit

class NationalityPickerViewController: UIViewController {
    let nationalityPickerViewModel: NationalityPickerViewModel
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Pick nationality"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let nationalityPicker: UIPickerView = {
        let picker = UIPickerView()
                
        return picker
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(startRow: Int) {
        nationalityPickerViewModel = NationalityPickerViewModel(startRow: startRow)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNationalityPicker()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(backButton.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(backButton.snp.height)
        }
        
        view.addSubview(nationalityPicker)
        
        nationalityPicker.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(220)
        }
        
        view.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(nationalityPicker.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20).dividedBy(2)
            make.height.equalTo(35)
        }
        
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(nationalityPicker.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20).dividedBy(2)
            make.height.equalTo(35)
        }
    }
    
    func setupUIFunctionality() {
        nationalityPickerViewModel.nationalityPickerViewModelDelegate = self
        
        isModalInPresentation = true
        
        let sheetPresentationController: UISheetPresentationController = sheetPresentationController!
        sheetPresentationController.detents = [.custom(resolver: { context in
            return 350
        })]
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
    }
    
    func setupNationalityPicker() {
        nationalityPicker.delegate = self
        nationalityPicker.dataSource = self
        nationalityPicker.reloadAllComponents()
        nationalityPickerViewModel.setup()
    }
}

extension NationalityPickerViewController {
    @objc func backButtonPressed() {
        hideModal(completion: nil)
    }
    
    @objc func deleteButtonPressed() {
        nationalityPickerViewModel.deleteNationality()
    }
    
    @objc func confirmButtonPressed() {
        nationalityPickerViewModel.selectNationality(selectedRow: nationalityPicker.selectedRow(inComponent: 0))
    }
}

extension NationalityPickerViewController: NationalityPickerViewModelDelegate {
    func updateStartRow(startRow: Int) {
        nationalityPicker.selectRow(startRow, inComponent: 0, animated: false)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}

extension NationalityPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nationalityPickerViewModel.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nationalityPickerViewModel.countries[row]
    }
}
