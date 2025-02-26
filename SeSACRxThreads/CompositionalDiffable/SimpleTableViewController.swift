//
//  SimpleTableViewController.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/26/25.
//

import UIKit
import SnapKit

class SimpleTableViewController: UIViewController {
    
    private lazy var tableView =  {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
}

extension SimpleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")!
        
//        cell.textLabel?.text = "test"
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "just text"
        content.secondaryText = "second Text"
        content.image = UIImage(systemName: "star")
        
        content.textProperties.color = .systemGreen
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        
        content.imageProperties.tintColor = .systemPink
        content.imageToTextPadding = 100
        
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    
}
