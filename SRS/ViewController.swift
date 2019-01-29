//
//  ViewController.swift
//  SRS
//
//  Created by Nguyễn Thanh Trí on 1/25/19.
//  Copyright © 2019 TriNguyen. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.runRx()
    }
}

extension ViewController {
    func example(of description: String, action: () -> Void) {
        print("\n--- Example of:", description, "---")
        action()
    }
    
    func runRx() {
//        example(of: "just, of, from") {
//            let one = 1
//            let two = 2
//            let three = 3
//            let arr = [1,2,3,4,5]
//
//            let obs1 = Observable<Int>.just(one)
//            let obs2 = Observable.of(one, two, three)
//            let obs3 = Observable.of([one, two, three])
//            let obs4 = Observable.from([one, two, three])
//        }
        
        // **************************** OBSERVABLES *********************************
        
        
        example(of: "subscribe") {
            let one = 1
            let two = 2
            let three = 3
            let obs = Observable.of(one, two, three)
            
            obs.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        }
        
        
        example(of: "empty") {
            let observable = Observable<Void>.empty()
            observable.subscribe(onNext: {
                print($0)
            }, onCompleted: {
                print("empty: complete")
            }).disposed(by: disposeBag)
        }
        
        
        example(of: "never") {
            let observable = Observable<Any>.never()
            
            observable.subscribe(onNext: {
                print($0)
            }, onCompleted: {
                print("never: complete")
            }).disposed(by: disposeBag)
        }
        
        
        example(of: "range") {
            let observable = Observable<Int>.range(start: 1, count: 10)
            observable.subscribe(onNext: { i in
                let n = Double(i)
                let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
                print(fibonacci)
            }).disposed(by: disposeBag)
        }
        
        
        example(of: "create") {
            Observable<String>.create { observer in
                // 1
                observer.onNext("1")
                // 2
                observer.onCompleted()
                // 3
                observer.onNext("?")
                // 4
                return Disposables.create()
                }.subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("Completed") },
                    onDisposed: { print("Disposed") }
                )
                .disposed(by: disposeBag)
        }
        
        
        
        
        // **************************** SUBJECTS *********************************
        
        example(of: "PublishSubject") {
            let subject = PublishSubject<String>()
            subject.onNext("Is anyone listening?")
            let subscription1 = subject.subscribe(onNext: { string in
                print(string)
            })
            subject.on(.next("1"))
            subject.onNext("2")
            
            let subscription2 = subject.subscribe { event in
                print("2)", event.element ?? event)
            }
            
            subject.onNext("3")
            
            subscription1.dispose()
            subject.onNext("4")
            
            subject.onCompleted()
            subject.onNext("5")
            subscription2.dispose()
            subject
                .subscribe {
                    print("3)", $0.element ?? $0)
                }
                .disposed(by: disposeBag)
            subject.onNext("?")
        }
        
        
        example(of: "BehaviorSubject") {
            let subject = BehaviorSubject(value: "Initial value")
            subject.subscribe {
                print("1)", $0)
            }.disposed(by: disposeBag)
            
            subject.onNext("X")
            subject.onError(MyError.anError)
            
            subject.subscribe {
                print("2)", $0)
            }
            .disposed(by: disposeBag)
        }
        
        
        example(of: "ReplaySubject") {
            // 1
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            // 2
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
            // 3
            subject.subscribe {
                print("1)", $0)
            }.disposed(by: disposeBag)
            
            subject.subscribe {
                print( "2)", $0)
            }.disposed(by: disposeBag)
            
            subject.onNext("4")
            subject.subscribe {
                print("3)", $0)
            }
            .disposed(by: disposeBag)
        }
        
        
        example(of: "Variable") {
            let variable = Variable("Initial value")
            
            variable.value = "New initial value"
            
            variable.asObservable().subscribe {
                print("1)",$0)
            }
            .disposed(by: disposeBag)
            
            variable.value = "1"
            variable.asObservable().subscribe {
                print("2)", $0)
            }.disposed(by: disposeBag)
            variable.value = "2"
            
        }
        
    }
}


enum MyError: Error {
    case anError
}
