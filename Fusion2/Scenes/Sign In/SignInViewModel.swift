
import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

final class SignInViewModel: ViewModelType {

    // MARK: - ViewModelType
    typealias Dependency = HasAuthenticationManager

    struct Bindings {
        let backTap: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
        let signInTap: Driver<Void>
        let forgotPasswordButtonTap: Driver<Void>
    }

    // MARK: - Variables
    private(set) var isValid: Bool!
    private let dependency: Dependency

    private let activityIndicator = RxActivityIndicator()
    private let errorTracker = RxErrorTracker()

    let loading: Driver<Bool>
    let errors: Driver<Error>

    // MARK: - Actions
    private(set) var viewDismissed: Driver<Void>!
    private(set) var signInEnabled: Driver<Bool>!
    private(set) var forgotPasswordButtonTapped: Driver<Void>!

    // MARK: - Initialization
    let disposeBag = DisposeBag()

    init(dependency: Dependency, bindings: Bindings) {
        self.dependency = dependency

        loading = activityIndicator.asDriver()
        errors = errorTracker.asDriver()

        setupDataUpdates(dependency: dependency, bindings: bindings)
        setupUserActions(bindings: bindings)
        setupActions(dependency: dependency, bindings: bindings)
    }

    private func setupDataUpdates(dependency: Dependency, bindings: Bindings) {
        signInEnabled = Driver.combineLatest(bindings.email, bindings.password)
            .map { email, password in
                 email.isValidEmail && !password.isEmpty
            }
            .do(onNext: { [unowned self] in self.isValid = $0 })
    }

    private func setupUserActions(bindings: Bindings) {
        let formInputs = Driver.combineLatest(bindings.email, bindings.password)

        bindings.signInTap
        .withLatestFrom(signInEnabled)
        .filter { signInEnabled -> Bool in
            signInEnabled == true
        }
        //.withLatestFrom(formInputs)
        //.flatMapLatest { [unowned self] data in
          //      self.dependency.userService.handleSignIn(username: data.0, password: data.1)
            //    .trackActivity(self.activityIndicator)
              //  .trackError(self.errorTracker)
                //.asDriverFilterNil()
        //}
        .asObservable()
        .subscribe()
        .disposed(by: disposeBag)
    }

    private func setupActions(dependency: Dependency, bindings: Bindings) {
        viewDismissed = bindings.backTap
        forgotPasswordButtonTapped = bindings.forgotPasswordButtonTap
    }
}
