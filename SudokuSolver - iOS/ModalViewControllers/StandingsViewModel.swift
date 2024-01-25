//
//  StandingsViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.01.2024..
//

import Foundation

protocol StandingsViewModelDelegate: AnyObject {
    func updateStandings()
    func showGetGlobalStandingsFailureAlert()
    func showGetNationalityStandingsFailureAlert()
    func showUserModal(userId: Int)
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
}

class StandingsViewModel {
    var ownData: UserModel
    var standings: [[StandingModel]]
    var standingsLoadMore: [Bool]
    var regionIndex: Int
    var setupDone: Bool
    
    weak var standingsViewModelDelegate: StandingsViewModelDelegate?
    
    init(ownData: UserModel) {
        self.ownData = ownData
        self.standings = [[], []]
        self.standingsLoadMore = [true, true]
        self.regionIndex = 0
        self.setupDone = false
    }
    
    func setup() async {
        DispatchQueue.main.async {
            if self.setupDone == false {
                self.standingsViewModelDelegate?.showLoadingModal()
                
                Task {
                    await self.getInitialStandings()
                    self.setupDone = true
                }
            }
        }
    }
    
    func getInitialStandings() async {
        DispatchQueue.main.async {
            Task {
                await self.getGlobalStandings()
                
                if self.ownData.nationality != nil {
                    await self.getNationalityStandings()
                }
            }
        }
    }
    
    func getGlobalStandings() async {
        DispatchQueue.main.async {
            if self.standingsLoadMore[0] == false {
                return
            }
            
            self.standingsLoadMore[0] = false
            
            Task {
                let (getGlobalStandingsValid, getGlobalStandingsMessage, getGlobalStandingsData) = await APIManager.shared.getGlobalStandings(lastPosition: self.standings[0].count)
                
                switch getGlobalStandingsValid {
                    case .valid:
                        self.handleGetGlobalStandingSuccess(globalStandingsData: getGlobalStandingsData!)
                        break
                    case .invalid:
                        self.handleGetGlobalStandingsFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleGetGlobalStandingSuccess(globalStandingsData: [StandingModel]) {
        DispatchQueue.main.async {
            self.standings[0].append(contentsOf: globalStandingsData)
            self.standings[0] = self.standings[0].uniqued()
            
            if globalStandingsData.count % 10 == 0 {
                self.standingsLoadMore[0] = true
            }
            
            self.standingsViewModelDelegate?.updateStandings()
        }
    }
    
    func handleGetGlobalStandingsFailure() {
        standingsViewModelDelegate?.showGetGlobalStandingsFailureAlert()
    }
    
    func getNationalityStandings() async {
        DispatchQueue.main.async {
            if self.standingsLoadMore[1] == false {
                return
            }
            
            self.standingsLoadMore[1] = false
            
            Task {
                let (getNationalityStandingsValid, getNationalityStandingsMessage, getNationalityStandingsData) = await APIManager.shared.getNationalityStandings(lastPosition: self.standings[1].count)
                
                switch getNationalityStandingsValid {
                case .valid:
                    self.handleGetNationalityStandingsSuccess(nationaliyStandingsData: getNationalityStandingsData!)
                    break
                case .invalid:
                    self.handleGetNationalityStandingsFailure()
                    break
                default:
                    break
                }
            }
        }
    }
    
    func handleGetNationalityStandingsSuccess(nationaliyStandingsData: [StandingModel]) {
        DispatchQueue.main.async {
            self.standings[1].append(contentsOf: nationaliyStandingsData)
            self.standings[1] = self.standings[1].uniqued()
            
            if nationaliyStandingsData.count % 10 == 0 {
                self.standingsLoadMore[1] = true
            }
            
            self.standingsViewModelDelegate?.updateStandings()
        }
    }
    
    func handleGetNationalityStandingsFailure() {
        standingsViewModelDelegate?.showGetNationalityStandingsFailureAlert()
    }
}

extension StandingsViewModel: StandigsTableViewDelegate {
    func showUserModal(userId: Int) {
        standingsViewModelDelegate?.showUserModal(userId: userId)
    }
    
    func getMoreStandings() {
        DispatchQueue.main.async {
            Task {
                await self.getNationalityStandings()
            }
        }
    }
}
