//
//  MyPuzzlesViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 12.01.2024..
//

import Foundation

protocol MyPuzzlesViewModelParentDelegate: AnyObject {
    func updateOwnDataAfterMyPuzzleResult()
}

protocol MyPuzzlesViewModelDelegate: AnyObject {
    func updatePuzzlesList()
    func showGetPuzzlesFailureAlert()
    func showPlayPuzzleModal(puzzleData: PuzzleModel)
    func showUserModal(userId: Int)
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
    func updatePuzzlesListCollectionViewHeight(height: Float)
}

class MyPuzzlesViewModel {
    var puzzles: [[PuzzleModel]]
    var puzzlesLoadMore: [Bool]
    var puzzlesDifficultyIndex: Int
    var setupDone: Bool
    
    weak var myPuzzlesViewModelParentDelegate: MyPuzzlesViewModelParentDelegate?
    weak var myPuzzlesViewModelDelegate: MyPuzzlesViewModelDelegate?
    
    init() {
        self.puzzles = [[], [], [], [], []]
        self.puzzlesLoadMore = [true, true, true, true, true]
        self.puzzlesDifficultyIndex = 0
        self.setupDone = false
    }
    
    func setup() async {
        DispatchQueue.main.async {
            if self.setupDone == false {
                self.myPuzzlesViewModelDelegate?.showLoadingModal()
                
                Task {
                    await self.getInitialData()
                    self.setupDone = true
                }
            }
        }
    }
    
    func getInitialData() async {
        DispatchQueue.main.async {
            Task {
                await self.getInitialPuzzles()
                self.calculatePuzzlesListCollectionViewHeight(difficulty: self.puzzlesDifficultyIndex + 1)
            }
        }
    }
    
    func getInitialPuzzles() async {
        DispatchQueue.main.async {
            Task {
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 1, number: 10, own: true, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 2, number: 10, own: true, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 3, number: 10, own: true, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 4, number: 10, own: true, update: false, prepend: false)
                await self.getPuzzles(firstId: nil, lastId: nil, difficulty: 5, number: 10, own: true, update: false, prepend: false)
            }
        }
    }
    
    func getMorePuzzles() {
        DispatchQueue.main.async {
            if self.puzzlesLoadMore[self.puzzlesDifficultyIndex] == true {
                Task {
                    await self.getPuzzles(firstId: nil, lastId: self.puzzles[self.puzzlesDifficultyIndex].last?.id, difficulty: self.puzzlesDifficultyIndex + 1, number: 10, own: true, update: false, prepend: false)
                }
            }
        }
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
                self.myPuzzlesViewModelDelegate?.updatePuzzlesList()
                self.calculatePuzzlesListCollectionViewHeight(difficulty: difficulty)
            }
        }
    }
    
    func handleGetPuzzlesFailure() {
        myPuzzlesViewModelDelegate?.showGetPuzzlesFailureAlert()
    }
    
    func calculatePuzzlesListCollectionViewHeight(difficulty: Int) {
        DispatchQueue.main.async {
            if self.puzzles[difficulty - 1].count == 0 {
                self.myPuzzlesViewModelDelegate?.updatePuzzlesListCollectionViewHeight(height: 120)
            }
            
            else {
                let puzzleCellsHeight: Float = Float(self.puzzles[difficulty - 1].count * 120)
                let puzzleCellsGapsHeight: Float = Float((self.puzzles[difficulty - 1].count - 1) * 10)
                self.myPuzzlesViewModelDelegate?.updatePuzzlesListCollectionViewHeight(height: puzzleCellsHeight + puzzleCellsGapsHeight)
            }
        }
    }
}

extension MyPuzzlesViewModel: PuzzlesListCollectionViewDelegate {
    func playPuzzle(puzzleData: PuzzleModel) {
        myPuzzlesViewModelDelegate?.showPlayPuzzleModal(puzzleData: puzzleData)
    }
    
    func showUserModal(userId: Int) {
        myPuzzlesViewModelDelegate?.showUserModal(userId: userId)
    }
}

extension MyPuzzlesViewModel: PuzzleViewModelParentDelegate {
    func updateOwnDataAfterPuzzleResult() {
        myPuzzlesViewModelParentDelegate?.updateOwnDataAfterMyPuzzleResult()
    }
    
    func updatePuzzlesDataAfterPuzzleResult() {
        DispatchQueue.main.async {
            Task {
                await self.getPuzzles(firstId: self.puzzles[self.puzzlesDifficultyIndex].first?.id, lastId: self.puzzles[self.puzzlesDifficultyIndex].last?.id, difficulty: self.puzzlesDifficultyIndex + 1, number: self.puzzles[self.puzzlesDifficultyIndex].count, own: true, update: true, prepend: false)
                self.myPuzzlesViewModelDelegate?.updatePuzzlesList()
            }
        }
    }
}
