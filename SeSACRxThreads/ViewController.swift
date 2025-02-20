//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        
        bindButton()
    }
    
    // subscribe : onNext, onError, onComplete, onDisposed / onNext 에서 항상 Main Thread 보장 X 이전 스트림 영향 받음
    // bind: onNext 에서 항상 Main Thread 보장 X 이전 스트림 영향 받음
    // drive: Main Thread 실행을 보장, 스트림 공유, UI 처리에 특화
    func bindButton() {
//        
//        nextButton.rx.tap
//            .subscribe(with: self) { onwer, _ in
//                print(#function, "클릭")
//            } onError: { onwer, error in
//                print(#function, "onError")
//            } onCompleted: { onwer in
//                print(#function, "onCompleted")
//            } onDisposed: { onwer in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
        
        // 버튼 -> 서버통신 (비동기) -> UI 업데이트 (main)
//        nextButton.rx.tap
//            .map {
//                print(Thread.isMainThread)
//            }
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
//            .map {
//                print(Thread.isMainThread)
//            }
//            .observe(on: MainScheduler.instance)
//            .bind(with: self) { owner, _ in
//                print(Thread.isMainThread)
//            }
//            .disposed(by: disposeBag)
//
//        
        
        
        let button = nextButton.rx.tap
            .map {
                "안녕하세요 \(Int.random(in: 1...100))"
            }
//            .share() // 하나의 subscribe 를 공유하도록
            .asDriver(onErrorJustReturn: "") // drive 는 내부에 share 를 갖고있다
        
        button
            .drive(navigationItem.rx.title)
//            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        button
            .drive(nextButton.rx.title())
//            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        button
            .drive(nicknameTextField.rx.text)
//            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        

        
    }


    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        view.backgroundColor = .white
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

