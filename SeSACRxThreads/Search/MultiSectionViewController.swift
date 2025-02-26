//
//  MultiSectionViewController.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

struct Mentor {
    // Section data
    var name: String // 섹션 타이틀 ex.) Jack, Den, Bran
    var items: [Item] // 섹션 내에 셀에 들어갈 정보
}

struct Ment {
    let word: String
    let count = Int.random(in: 1...1000)
}

extension Mentor: SectionModelType {
    typealias Item = Ment
    
    init(original: Mentor, items: [Item]) {
        self = original
        self.items = items
    }
}

class MultiSectionViewController: UIViewController {

    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // TableViewSectionedDataSource<SectionModelType>
        let dataSource = RxTableViewSectionedReloadDataSource<Mentor> { dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
            
            cell.textLabel?.text = "\(item.word) - \(item.count)"
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        let mentor = [
            Mentor(name: "Jack", items: [
               Ment(word: "다시 해볼까요"),
               Ment(word: "저는 여러분이 고생했으면 좋겠어요")
            ]),
            Mentor(name: "Den", items: [
                Ment(word: "정답은 없죠"),
                Ment(word: "화이팅..!")
            ]),
            Mentor(name: "Bran", items: [
                Ment(word: "잘 되시나요")
            ])
        ]
        
        Observable.just(mentor)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
   

}
