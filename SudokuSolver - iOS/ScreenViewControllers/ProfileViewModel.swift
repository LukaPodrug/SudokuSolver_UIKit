//
//  ProfileViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.01.2024..
//

import Foundation
import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func removeLoggedOutViewControllers()
    func updateOwnData()
    func updatePuzzlesList()
    func navigateToLogin()
    func showDeleteAccountQueryAlert()
    func showDeleteAccountConfirmationFailureAlert()
    func showRemoveTokenFailureAlert()
    func showGetOwnDataFailureAlert()
    func showGetPuzzlesFailureAlert()
    func showMyPuzzlesModal()
    func showStandingsModal()
    func showEditProfileModal()
    func showPlayPuzzleModal(puzzleData: PuzzleModel)
    func showUserModal(userId: Int)
    func showManualInputModal()
    func showGalleryInputModal()
    func showCameraInputModal()
    func showImageInputModal(puzzleGrabberString: String)
    func hideImageInputModal()
    func showExecuteGrabberFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
    func hideNavigationControllerModal()
    func updatePuzzlesListCollectionViewHeight(height: Float)
}

class ProfileViewModel {
    var ownData: UserModel
    var puzzles: [[PuzzleModel]]
    var puzzlesLoadMore: [Bool]
    var puzzlesDifficultyIndex: Int
    
    weak var profileViewModelDelegate: ProfileViewModelDelegate?
    
    init() {
        self.ownData = UserModel(id: 0, firstName: "", lastName: "", username: "", email: "", nationality: "", dateOfBirth: "", nationalityStanding: 0, globalStanding: 0, successAttempts: 0, failureAttempts: 0, numberOfRecords: 0)
        self.puzzles = [[], [], [], [], []]
        self.puzzlesLoadMore = [true, true, true, true, true]
        self.puzzlesDifficultyIndex = 0
    }
    
    func setup() async {
        DispatchQueue.main.async {
            self.profileViewModelDelegate?.removeLoggedOutViewControllers()
            
            Task {
                await self.getInitialData()
            }
        }
    }
    
    func getInitialData() async {
        DispatchQueue.main.async {
            Task {
                await self.getOwnData()
                await self.getInitialPuzzles()
                self.calculatePuzzlesListCollectionViewHeight(difficulty: self.puzzlesDifficultyIndex + 1)
            }
        }
    }
    
