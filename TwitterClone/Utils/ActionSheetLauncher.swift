//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 11/06/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    weak var delegate: ActionSheetLauncherDelegate?
    private let user: User
    private var tableView: UITableView!
    private let reusableIdentifier = "actionSheetCell"
    private lazy var blackView: UIView = {
        let v = UIView()
        
        v.alpha = 0.0
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        v.addGestureRecognizer(tap)
        
        return v
    }()
    private lazy var cancelButton: UIButton = {
        let b = UIButton()
        
        b.setTitle("Cancel", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .systemGroupedBackground
        b.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        return b
    }()
    private lazy var footerView: UIView = {
        let v = UIView()
        let buttonHeight: CGFloat = 50.0
        
        v.addSubview(self.cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        cancelButton.anchor(left: v.leftAnchor, right: v.rightAnchor, paddingLeft: 8.0, paddingRight: 8.0)
        cancelButton.layer.cornerRadius = buttonHeight / 2.0
        
        return v
    }()
    private var height: CGFloat {
        return rowHeight * CGFloat(viewModel.options.count + 1)
    }
    private let rowHeight: CGFloat = 60.0
    private lazy var viewModel = ActionSheetViewModel(user: user)
    
    fileprivate func configureTableView() {
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    init(for user: User) {
        self.user = user
        
        super.init()
        
        configureTableView()
    }
    
    func show() -> Void {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else{
            return
        }
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1.0
            self.tableView.frame.origin.y -= self.height
        }
    }
    
    @objc func dismissTapped() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0.0
            self.tableView.frame.origin.y += self.height
        }
    }
}

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! ActionSheetCell
        
        let option = viewModel.options[indexPath.row]
        cell.configure(for: option)

        return cell
    }
}

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0.0
            self.tableView.frame.origin.y += self.height
        }) { (_) in
            self.delegate?.didSelect(option: option)
        }
    }
}
