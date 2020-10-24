//
//  RxErrorTracker.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//
//
//  From:
//  https://github.com/sergdort/CleanArchitectureRxSwift
//  Copyright © 2017 Sergey Shulga. All rights reserved.
//

import RxSwift
import RxCocoa

final class RxErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy

    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: RxErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
