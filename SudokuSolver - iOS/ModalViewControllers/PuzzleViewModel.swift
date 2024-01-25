//
//  PuzzleViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.01.2024..
//

import Foundation

protocol PuzzleViewModelParentDelegate: AnyObject {
    func updateOwnDataAfterPuzzleResult()
    func updatePuzzlesDataAfterPuzzleResult()
}

protocol PuzzleViewModelDelegate: AnyObject {
    func setup(backEnabled: Bool)
    func updateStopwatch()
    func finishPlay()
    func playAddedPuzzle()
    func selectOccupiedCellNotes(selectedPuzzleCellIndexPath: IndexPath)
    func selectFreeCellNotes(selectedPuzzleCellIndexPath: IndexPath)
    func selectOccupiedCellValue(selectedPuzzleCellIndexPath: IndexPath)
    func selectFreeCellValue(selectedPuzzleCellIndexPath: IndexPath)
    func clearPuzzle()
    func deleteCell()
    func toggleNotes()
    func updatePuzzle(value: Int)
    func updateCandidates(value: Int)
    func showFirstSolutionStep()
    func showNextStepText(text: String)
    func showNextStepPuzzle()
    func showEntireSolution()
    func showAddPuzzleSuccessAlert(puzzleData: PuzzleModel)
    func showAddPuzzleFailureAlert()
    func showCorrectAttemptAlert()
    func showIncorrectAttemptAlert()
    func showAddAttemptFailureAlert()
    func showGetSolutionStepsFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
}

class PuzzleViewModel {
    var inputMode: Bool
    var playMode: Bool
    var puzzleData: PuzzleModel?
    var puzzleGrabberString: String?
    var puzzle: [[Int]]
    var workingPuzzle: [[Int]]
    var candidates: [[[Int]]]
    var notesMode: Bool
    var selectedPuzzleCellIndexPath: IndexPath?
    var stopwatchTimer: Timer?
    var playTime: Int
    var solutionSteps: [String]?
    
    weak var puzzleViewModelParentDelegate: PuzzleViewModelParentDelegate?
    weak var puzzleViewModelDelegate: PuzzleViewModelDelegate?
    