    func getInitialPuzzles() async {
        DispatchQueue.main.async {
            Task {
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 1, number: 10, own: false, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 2, number: 10, own: false, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 3, number: 10, own: false, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 4, number: 10, own: false, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 5, number: 10, own: false, update: false, prepend: false)
            }
        }
    }
    
    func getNewPuzzles() {
        DispatchQueue.main.async {
            Task {
                await self.getPuzzles(firstId: self.puzzles[self.puzzlesDifficultyIndex].first?.id, lastId: nil, difficulty: self.puzzlesDifficultyIndex + 1, number: 10, own: false, update: false, prepend: true)
            }
        }
    }
    
    func getMorePuzzles() {
        DispatchQueue.main.async {
            if self.puzzlesLoadMore[self.puzzlesDifficultyIndex] == true {
                Task {
                    await self.getPuzzles(firstId: nil, lastId: self.puzzles[self.puzzlesDifficultyIndex].last?.id, difficulty: self.puzzlesDifficultyIndex + 1, number: 10, own: false, update: false, prepend: false)
                }
            }
        }
    }
    
    func deleteAccount() {
        profileViewModelDelegate?.showDeleteAccountQueryAlert()
    }
    
    func handleDeleteAccountConfirmation() {
        DispatchQueue.main.async {
            Task {
                let (deleteAccountValid, deleteAccountMessage) = await APIManager.shared.deleteAccount()
                
                switch deleteAccountValid {
                    case .valid:
                        self.handleDeleteAccountConfirmationSuccess()
                        break
                    case .invalid:
                        self.showDeleteAccountConfirmationFailureAlert()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleDeleteAccountConfirmationSuccess() {
        profileViewModelDelegate?.navigateToLogin()
    }
    
    func showDeleteAccountConfirmationFailureAlert() {
        profileViewModelDelegate?.showDeleteAccountConfirmationFailureAlert()
    }
    
    func logout() {
        DispatchQueue.main.async {
            let (removeTokenVaild, removeTokenMessage) = KeychainManager.shared.remove(service: "token", account: "user")
            
            switch removeTokenVaild {
                case .valid:
                    self.handleLogoutSuccess()
                    break
                case .invalid:
                    self.handleLogoutFailure()
                    break
                default:
                    break
            }
        }
    }
    
    func handleLogoutSuccess() {
        profileViewModelDelegate?.navigateToLogin()
    }
    
    func handleLogoutFailure() {
        profileViewModelDelegate?.showRemoveTokenFailureAlert()
    }
    
    func getOwnData() async {
        DispatchQueue.main.async {
            Task {
                let (getOwnDataValid, getOwnDataMessage, getOwnDataData) = await APIManager.shared.getOwnData()
                
                switch getOwnDataValid {
                    case .valid:
                        self.handleGetOwnDataSuccess(ownData: getOwnDataData!)
                        break
                    case .invalid:
                        self.handleGetOwnDataFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleGetOwnDataSuccess(ownData: UserModel) {
        DispatchQueue.main.async {
            self.ownData = ownData
            self.profileViewModelDelegate?.updateOwnData()
        }
    }
    
    func handleGetOwnDataFailure() {
        profileViewModelDelegate?.showGetOwnDataFailureAlert()
    }
    
    func getPuzzles(firstId: Int?, lastId: Int?, difficulty: Int, number: Int, own: Bool, update: Bool, prepend: Bool) async {
        DispatchQueue.main.async {
            if self.puzzlesLoadMore[difficulty - 1] == false && update == false && prepend == false {
                return
            }
        
            else if update == false && prepend == false {
                self.puzzlesLoadMore[difficulty - 1] = false
            }
        
            Task {
                let (getPuzzlesValid, getPuzzlesMessage, getPuzzlesData) = await APIManager.shared.getPuzzles(firstId: firstId ?? 0, lastId: lastId ?? 0, difficulty: difficulty, number: number, own: own)
                
                switch getPuzzlesValid {
                    case .valid:
                        self.handleGetPuzzlesSuccess(difficulty: difficulty, puzzles: getPuzzlesData!, update: update, prepend: prepend)
                        break
                    case .invalid:
                        self.handleGetPuzzlesFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleGetPuzzlesSuccess(difficulty: Int, puzzles: [PuzzleModel], update: Bool, prepend: Bool) {
        DispatchQueue.main.async {
            if update == true {
                self.puzzles[difficulty - 1] = puzzles
            }
            
            else if prepend == true {
                self.puzzles[difficulty - 1].insert(contentsOf: puzzles, at: 0)
            }
            
            else {
                self.puzzles[difficulty - 1].append(contentsOf: puzzles)
            }
            
            if update == false && prepend == false && puzzles.count % 10 == 0 {
                self.puzzlesLoadMore[difficulty - 1] = true
            }
            
            if difficulty - 1 == self.puzzlesDifficultyIndex {
                self.profileViewModelDelegate?.updatePuzzlesList()
                self.calculatePuzzlesListCollectionViewHeight(difficulty: difficulty)
            }
        }
    }
    
    func handleGetPuzzlesFailure() {
        profileViewModelDelegate?.showGetPuzzlesFailureAlert()
    }
    
    func inputImagePicked(image: UIImage) {
        DispatchQueue.main.async {
            self.profileViewModelDelegate?.showLoadingModal()
            
            Task {
                let (executeGrabberValid, executeGrabberMessage, executeGrabberData) = await APIManager.shared.executeGrabber(image: image)
                
                switch executeGrabberValid {
                    case .valid:
                        self.handleExecuteGrabberSuccess(puzzleGrabberString: executeGrabberData!)
                        break
                    case .invalid:
                        self.handleExecuteGrabberFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleExecuteGrabberSuccess(puzzleGrabberString: String) {
        profileViewModelDelegate?.hideModal(completion: { self.profileViewModelDelegate?.showImageInputModal(puzzleGrabberString: puzzleGrabberString) })
    }
    
    func handleExecuteGrabberFailure() {
        profileViewModelDelegate?.hideModal(completion: { self.profileViewModelDelegate?.showExecuteGrabberFailureAlert() })
    }
    
    func calculatePuzzlesListCollectionViewHeight(difficulty: Int) {
        DispatchQueue.main.async {
            if self.puzzles[difficulty - 1].count == 0 {
                self.profileViewModelDelegate?.updatePuzzlesListCollectionViewHeight(height: 120)
            }
            
            else {
                let puzzleCellsHeight: Float = Float(self.puzzles[difficulty - 1].count * 120)
                let puzzleCellsGapsHeight: Float = Float((self.puzzles[difficulty - 1].count - 1) * 10)
                self.profileViewModelDelegate?.updatePuzzlesListCollectionViewHeight(height: puzzleCellsHeight + puzzleCellsGapsHeight)
            }
        }
    }
}

extension ProfileViewModel: DataButtonsViewModelParentDelegate {
    func showMyPuzzlesModal() {
        profileViewModelDelegate?.showMyPuzzlesModal()
    }
    
    func showStandingsModal() {
        profileViewModelDelegate?.showStandingsModal()
    }
    
    func showEditProfileModal() {
        profileViewModelDelegate?.showEditProfileModal()
    }
}

extension ProfileViewModel: MyPuzzlesViewModelParentDelegate {
    func updateOwnDataAfterMyPuzzleResult() {
        DispatchQueue.main.async {
            Task {
                await self.getOwnData()
                self.profileViewModelDelegate?.updateOwnData()
            }
        }
    }
}

extension ProfileViewModel: EditProfileViewModelParentDelegate {
    func updateOwnDataAfterEditProfile() {
        DispatchQueue.main.async {
            Task {
                await self.getOwnData()
                self.profileViewModelDelegate?.updateOwnData()
            }
        }
    }
}

extension ProfileViewModel: PuzzlesListCollectionViewDelegate {
    func playPuzzle(puzzleData: PuzzleModel) {
        profileViewModelDelegate?.showPlayPuzzleModal(puzzleData: puzzleData)
    }
    
    func showUserModal(userId: Int) {
        profileViewModelDelegate?.showUserModal(userId: userId)
    }
}

extension ProfileViewModel: PuzzleViewModelParentDelegate {
    func updateOwnDataAfterPuzzleResult() {
        DispatchQueue.main.async {
            Task {
                await self.getOwnData()
                self.profileViewModelDelegate?.updateOwnData()
            }
        }
    }
    
    func updatePuzzlesDataAfterPuzzleResult() {
        DispatchQueue.main.async {
            Task {
                await self.getPuzzles(firstId: self.puzzles[self.puzzlesDifficultyIndex].first?.id, lastId: self.puzzles[self.puzzlesDifficultyIndex].last?.id, difficulty: self.puzzlesDifficultyIndex + 1, number: self.puzzles[self.puzzlesDifficultyIndex].count, own: false, update: true, prepend: false)
                self.profileViewModelDelegate?.updatePuzzlesList()
            }
        }
    }
}

extension ProfileViewModel: InputViewModelParentDelegate {
    func showManualInputModal() {
        profileViewModelDelegate?.showManualInputModal()
    }
    
    func showGalleryInputModal() {
        profileViewModelDelegate?.showGalleryInputModal()
    }
    
    func showCameraInputModal() {
        profileViewModelDelegate?.showCameraInputModal()
    }
}
