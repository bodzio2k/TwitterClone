//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ExploreController: RootViewController {
    //MARK: Properties
    let reuseIdentifier = "UserCell"
    var users = Array<User>()
    private let searchController = UISearchController(searchResultsController: nil)
    var isInSearchMode: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    var filteredUsers = Array<User>()
    
    var tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    //MARK: API calls
    func fetchAllUsers() {
        UserService.shared.fetchAllUser { (users) in
            self.users = users
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: Lifecycle
    fileprivate func configureSearchConotroller() {
        searchController.searchBar.placeholder = "Search for a user..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        navigationItemTitle = "Explore"
        
        configureSearchConotroller()
        
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        fetchAllUsers()
        
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(self.view)
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        
        
    }
}

extension ExploreController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = isInSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.configure(for: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isInSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        let profileController = ProfileController(user: user)
        
        navigationController?.pushViewController(profileController, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchFor = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        filteredUsers = users.filter { user in
            let usernameMatched = user.username.lowercased().contains(searchFor)
            let fullnameMatched = user.fullname.lowercased().contains(searchFor)
            
            return usernameMatched || fullnameMatched || searchFor.isEmpty
        }
        
        tableView.reloadData()
    }
}
