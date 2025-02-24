//
//  NewSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/24/25.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa

final class NewSearchViewModel {
    
    struct Input {
        let searchBarTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    
    struct  Output {
        let list: Observable<[String]>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let list = Observable.just(["가", "나", "다"])
        
        input.searchBarTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let text = Int($0) else {
                    return 20250223
                }
                
                return text
            }
            .map { return "\($0)" }
//            .map {
//                // 네트워크 통신
//            }
            .subscribe(with: self) { owner, value in
                print("next",value)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
        
        return Output(list: list)
    }
    
}
