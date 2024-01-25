//
//  UsersTableViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    private let myContentView: UIView = {
        let view = UIView()
    
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let standingLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(ownCell: Bool) {
        selectionStyle = .none
        
        myContentView.backgroundColor = ownCell ? .systemGreen : .systemGray6
        
        addSubview(myContentView)
        
        myContentView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        myContentView.addSubview(standingLabel)
        
        standingLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        
        myContentView.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(standingLabel)
        }
        
        myContentView.addSubview(pointsLabel)
        
        pointsLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(usernameLabel)
        }
    }
    
    func setupUIData(standing: Int, username: String, points: Int) {
        standingLabel.text = String(standing)
        usernameLabel.text = username
        pointsLabel.text = String(points)
    }
}

extension UsersTableViewCell {
    func onUsersCellPressAnimation() {
        UIView.transition(
            with: self,
            duration: 0.0,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 0.5 },
            completion: { _ in self.onUsersCellAnimationEnd() }
        )
    }
    
    func onUsersCellAnimationEnd() {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 1 },
            completion: nil
        )
    }
}
