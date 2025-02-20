//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 변정훈 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    struct Input {
        // 버튼 클릭
        let tap: ControlEvent<Void>
        // 텍스트필드 글자
        let text: ControlProperty<String>
    }
    
    struct Output {
        // 버튼 클릭
        let tap: ControlEvent<Void>
        // 버튼 텍스트
        let text: Observable<String>
        // 버튼 유효성
        let validation: Observable<Bool>
    }
    
    init() {
        print("")
    }
    
    func transform(input: Input) -> Output {
        
        let buttonText = Observable.just("연락처는 8자 이상")
        
        let validation = input.text
            .map { $0.count >= 8 }
        
        return Output(tap: input.tap,
                      text: buttonText, 
                      validation: validation)
    }
    
}