    init(inputMode: Bool, playMode: Bool, puzzleData: PuzzleModel?, puzzleGrabberString: String?) {
        self.inputMode = inputMode
        self.playMode = playMode
        self.puzzleData = puzzleData
        self.puzzleGrabberString = puzzleGrabberString
        
        self.puzzle = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        self.workingPuzzle = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        self.candidates = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9), count: 9)
        
        self.notesMode = false
        self.selectedPuzzleCellIndexPath = nil
        
        self.stopwatchTimer = nil
        self.playTime = 0
        
        self.solutionSteps = nil
    }
    
    func setup() {
        if puzzleData != nil {
            puzzle = puzzleData!.string.toPuzzleMatrix()
            workingPuzzle = puzzleData!.string.toPuzzleMatrix()
        }
        
        else if puzzleGrabberString != nil {
            workingPuzzle = (puzzleGrabberString?.toPuzzleMatrix())!
        }
        
        if playMode == true {
            startStopwatch()
        }
        
        puzzleViewModelDelegate?.setup(backEnabled: playMode == true ? false : true)
    }
    
    func addPuzzle() async {
        DispatchQueue.main.async {
            Task {
                let (addPuzzleValid, addPuzzleMessage, addPuzzleData) = await APIManager.shared.addPuzzle(puzzleString: (self.workingPuzzle.toPuzzleString()))
                
                switch addPuzzleValid {
                    case .valid:
                        self.handleAddPuzzleSuccess(puzzleData: addPuzzleData!)
                        break
                    case .invalid:
                        self.handleAddPuzzleFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleAddPuzzleSuccess(puzzleData: PuzzleModel) {
        puzzleViewModelDelegate?.hideModal(completion: { self.puzzleViewModelDelegate?.showAddPuzzleSuccessAlert(puzzleData: puzzleData) })
    }
    
    func handleAddPuzzleFailure() {
        puzzleViewModelDelegate?.hideModal(completion: { self.puzzleViewModelDelegate?.showAddPuzzleFailureAlert() })
    }
    
    func addAttempt(completion: Bool) async {
        DispatchQueue.main.async {
            Task {
                let (addAttemptValid, addAttemptMessage) = (await APIManager.shared.addAttempt(puzzleId: self.puzzleData!.id, completion: completion, time: self.playTime))
                
                switch addAttemptValid {
                case .valid:
                    self.handleAddAttemptSuccess(completion: completion)
                    break
                case .invalid:
                    self.handleAddAttemptFailure()
                    break
                default:
                    break
                }
            }
        }
    }
    
    func handleAddAttemptSuccess(completion: Bool) {
        puzzleViewModelDelegate?.finishPlay()
        puzzleViewModelDelegate?.hideModal(completion: { completion == true ? self.puzzleViewModelDelegate?.showCorrectAttemptAlert() : self.puzzleViewModelDelegate?.showIncorrectAttemptAlert() })
        puzzleViewModelParentDelegate?.updateOwnDataAfterPuzzleResult()
        puzzleViewModelParentDelegate?.updatePuzzlesDataAfterPuzzleResult()
    }
    
    func handleAddAttemptFailure() {
        puzzleViewModelDelegate?.hideModal(completion: { self.puzzleViewModelDelegate?.showAddAttemptFailureAlert() })
    }
    
    func getSolutionSteps() async {
        DispatchQueue.main.async {
            Task {
                let (getSolutionStepsValid, getSolutionStepsMessage, getSolutionStepsData) = await APIManager.shared.executeHelper(puzzleId: self.puzzleData!.id, puzzleString: self.puzzleData!.string, userString: self.workingPuzzle.toPuzzleString(), solutionString: self.puzzleData!.solvedString)
                
                switch getSolutionStepsValid {
                    case .valid:
                        self.handleGetSolutionStepsSuccess(steps: getSolutionStepsData!)
                        break
                    case .invalid:
                        self.handleGetSolutionStepsFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleGetSolutionStepsSuccess(steps: [String]) {
        clearPuzzle()
        solutionSteps = steps
        let startValues: String = String(solutionSteps![0].dropFirst())
        let startCandidates: String = String(solutionSteps![1].dropFirst())
        solutionSteps!.removeFirst(2)
        workingPuzzle = startValues.toPuzzleMatrix()
        candidates = startCandidates.toCandidatesMatrix()
        puzzleViewModelDelegate?.showFirstSolutionStep()
    }
    
    func handleGetSolutionStepsFailure() {
        puzzleViewModelDelegate?.showGetSolutionStepsFailureAlert()
    }
    
    func startStopwatch() {
        stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.playTime = self.playTime + 1
            self.puzzleViewModelDelegate?.updateStopwatch()
        }
    }
    
    func checkPuzzleCompletion() -> Bool {
        return workingPuzzle.toPuzzleString() == puzzleData?.solvedString
    }
    
    func confirm() {
        DispatchQueue.main.async {
            self.puzzleViewModelDelegate?.showLoadingModal()
            
            Task {
                if self.inputMode == true {
                    await self.addPuzzle()
                }
                
                else if self.playMode == true {
                    await self.finishPlay()
                }
            }
        }
    }
    
    func finishPlay() async {
        DispatchQueue.main.async {
            Task {
                self.playMode = false
                self.stopwatchTimer?.invalidate()
                self.stopwatchTimer = nil
                await self.addAttempt(completion: self.checkPuzzleCompletion())
            }
        }
    }
    
    func playAddedPuzzle(puzzleData: PuzzleModel) {
        inputMode = false
        playMode = true
        self.puzzleData = puzzleData
        puzzle = workingPuzzle
        candidates = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9), count: 9)
        notesMode = false
        clearPuzzle()
        startStopwatch()
        puzzleViewModelDelegate?.playAddedPuzzle()
    }
    
    func showStepByStepSolution() {
        DispatchQueue.main.async {
            Task {
                await self.getSolutionSteps()
            }
        }
    }
}

extension PuzzleViewModel: PuzzleCollectionViewDelegate {
    func selectOccupiedCellNotes(selectedPuzzleCellIndexPath: IndexPath) {
        self.selectedPuzzleCellIndexPath = selectedPuzzleCellIndexPath
        puzzleViewModelDelegate?.selectOccupiedCellNotes(selectedPuzzleCellIndexPath: selectedPuzzleCellIndexPath)
    }
    
    func selectFreeCellNotes(selectedPuzzleCellIndexPath: IndexPath) {
        self.selectedPuzzleCellIndexPath = selectedPuzzleCellIndexPath
        puzzleViewModelDelegate?.selectFreeCellNotes(selectedPuzzleCellIndexPath: selectedPuzzleCellIndexPath)
    }
    
    func selectOccupiedCellValue(selectedPuzzleCellIndexPath: IndexPath) {
        self.selectedPuzzleCellIndexPath = selectedPuzzleCellIndexPath
        puzzleViewModelDelegate?.selectOccupiedCellValue(selectedPuzzleCellIndexPath: selectedPuzzleCellIndexPath)
    }
    
    func selectFreeCellValue(selectedPuzzleCellIndexPath: IndexPath) {
        self.selectedPuzzleCellIndexPath = selectedPuzzleCellIndexPath
        puzzleViewModelDelegate?.selectFreeCellValue(selectedPuzzleCellIndexPath: selectedPuzzleCellIndexPath)
    }
}

extension PuzzleViewModel: PuzzlePlayMenuViewParentDelegate {
    func clearPuzzle() {
        workingPuzzle = puzzle
        candidates = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9), count: 9)
        selectedPuzzleCellIndexPath = nil
        puzzleViewModelDelegate?.clearPuzzle()
    }
    
    func deleteCell() {
        workingPuzzle[selectedPuzzleCellIndexPath!.row / 9][selectedPuzzleCellIndexPath!.row % 9] = 0
        puzzleViewModelDelegate?.deleteCell()
    }
    
    func toggleNotes() {
        notesMode = !notesMode
        puzzleViewModelDelegate?.toggleNotes()
    }
}

extension PuzzleViewModel: NumpadCollectionViewDelegate {
    func updatePuzzle(value: Int) {
        workingPuzzle[selectedPuzzleCellIndexPath!.row / 9][selectedPuzzleCellIndexPath!.row % 9] = value
        puzzleViewModelDelegate?.updatePuzzle(value: value)
    }
    
    func updateCandidates(value: Int) {
        candidates[selectedPuzzleCellIndexPath!.row / 9][selectedPuzzleCellIndexPath!.row % 9][value] = candidates[selectedPuzzleCellIndexPath!.row / 9][selectedPuzzleCellIndexPath!.row % 9][value] == 0 ? 1 : 0
        puzzleViewModelDelegate?.updateCandidates(value: value)
    }
}

extension PuzzleViewModel: PuzzleSolutionMenuViewParentDelegate {
    func showNextStep() {
        if solutionSteps![0].first == "@" {
            let stepValues: String = String(solutionSteps![0].dropFirst())
            let stepCandidates: String = String(solutionSteps![1].dropFirst())
            
            solutionSteps!.removeFirst(2)
            
            workingPuzzle = stepValues.toPuzzleMatrix()
            candidates = stepCandidates.toCandidatesMatrix()
        }
        
        for index in 0...728 {
            switch candidates[index / 81][(index / 9) % 9][index % 9] {
                case 2:
                    workingPuzzle[index / 81][(index / 9) % 9] = (index % 9) + 1
                    break
                case 3:
                    candidates[index / 81][(index / 9) % 9][index % 9] = 1
                    break
                case 4:
                    candidates[index / 81][(index / 9) % 9][index % 9] = 0
                    break
                default:
                    break
            }
        }
        
        if solutionSteps!.count == 1 {
            showEntireSolution()
            return
        }
        
        puzzleViewModelDelegate?.showNextStepText(text: String(solutionSteps![0].dropFirst()))
        solutionSteps?.removeFirst()
        
        repeat {
            let prefix: Character = solutionSteps![0].removeFirst()
            let xCoordinate: Int = Int(String(solutionSteps![0].removeFirst()))!
            let yCoordinate: Int = Int(String(solutionSteps![0].removeFirst()))!
            let value: Int = Int(String(solutionSteps![0].removeFirst()))!
            
            switch prefix {
                case "%":
                    candidates[xCoordinate][yCoordinate][value - 1] = 2
                    break
                case "+":
                    candidates[xCoordinate][yCoordinate][value] = 3
                    break
                case "-":
                    candidates[xCoordinate][yCoordinate][value] = 4
                    break
                default:
                    break
            }
            
            solutionSteps?.removeFirst()
        } while solutionSteps![0].first != "*" && solutionSteps![0].first != "@"
        
        puzzleViewModelDelegate?.showNextStepPuzzle()
    }
    
    func showEntireSolution() {
        workingPuzzle = (puzzleData?.solvedString.toPuzzleMatrix())!
        puzzleViewModelDelegate?.showEntireSolution()
    }
}
