//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
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
    
    lazy var items = BehaviorSubject(value: data)
    
    var data = [
        "First Item",
        "Second Item",
        "Third Item",
        "AAA",
        "C",
        "B",
        "ACA",
        "BCA",
        "TCA",
        "dassf",
        "ggg",
        "fafsa",
        "tgre"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
//        bind1()
//        test()
        
        bind()
    }
    
    func test() {
        
        let mentor = Observable.of("Hue", "Jack", "Bran", "Den")
        let age = Observable.of(10, 11, 12)
        
        Observable.combineLatest(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }.disposed(by: disposeBag)
//        Observable.combineLatest(mentor, age)
    }
    
    func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
//                let disposeBag = DisposeBag()
                
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .lightGray
                
                // Cell 구독이 중첩된다. , 중첩구독
                cell.downloadButton.rx.tap
                    .do(onDispose: {print("downloadButton onDispose") } )
                    .bind(with: self) { owner, _ in
                        print("downloadButton tap")
                        
                        owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                    }// Cell 의 disposeBag 으로 관리한다
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        // 서치바 + 엔터 + append
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { _, text in
                return text
            })
        // 만약 그냥 return 한다면 생략가능
//            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                print("search tap", value)
                
                
                owner.data.insert(value, at: 0)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        // 실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withLatestFrom(items, resultSelector: { value, items in
                value == "" ?  self.data : items.filter {$0.contains(value)}
            })
            .bind(with: self) { owner, value in
//                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value) }
//                
//                owner.items.onNext(result)
//                
//                print(value)
                
//                let result = value == [] ? owner.data : value
//                
                owner.items.onNext(value)
                
            }
            .disposed(by: disposeBag)
        
    }
    
    func bind1() {
        
        // 서치바 리턴 클릭
        searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("리턴키 클릭", value)
            }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 글자", value)
            }.disposed(by: disposeBag)
        

        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        // 2개 이상의 옵저버블을 하나로 합쳐줌!
        // zip vs combineLatest
        Observable.combineLatest(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .map{
                "\($0.1.row) 번째 인덱스에는 \($0.0) 데이터가 있습니다."
            }
            .bind(with: self) { owner, value in
                print(value)
            }.disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .bind { index in
//                print(index)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self)
//            .bind(with: self) { owner, value in
//                print(value)
//            }.disposed(by: disposeBag)
    }
    
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
