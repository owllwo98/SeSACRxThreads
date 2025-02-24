//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let profileImage: String
}

class HomeworkViewController: UIViewController {
    let viewmodel = HomeViewModel()
    
    let sampleUsers: [Person] = []
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
//    let items = BehaviorSubject(value: ["jack", "Hue", "Den", "Bran"])
//    let recent = BehaviorRelay(value: ["Hoon"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let recentText = PublishSubject<String>()
        
        let input = HomeViewModel.Input(searhButtonTapped: searchBar.rx.searchButtonClicked, searchBarText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        let output = viewmodel.tansform(input: input)
        
        output.recent
//            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: UserCollectionViewCell
                .identifier, cellType: UserCollectionViewCell.self)) { (row, element, cell) in
                    
                    cell.label.text = element
                }
                .disposed(by: disposeBag)
        
        output.items
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { (row, element, cell) in
                cell.usernameLabel.text = element
            }
            .disposed(by: disposeBag)
        
        
        
        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .map { $0.0 }
            .bind(with: self) { owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
}

