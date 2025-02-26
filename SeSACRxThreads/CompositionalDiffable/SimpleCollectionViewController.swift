//
//  SimpleCollectionViewController.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/26/25.
//

import UIKit
import SnapKit

/*
 Data
 -> Delegate, DataSource (인덱스 기반) ex) list[indexPath]
 -> DiffableDataSource (데이터 기반)
 
 Layout
 -> FlowLayout
 ->
 -> List Configuration
 
 
 Presentation
 -> CellForRowAt / dequeueReusableCell
 ->
 -> List Cell / dequeueConfiguredReusableCell
 */


// UUID vs UDID
// UDID -> 기기의 고유값
// Identifiable 을 채택하면 id 값을 고유값으로 쓰고있다! 라는 의미
struct Product: Hashable, Identifiable {
    let id = UUID()
    
    let name: String
    let price = 40000 /*Int.random(in: 1...10000) * 1000*/
    let count = 8 /*Int.random(in: 1...10)*/
}


class SimpleCollectionViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
        case sub
    }

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // collectionView.regiestr 대신 사용
//    var registraion: UICollectionView.CellRegistration<UICollectionViewListCell, Product>!
    
    
    // <Section 을 구분해 줄 데이터 타입, Cell 에 들어가는 데이터 타입 >
    // numberOfItemsInSection, cellForItemAt 도 필요없음
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    var list = [
        
//        1, 535, 1551, 67665, 253
//        "Hue", "Jack", "Bran", "Den"
        Product(name: "MacBook Pro M5"),
        Product(name: "KeyBoard"),
        Product(name: "트랙패드"),
        Product(name: "금")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.delegate = self
//        collectionView.dataSource = self
        
        configureDataSource()
        updateSnapShot()
    }
    
    private func configureDataSource() {
        
        // collectionView.regiestr 대신 사용
//        var registraion: UICollectionView.CellRegistration<UICollectionViewListCell, Product>!
        
        // cellForItemAt 내부 코드가 들어간다
        var registraion = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .brown
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            content.secondaryText = itemIdentifier.price.formatted() + "원"
            content.secondaryTextProperties.color = .blue
            
            content.image = UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
            
            
            var backGroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backGroundConfig.backgroundColor = .yellow
            backGroundConfig.cornerRadius = 20
            backGroundConfig.strokeColor = .systemRed
            backGroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backGroundConfig
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registraion, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    
    private func updateSnapShot() {
        // <Section 에서 사용할 고유한 데이터 타입, Cell 에서 사용할 고유한 데이터 타입>
        var snapshot = NSDiffableDataSourceSnapshot<Section,Product>()
        
        // 인덱스를 따라가는게 아니라 unique Section identifer 만 가지면 된다.
        // 고유성을 보장하기 위해 enum 열거형을 사용한다.
//        snapshot.appendSections([100, 12, 67])
        snapshot.appendSections(Section.allCases) // 데이터 기반
        
        snapshot.appendItems([
            Product(name: "JackJack")
        ], toSection: .sub)
        
        snapshot.appendItems(list, toSection: .main)
        
        snapshot.appendItems([
            Product(name: "고래밥")
        ], toSection: .sub)
        
        
        dataSource.apply(snapshot)
    }
    
    
    // Flow -> Compositional -> List
    // 테이블뷰 시스템 기능을 컬렉션뷰로도 만들수 있어
    func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemGreen
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}

/*
 customCell + identifier + register
 
 dequeueConfiguredReusableCell
 systemCell +      X     + CellRegistration
 */

extension SimpleCollectionViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueConfiguredReusableCell(using: registraion, for: indexPath, item: list[indexPath.item])
//        
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        list.remove(at: indexPath.item)
        
        let product = Product(name: "고래밥 \(Int.random(in: 1...100))")
//        
//        list.insert(product, at: 2)
        
//        let data = list[indexPath.item]
        
        let data = dataSource.itemIdentifier(for: indexPath)
        dump(data)
        
        updateSnapShot() // apply
    }
    
}
