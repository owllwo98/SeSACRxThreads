//
//  HomeViewModel.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/20/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searhButtonTapped: ControlEvent<Void>
        
        let searchBarText: ControlProperty<String>
        
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let items: BehaviorSubject<[String]>
        let recent: Driver<[String]>
    }
    
    var items = ["jack", "Hue", "Den", "Bran"]
    var recent = ["Hoon"]
    
    func tansform(input: Input) -> Output {
        
        let itemsList = BehaviorSubject(value: items)
        
        let recentList = BehaviorRelay(value: recent)
        
        
        input.searhButtonTapped
            .withLatestFrom(input.searchBarText)
            .map {"\($0)님"}
            .asDriver(onErrorJustReturn: "손님")
            .drive(with: self, onNext: { owner, value in
                
                owner.items.append(value)
                itemsList.onNext(owner.items)
                
            })
            .disposed(by: disposeBag)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                
                owner.recent.append(value)
                recentList.accept(owner.recent)
                
            }
            .disposed(by: disposeBag)
        
        return Output(items: itemsList, recent: recentList.asDriver())
    }
    
}
