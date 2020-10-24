//
//  Coordinator.swift
//  Fusion2
//
//  Created by Jiří Křenek on 21/10/2020.
//

import Foundation
import RxSwift

enum PushCoordinationResult<T> {
    case popped
    case dismiss
    case finished(T)
}

enum ModalCoordinationResult<T> {
    case dismissed
    case dismiss
    case finished(T)
}

protocol Coordinator {
    associatedtype CoordinationResult

    var identifier: UUID { get }

    func start() -> Observable<CoordinationResult>
}
