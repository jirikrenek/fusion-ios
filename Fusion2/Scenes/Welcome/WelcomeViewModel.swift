import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewModel: ViewModelType {

    
    typealias Dependency = HasAuthenticationManager
    
    struct Bindings {
        let signInButtonTap: Driver<Void>
        let signUpButtonTap: Driver<Void>
    }
    
    private let activityIndicator = RxActivityIndicator()
    private let errorTracker = RxErrorTracker()
    
    let loading: Driver<Bool>
    let errors: Driver<Error>
    
    
    // MARK: - Actions
    private(set) var signInButtonTapped: Driver<Void>!
    private(set) var signUpButtonTapped: Driver<Void>!
    
    // MARK: - Initialization
    let disposeBag = DisposeBag()

    init(dependency: Dependency, bindings: Bindings) {
        loading = activityIndicator.asDriver()
        errors = errorTracker.asDriver()


        setupActions(dependency: dependency, bindings: bindings)
    }
    private func setupActions(dependency: Dependency, bindings: Bindings) {
        signInButtonTapped = bindings.signInButtonTap
        signUpButtonTapped = bindings.signUpButtonTap
    }
}
