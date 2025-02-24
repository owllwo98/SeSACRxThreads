//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

enum customError: Error {
    case incorrect
}


class ViewController: UIViewController {

    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    let publishSubject = PublishSubject<Int>()
    let behaviorSubject = BehaviorSubject(value: 0)
    
    let textFieldSubject = BehaviorRelay(value: "고래밥 \(Int.random(in: 1...100))")
//    let textFieldSubject = PublishSubject<String>()
    
    let quiz = Int.random(in: 1...10)
    let a = Observable.just("a")
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        
//        bindButton()
        bindTextField()
        
//        print("quiz", quiz)
//        bindCustomObservabel()
//        randomQuiz(number: 7)
//            .bind(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
//        randomNumber()
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
    }
    
    func randomNumber() -> Observable<Int> {
        return Observable<Int>.create { value in
            
            value.onNext(Int.random(in: 1...10))
            
            return Disposables.create()
        }
    }
    
    func randomQuiz(number: Int) -> Observable<Bool> {
        
        return Observable<Bool>.create { value in
            
            if number == self.quiz {
                value.onNext(true)
//                value.onCompleted()
            } else {
                value.onNext(false)
//                value.onCompleted()
//                value.onError(customError.incorrect)
            }
            
            return Disposables.create()
            
        }
    }
    
    func play(value: Int) {
        //        let disposeBag = DisposeBag()
        
        randomQuiz(number: value)
            .subscribe(with: self) { owner, value in
                print("next", value)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .dispose()
    }
    
    func bindCustomObservabel() {
        nextButton.rx.tap
            .map { Int.random(in: 1...10) }
            .bind(with: self) { owner, value in
                print("value", value)
                
                owner.play(value: value)

            }
            .disposed(by: disposeBag)
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
                print("버튼클릭")
            }
            .debug()
            .map {
                "안녕하세요 \(Int.random(in: 1...100))"
            }
//            .share() // 하나의 subscribe 를 공유하도록
            .debug("1")
            .debug("2")
            .debug("3")
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
    
    func bindTextField() {
        // UI 처리에 특화된 Observable Trait
        // RxCoCa 의 Trait 은 ControlProperty, ControlEvent, Driver
        // 이것들은 그냥 Observable 이다
//        nicknameTextField.rx.text.orEmpty
//            .subscribe(with: self) { owner, value in
//                print(#function, value)
//                print("실시간으로 텍스트필드 달라짐")
//            } onError: { owner, error in
//                print(#function, "onError")
//            } onCompleted: { owner in
//                print(#function, "onCompleted")
//            } onDisposed: { owner in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
        
//        publishSubject
//            .subscribe(with: self) { owner, value in
//                print(#function, value)
//                print("publishSubject")
//            } onError: { owner, error in
//                print(#function, "onError")
//            } onCompleted: { owner in
//                print(#function, "onCompleted")
//            } onDisposed: { owner in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        behaviorSubject
//            .subscribe(with: self) { owner, value in
//                print(#function, value)
//                print("behaviorSubject")
//            } onError: { owner, error in
//                print(#function, "onError")
//            } onCompleted: { owner in
//                print(#function, "onCompleted")
//            } onDisposed: { owner in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
        
//        nextButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.nicknameTextField.text = "d"
//
//            }
//            .disposed(by: disposeBag)
        

//        textFieldSubject
//            .subscribe(with: self) { owner, value in
//                owner.nicknameTextField.text = value
//                print("111")
//            }
//            .disposed(by: disposeBag)
//        
//        let nextButtonTap = nextButton.rx.tap
//            .share()
//        
        nextButton.rx.tap
            .map {"\(Int.random(in: 1...100))"}
//            .bind(to: textFieldSubject)
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
//        nextButton.rx.tap
//            .withLatestFrom(nicknameTextField.rx.text.orEmpty)
//            .subscribe(with: self) { owner, value in
////                owner.textFieldSubject.onNext("d")
//    
////                let text = try! owner.textFieldSubject.value()
//                
//                print(owner.nicknameTextField.text)
////                let text = owner.textFieldSubject.value
////                print("텍스트필드 글자 가져오기", text)
//                print("텍스트필드 글자 가져오기", value)
//            }
//            .disposed(by: disposeBag)
        
        
        
            

    
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

