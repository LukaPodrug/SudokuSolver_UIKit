//
//  MyPuzzlesViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 05.01.2024..
//

import UIKit

class MyPuzzlesViewController: UIViewController {
    let myPuzzlesViewModel: MyPuzzlesViewModel
    
    private let myPuzzlesTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "My puzzles"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let difficultySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Beginner", "Easy", "Medium", "Hard", "Evil"])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        
        return contentView
    }()
    
    private let puzzlesListCollectionViewController: PuzzlesListCollectionViewController = PuzzlesListCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        myPuzzlesViewModel = MyPuzzlesViewModel()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            await myPuzzlesViewModel.setup()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(myPuzzlesTitleLabel)
        
        myPuzzlesTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(difficultySegmentedControl)
        
        difficultySegmentedControl.snp.makeConstraints { make -> Void in
            make.top.equalTo(myPuzzlesTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make -> Void in
            make.top.equalTo(difficultySegmentedControl.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make -> Void in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(puzzlesListCollectionViewController.view)
        
        puzzlesListCollectionViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1290)
        }
    }
    
    func setupUIFunctionality() {
        myPuzzlesViewModel.myPuzzlesViewModelDelegate = self
        difficultySegmentedControl.addTarget(self, action: #selector(updateDifficulty), for: .valueChanged)
        scrollView.delegate = self
        puzzlesListCollectionViewController.puzzlesListCollectionViewDelegate = myPuzzlesViewModel
    }
}

extension MyPuzzlesViewController {
    @objc func updateDifficulty() {
        myPuzzlesViewModel.puzzlesDifficultyIndex = difficultySegmentedControl.selectedSegmentIndex
        updatePuzzlesList()
        myPuzzlesViewModel.calculatePuzzlesListCollectionViewHeight(difficulty: myPuzzlesViewModel.puzzlesDifficultyIndex + 1)
    }
}

extension MyPuzzlesViewController: MyPuzzlesViewModelDelegate {
    func updatePuzzlesList() {
        puzzlesListCollectionViewController.updatePuzzles(puzzles: myPuzzlesViewModel.puzzles[myPuzzlesViewModel.puzzlesDifficultyIndex])
        puzzlesListCollectionViewController.updateData()
        
        if presentedViewController is LoadingViewController {
            hideModal(completion: nil)
        }
    }
    
    func showGetPuzzlesFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting my puzzles", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showPlayPuzzleModal(puzzleData: PuzzleModel) {
        let puzzleViewController: PuzzleViewController = PuzzleViewController(inputMode: false, playMode: true, puzzleData: puzzleData, puzzleGrabberString: nil)
        puzzleViewController.puzzleViewModel.puzzleViewModelParentDelegate = myPuzzlesViewModel
        puzzleViewController.isModalInPresentation = true
        present(puzzleViewController, animated: true)
    }
    
    func showUserModal(userId: Int) {
        let userViewController: UserViewController = UserViewController(userId: userId)
        present(userViewController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    func updatePuzzlesListCollectionViewHeight(height: Float) {
        puzzlesListCollectionViewController.view.snp.updateConstraints { make -> Void in
            make.height.equalTo(height)
        }
    }
}

extension MyPuzzlesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 && scrollView.contentOffset.y + 1 >= scrollView.contentSize.height - scrollView.frame.size.height {
            myPuzzlesViewModel.getMorePuzzles()
        }
    }
}
