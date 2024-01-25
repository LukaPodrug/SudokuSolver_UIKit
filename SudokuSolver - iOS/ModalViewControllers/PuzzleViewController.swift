//
//  PuzzleViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 28.12.2023..
//

import UIKit

class PuzzleViewController: UIViewController {
    let puzzleViewModel: PuzzleViewModel
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    private let stopwatchLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    private let puzzleCollectionViewController: PuzzleCollectionViewController = PuzzleCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    private let puzzlePlayMenuView: PuzzlePlayMenuView = PuzzlePlayMenuView()
    
    private let numpadCollectionViewController: NumpadCollectionViewController = NumpadCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    private let puzzleSolutionMenuView: PuzzleSolutionMenuView = PuzzleSolutionMenuView()
    
    init(inputMode: Bool, playMode: Bool, puzzleData: PuzzleModel?, puzzleGrabberString: String?) {
        puzzleViewModel = PuzzleViewModel(inputMode: inputMode, playMode: playMode, puzzleData: puzzleData, puzzleGrabberString: puzzleGrabberString)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupUIFunctionality()
        puzzleViewModel.setup()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        
        view.addSubview(stopwatchLabel)
        
        stopwatchLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(backButton.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(backButton.snp.height)
        }
        
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(stopwatchLabel.snp.top)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(stopwatchLabel.snp.height)
        }
        
        view.addSubview(puzzleCollectionViewController.view)
        
        puzzleCollectionViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(puzzleCollectionViewController.view.snp.width)
        }
        
        view.addSubview(puzzlePlayMenuView)
        
        puzzlePlayMenuView.snp.makeConstraints { make -> Void in
            make.top.equalTo(puzzleCollectionViewController.view.snp.bottom).offset(20)
            make.leading.equalTo(puzzleCollectionViewController.view)
            make.width.equalTo(puzzleCollectionViewController.view)
            make.height.equalTo(65)
        }
        
        view.addSubview(numpadCollectionViewController.view)
        
        numpadCollectionViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(puzzlePlayMenuView.snp.bottom).offset(20)
            make.leading.equalTo(puzzlePlayMenuView)
            make.width.equalTo(puzzlePlayMenuView)
            make.height.equalTo(numpadCollectionViewController.view.snp.width).dividedBy(9)
        }
        
        view.addSubview(puzzleSolutionMenuView)
        
        puzzleSolutionMenuView.snp.makeConstraints { make -> Void in
            make.top.equalTo(numpadCollectionViewController.view.snp.bottom).offset(20)
            make.leading.equalTo(numpadCollectionViewController.view)
            make.width.equalTo(numpadCollectionViewController.view)
            make.height.equalTo(130)
        }
    }
    
    func setupUIFunctionality() {
        puzzleViewModel.puzzleViewModelDelegate = self
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        
        puzzleCollectionViewController.puzzleCollectionViewDelegate = puzzleViewModel
        puzzlePlayMenuView.puzzlePlayMenuViewModel.puzzlePlayMenuViewParentDelegate = puzzleViewModel
        numpadCollectionViewController.numpadCollectionViewDelegate = puzzleViewModel
        puzzleSolutionMenuView.puzzleSolutionMenuViewModel.puzzleSolutionMenuViewParentDelegate = puzzleViewModel
    }
}

extension PuzzleViewController {
    @objc func backButtonPressed() {
        hideModal(completion: nil)
    }
    
    @objc func confirmButtonPressed() {
        puzzleViewModel.confirm()
    }
}

extension PuzzleViewController: PuzzleViewModelDelegate {    
    func setup(backEnabled: Bool) {
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
        puzzlePlayMenuView.updateNotesFunction(notesMode: false)
        numpadCollectionViewController.disable()
        puzzleSolutionMenuView.disable()
        stopwatchLabel.text = puzzleViewModel.playTime.secondsToTime()
        puzzleCollectionViewController.updatePuzzle(puzzle: puzzleViewModel.puzzle)
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        backButton.isEnabled = backEnabled
    }
    
    func updateStopwatch() {
        stopwatchLabel.text = puzzleViewModel.playTime.secondsToTime()
    }
    
    func finishPlay() {
        backButton.isEnabled = true
        confirmButton.isEnabled = false
        puzzleCollectionViewController.disable()
        numpadCollectionViewController.disable()
        puzzlePlayMenuView.disable()
    }
    
    func playAddedPuzzle() {
        backButton.isEnabled = false
        puzzleCollectionViewController.updatePuzzle(puzzle: puzzleViewModel.puzzle)
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateCandidates(candidates: puzzleViewModel.candidates)
        puzzleCollectionViewController.updateNotesMode(notesMode: puzzleViewModel.notesMode)
        puzzleCollectionViewController.updateData()
        numpadCollectionViewController.updateData()
        puzzlePlayMenuView.updateNotesFunction(notesMode: false)
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
    }
    
