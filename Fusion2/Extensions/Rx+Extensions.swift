

import Foundation
import WebKit
import UserNotifications
import CoreLocation
import RxSwift
import RxCocoa

// Originally from here:
// https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// Credit to Artsy and @ashfurrow
public protocol _OptionalType {
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: _OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

// Some code originally from here:
// https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L42-L62
// Credit to Artsy and @ashfurrow
public extension ObservableType where Element: _OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: _OptionalType {
    public func filterNil() -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return Driver<Element.Wrapped>.empty()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
}

extension SharedSequence {
    var asVoid: SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

    var asOptional: SharedSequence<SharingStrategy, Element?> {
        return map { value -> Element? in value }
    }

    func withPrevious(startWith first: Element) -> SharedSequence<SharingStrategy, (Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}

extension PrimitiveSequence where Trait == SingleTrait {

    var asVoid: PrimitiveSequence<Trait, Void> {
        return map { _ in }
    }

    var asOptional: PrimitiveSequence<Trait, Element?> {
        return map { value -> Element? in value }
    }

    func catchErrorJustReturnNil() -> PrimitiveSequence<Trait, Element?> {
        return asOptional.catchErrorJustReturn(nil)
    }
}

extension ObservableType {
    var asVoid: RxSwift.Observable<Void> {
        return map { _ in }
    }

    var asOptional: RxSwift.Observable<Element?> {
        return map { value -> Element? in value }
    }

    func catchErrorJustReturnNil() -> Observable<Element?> {
        return asOptional.catchErrorJustReturn(nil)
    }

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            Driver.empty()
        }
    }

    func asDriverOnErrorJustReturnNil() -> Driver<Element?> {
        return asOptional.asDriver(onErrorJustReturn: nil)
    }

    func asDriverFilterNil() -> Driver<Element> {
        return asDriverOnErrorJustReturnNil().filterNil()
    }

    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return map(!)
    }
}

extension SharedSequenceConvertibleType where Element == Bool {
    /// Boolean not operator.
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return map(!)
    }
}

extension Reactive where Base: UIViewController {

    public var activityIndicator: Binder<Bool> {
        return Binder(self.base) { viewController, isActive in
            isActive ? viewController.startActivity() : viewController.stopActivity()
        }
    }

    public var errors: Binder<Error> {
        return Binder(self.base) { viewController, error in
//            log.info("‼️ ERROR: \((error as NSError).debugDescription) ‼️")
           // viewController.handleError(error: error)
        }
    }
}

// MARK: - TableView

extension Reactive where Base: UITableView {
    public var reloadData: Binder<Void> {
        return Binder(self.base) { tableView, _ in
            tableView.reloadData()
        }
    }

    public var footerActivityIndicator: Binder<Bool> {
        return Binder(self.base) { tableView, isActive in
//            isActive ? tableView.showLoadingFooter() : tableView.hideLoadingFooter()
        }
    }
}

// MARK: - UserNotifcations

extension UNUserNotificationCenter {

    static var authorizationStatus: Observable<UNAuthorizationStatus> {
        return Observable.create { observer in
            current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                observer.onNext(settings.authorizationStatus)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

    static var isAuthorized: Observable<Bool> {
        return Observable.create { observer in
            current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                if settings.authorizationStatus == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
}

// MARK: - CoreLocations

extension CLLocationManager {

    static var authorizationStatus: Observable<CLAuthorizationStatus> {
        return Observable.create { observer in
            if CLLocationManager.locationServicesEnabled() {
                observer.onNext(CLLocationManager.authorizationStatus())
                observer.onCompleted()
            } else {
                observer.onNext(.denied)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension UIPresentationController: HasDelegate {
    public typealias Delegate = UIAdaptivePresentationControllerDelegate
}

class UIViewControllerAdaptivePresentationDelegateProxy: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate>, DelegateProxyType, UIAdaptivePresentationControllerDelegate {

    weak private(set) var presentationController: UIPresentationController?

    init(presentationController: ParentObject) {
        self.presentationController = presentationController
        super.init(parentObject: presentationController, delegateProxy: UIViewControllerAdaptivePresentationDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { UIViewControllerAdaptivePresentationDelegateProxy(presentationController: $0) }
    }
}

extension Reactive where Base: UIPresentationController {
    var delegate: UIViewControllerAdaptivePresentationDelegateProxy {
        return UIViewControllerAdaptivePresentationDelegateProxy.proxy(for: base)
    }

    @available(iOS 13.0, *)
    var presentationControllerShouldDismiss: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIAdaptivePresentationControllerDelegate.presentationControllerShouldDismiss(_:)))
            .asVoid
    }

    @available(iOS 13.0, *)
    var presentationControllerWillDismiss: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIAdaptivePresentationControllerDelegate.presentationControllerWillDismiss(_:)))
            .asVoid
    }

    @available(iOS 13.0, *)
    var presentationControllerDidDismiss: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIAdaptivePresentationControllerDelegate.presentationControllerDidDismiss(_:)))
            .asVoid
    }

    @available(iOS 13.0, *)
    var presentationControllerDidAttemptToDismiss: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIAdaptivePresentationControllerDelegate.presentationControllerDidAttemptToDismiss(_:)))
            .asVoid
    }
}

// MARK: - WKWebView
// Some code originally from here:
// https://github.com/RxSwiftCommunity/RxWebKit/blob/master/RxWebKit/Sources/Rx%2BWebKit.swift#L49-L60
// Credit RxSwift Community

extension Reactive where Base: WKWebView {

    var canGoBack: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }
    
    var canGoForward: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }

}
