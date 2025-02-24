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
        
//        NetWorkManager.shared.callBoxOffice(date: "20250223") { response in
//            switch response {
//            case .success(let success):
//                dump(success)
//            case .failure(let failure):
//                print(failure)
//            }
//        }
        
        NetWorkManager.shared.callBoxOffice(date: "20250223")
            .subscribe(with: self) { owner, value in
                dump(value)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        
        let intput = NewSearchViewModel.Input(searchBarTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: intput)
        
        output.list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = element
                
            }
            .disposed(by: disposeBag)
        
        
        // MARK: map
        // 1:1 생성
        // tableView.rx.itemSelected 를 누를때마다 새로운 Observable 생성
//        tableView.rx.itemSelected
//            .map { _ in Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) }
//            .subscribe(with: self) { owner, value in
//                value
//                    .bind(with: self) { owner, value in
//                        print("onNext",value)
//                    }
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
        
        
        // MARK: withLatestFrom
        // tableView.rx.itemSelected 안에 Observable<Int>  이 있는데
        // tableView.rx.itemSelected 를 눌렀을때 제일 Observable<Int> 의 제일 최신의 값을 방출
//        tableView.rx.itemSelected
//            .withLatestFrom(Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance))
//            .subscribe(with: self) { owner, value in
//               print("onNext: \(value )")
//            }
//            .disposed(by: disposeBag)
        
        
        // MARK: flatMap
        // 1:1
        // 기본적으로 map 과 유사한데, flatMap 은 Observable 을 벗겨서 value 값만 가져온다.
//        tableView.rx.itemSelected
//            .flatMap { _ in
//                // dispose 가 될 수 있는 Observable 을 사용하는게 좋다
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            }
//            .subscribe(with: self) { owner, value in
//               print("onNext: \(value )")
//            }
//            .disposed(by: disposeBag)
        
        
        // MARK: flatMapLatest
        // 이전의 Observable 을 dispose 하고 새로운 Observable 을 구독한다.
        tableView.rx.itemSelected
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .do(onDispose: { print("dispose!") })
            }
            .subscribe(with: self) { owner, value in
               print("onNext: \(value )")
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