    func selectOccupiedCellNotes(selectedPuzzleCellIndexPath: IndexPath) {
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: puzzleViewModel.puzzle[puzzleViewModel.selectedPuzzleCellIndexPath!.row / 9][puzzleViewModel.selectedPuzzleCellIndexPath!.row % 9] == 0 ? true : false)
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: puzzleCollectionViewController.collectionView.cellForItem(at: selectedPuzzleCellIndexPath) as? PuzzleCollectionViewCell)
        numpadCollectionViewController.updateHardcodedPuzzleCell(hardcodedPuzzleCell: true)
        numpadCollectionViewController.updateData()
        numpadCollectionViewController.enable()
    }
    
    func selectFreeCellNotes(selectedPuzzleCellIndexPath: IndexPath) {
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: puzzleCollectionViewController.collectionView.cellForItem(at: selectedPuzzleCellIndexPath) as? PuzzleCollectionViewCell)
        numpadCollectionViewController.updateHardcodedPuzzleCell(hardcodedPuzzleCell: false)
        numpadCollectionViewController.updateData()
        numpadCollectionViewController.enable()
    }
    
    func selectOccupiedCellValue(selectedPuzzleCellIndexPath: IndexPath) {
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: puzzleCollectionViewController.collectionView.cellForItem(at: selectedPuzzleCellIndexPath) as? PuzzleCollectionViewCell)
        numpadCollectionViewController.updateHardcodedPuzzleCell(hardcodedPuzzleCell: true)
        numpadCollectionViewController.updateData()
        numpadCollectionViewController.disable()
    }
    
    func selectFreeCellValue(selectedPuzzleCellIndexPath: IndexPath) {
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: puzzleViewModel.workingPuzzle[puzzleViewModel.selectedPuzzleCellIndexPath!.row / 9][puzzleViewModel.selectedPuzzleCellIndexPath!.row % 9] == 0 ? false : true)
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: puzzleCollectionViewController.collectionView.cellForItem(at: selectedPuzzleCellIndexPath) as? PuzzleCollectionViewCell)
        numpadCollectionViewController.updateHardcodedPuzzleCell(hardcodedPuzzleCell: false)
        numpadCollectionViewController.updateData()
        numpadCollectionViewController.enable()
    }
    
    func clearPuzzle() {
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateCandidates(candidates: puzzleViewModel.candidates)
        puzzleCollectionViewController.updateData()
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
        numpadCollectionViewController.disable()
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: nil)
        numpadCollectionViewController.updateData()
    }
    
    func deleteCell() {
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateData()
        puzzleCollectionViewController.updateSelectedPuzzleCellIndexPath(selectedPuzzleCellIndexPath: puzzleViewModel.selectedPuzzleCellIndexPath)
        puzzlePlayMenuView.updateDeleteFunction(isCellDeleteable: false)
        numpadCollectionViewController.updateData()
    }
    
    func toggleNotes() {
        puzzleCollectionViewController.updateNotesMode(notesMode: puzzleViewModel.notesMode)
        puzzleCollectionViewController.updateSelectedPuzzleCellIndexPath(selectedPuzzleCellIndexPath: puzzleViewModel.selectedPuzzleCellIndexPath)
        puzzlePlayMenuView.updateNotesFunction(notesMode: puzzleViewModel.notesMode)
        numpadCollectionViewController.updateNotesMode(notesMode: puzzleViewModel.notesMode)
        numpadCollectionViewController.updateData()
    }
    
    func updatePuzzle(value: Int) {
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateData()
        puzzleCollectionViewController.updateSelectedPuzzleCellIndexPath(selectedPuzzleCellIndexPath: puzzleViewModel.selectedPuzzleCellIndexPath)
        numpadCollectionViewController.updateData()
    }
    
    func updateCandidates(value: Int) {
        puzzleCollectionViewController.updateCandidates(candidates: puzzleViewModel.candidates)
        puzzleCollectionViewController.updateData()
        puzzleCollectionViewController.updateSelectedPuzzleCellIndexPath(selectedPuzzleCellIndexPath: puzzleViewModel.selectedPuzzleCellIndexPath)
        numpadCollectionViewController.updateData()
    }
    
    func showFirstSolutionStep() {
        puzzleSolutionMenuView.enable()
        puzzleSolutionMenuView.updateSolutionStepText(text: "Start position")
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateCandidates(candidates: puzzleViewModel.candidates)
        puzzleCollectionViewController.updateData()
        numpadCollectionViewController.disable()
        numpadCollectionViewController.updateData()
    }
    
    func showNextStepText(text: String) {
        puzzleSolutionMenuView.updateSolutionStepText(text: text)
    }
    
    func showNextStepPuzzle() {
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateCandidates(candidates: puzzleViewModel.candidates)
        puzzleCollectionViewController.updateData()
    }
    
    func showEntireSolution() {
        puzzleCollectionViewController.updateWorkingPuzzle(workingPuzzle: puzzleViewModel.workingPuzzle)
        puzzleCollectionViewController.updateData()
        numpadCollectionViewController.disable()
        numpadCollectionViewController.updateSelectedCell(selectedPuzzleCell: nil)
        numpadCollectionViewController.updateData()
        puzzleSolutionMenuView.updateSolutionStepText(text: "Puzzle completed")
        puzzleSolutionMenuView.disable()
    }
    
    func showAddPuzzleSuccessAlert(puzzleData: PuzzleModel) {
        let alertController: UIAlertController = UIAlertController(title: "New puzzle successfully added", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Play", style: .default, handler: { _ in self.puzzleViewModel.playAddedPuzzle(puzzleData: puzzleData) }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showAddPuzzleFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with adding puzzle", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showCorrectAttemptAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Your solution is correct", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showIncorrectAttemptAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Your solution is incorrect", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Show entire solution", style: .default, handler: { _ in self.puzzleViewModel.showEntireSolution() }))
        alertController.addAction(UIAlertAction(title: "Show step by step solution", style: .default, handler: { _ in self.puzzleViewModel.showStepByStepSolution() }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showAddAttemptFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with adding attempt", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showGetSolutionStepsFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting steps solution", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}
