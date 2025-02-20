//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextTap: ControlEvent<Void>
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let year = BehaviorRelay(value: 2025)
        let month = BehaviorRelay(value: 2)
        let day = BehaviorRelay(value: 19)
        
        input.birthday
            .bind(with: self) { owner, value in
                let componet = Calendar.current.dateComponents([.year, .month, .day], from: value)
                
                year.accept(componet.year!)
                month.accept(componet.month!)
                day.accept(componet.day!)
                
            }
            .disposed(by: disposeBag)
        
        return Output(nextTap: input.nextTap, year: year, month: month, day: day)
    }
    
}
