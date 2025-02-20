//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let password = BehaviorSubject(value: "1234")
    
    var disposeBag = DisposeBag()
    
    // Scheduler: 어떤 Thread 에 돌릴지
    let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    deinit {
        // self 캡쳐로 인해서 deinit 이 되지않고 인스턴스가 남아있음
        // Deinit 이 될 때 구독이 정상적으로 해제된다.
        // -> 왜 VC 가 Deinit 되면 dispose 가 될까?
        print("password Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        bind()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)d
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag()
        }
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func bind() {
        
//        let incrementValue = timer
//            .subscribe(with: self) { owner, value in
//                print("Timer", value) // next
//            } onError: { owner, error in
//                print("Timer Error")
//            } onCompleted: { owner in
//                print("Timer onCompleted")
//            } onDisposed: { owner in
//                print("Timer onDisposed")
//            }
        
        timer
            .subscribe(with: self) { owner, value in
                print("Timer", value) // next
            } onError: { owner, error in
                print("Timer Error")
            } onCompleted: { owner in
                print("Timer onCompleted")
            } onDisposed: { owner in
                print("Timer onDisposed")
            }.disposed(by: disposeBag)
        
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("버튼 클릭")
                
                let random = ["c", "da", "ffsa", "132"]
                owner.passwordTextField.text = random.randomElement()!
                
//                incrementValue.dispose()
                
                // 옵저버블은 이벤트 전달만 함
                // 이벤트를 받을 수 없음
                owner.password.onNext("8888")
                
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
                
            }.disposed(by: disposeBag)
        
        // 구독 해제하는 시점을 수동으로 조절
       

    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
