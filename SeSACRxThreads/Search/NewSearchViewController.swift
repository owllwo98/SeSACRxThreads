//
//  NewSearchViewController.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NewSearchViewController: UIViewController {
    
    let viewModel = NewSearchViewModel()

    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configure()
        setSearchController()
        
        bind()
    }
    
    func bind() {
        
        let intput = NewSearchViewModel.Input(searchBarTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: intput)
        
        output.list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = element
                
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { "\($0) 텍스트" }
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
   

}
