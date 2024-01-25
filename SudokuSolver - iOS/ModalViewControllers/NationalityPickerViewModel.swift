//
//  NationalityPickerViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.01.2024..
//

import Foundation

protocol NationalityPickerViewModelParentDelegate: AnyObject {
    func selectNationality(name: String, code: String, row: Int)
    func hideNationalityPickerModal()
}

protocol NationalityPickerViewModelDelegate: AnyObject {
    func updateStartRow(startRow: Int)
    func hideModal(completion: (() -> Void)?)
}

class NationalityPickerViewModel {
    var countries: [String]
    var countryCodes: [String]
    var startRow: Int
    
    weak var nationalityPickerViewModelParentDelegate: NationalityPickerViewModelParentDelegate?
    weak var nationalityPickerViewModelDelegate: NationalityPickerViewModelDelegate?
    
    init(startRow: Int) {
        self.countries = ["None"]
        self.countryCodes = [""]
        self.startRow = startRow
    }
    
    func setup() {
        getCountriesData()
        
        if startRow != 0 {
            nationalityPickerViewModelDelegate?.updateStartRow(startRow: startRow)
        }
    }
    
    func getCountriesData() {
        let localesList: [String] = NSLocale.isoCountryCodes
        
        for localeListItem in localesList {
            let localeIdentifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: localeListItem])
            let locale = NSLocale(localeIdentifier: localeIdentifier)
            
            let countryName = locale.displayName(forKey: NSLocale.Key.identifier, value: localeIdentifier)!
            
            countries.append(countryName)
            countryCodes.append(localeListItem)
        }
    }
    
    func deleteNationality() {
        nationalityPickerViewModelParentDelegate?.selectNationality(name: "", code: "", row: 0)
        nationalityPickerViewModelDelegate?.hideModal(completion: nil)
    }
    
    func selectNationality(selectedRow: Int) {
        nationalityPickerViewModelParentDelegate?.selectNationality(name: selectedRow == 0 ? "" : countries[selectedRow], code: countryCodes[selectedRow], row: selectedRow)
        nationalityPickerViewModelDelegate?.hideModal(completion: nil)
    }
}
