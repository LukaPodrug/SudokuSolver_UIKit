//
//  StandingsTableViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

protocol StandigsTableViewDelegate: AnyObject {
    func showUserModal(userId: Int)
    func getMoreStandings()
}

class StandingsTableViewController: UITableViewController {
    var standings: [StandingModel] = []
    var standingsLoadMore: Bool = false
    var ownData: UserModel = UserModel(id: 0, firstName: "", lastName: "", username: "", email: "", nationality: "", dateOfBirth: "", nationalityStanding: 0, globalStanding: 0, successAttempts: 0, failureAttempts: 0, numberOfRecords: 0)
    
    weak var standingsTableViewDelegate: StandigsTableViewDelegate?
    
    private let tableHeaderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let standingsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "#"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Username"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Pts"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        tableView.separatorStyle = .none
    }
    
    func setupUIFunctionality() {
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "UsersCell")
    }
    
    func updateData() {
        tableView.animatedReload()
    }
    
    func updateStandings(standings: [StandingModel]) {
        self.standings = standings
    }
    
    func updateStandingsLoadMore(standigsLoadMore: Bool) {
        self.standingsLoadMore = standigsLoadMore
    }
    
    func updateOwnData(ownData: UserModel) {
        self.ownData = ownData
    }
}

extension StandingsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersTableViewCell
        cell.setupUI(ownCell: ownData.id == standings[indexPath.row].id)
        cell.setupUIData(standing: standings[indexPath.row].standing, username: standings[indexPath.row].username, points: standings[indexPath.row].points)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UsersTableViewCell = tableView.cellForRow(at: indexPath) as! UsersTableViewCell
        cell.onUsersCellPressAnimation()
        standingsTableViewDelegate?.showUserModal(userId: standings[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == standings.count - 1 && standingsLoadMore == true && standings.count != 0 {
            standingsTableViewDelegate?.getMoreStandings()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderView: UIView = tableHeaderView
        let standingsLabel: UILabel = standingsLabel
        let usernameLabel: UILabel = usernameLabel
        let pointsLabel: UILabel = pointsLabel
        
        tableHeaderView.snp.makeConstraints { make -> Void in
            make.width.equalTo(tableView.frame.width)
            make.height.equalTo(50)
        }
        
        tableHeaderView.addSubview(standingsLabel)
        
        standingsLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        
        tableHeaderView.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(standingsLabel)
        }
        
        tableHeaderView.addSubview(pointsLabel)
        
        pointsLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(usernameLabel)
        }
        
        return tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
