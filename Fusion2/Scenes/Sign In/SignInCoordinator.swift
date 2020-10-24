
import UIKit
import RxSwift

enum SignInCoordinatorResult {
    case signIn
    case dismiss(animated: Bool)
}

final class SignInCoordinator: BaseCoordinator<SignInCoordinatorResult> {

    typealias Dependencies = AllDependencies

    private let navigationController: UINavigationController
    private let dependencies: Dependencies
    private let animated: Bool

    init(navigationController: UINavigationController, dependencies: Dependencies, animated: Bool = true) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.animated = animated
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = SignInViewController.create()
        let viewModel = viewController.attach(wrapper: ViewModelWrapper<SignInViewModel>(dependencies as! SignInViewModel.Dependency))

        navigationController.pushViewController(viewController, animated: self.animated)

        let viewDismissed = viewModel.viewDismissed.asObservable().map { [unowned self] _ in
            SignInCoordinatorResult.dismiss(animated: self.animated)
        }

        /*
        let signIn = dependencies
            .authenticationManager
            .authenticationState
            .asObservable()
            .filter { state -> Bool in
                state == .signedIn
            }.map { _ in
                SignInCoordinatorResult.signIn
            }
        

        viewModel.forgotPasswordButtonTapped
        .asObservable()
        .flatMap { [weak self, weak viewController] _ -> Observable<ModalCoordinationResult<Void>> in
            guard let self = self, let viewController = viewController else {
                return .empty()
            }

            return self.showForgotPassword(on: viewController, animated: true)
        }.subscribe()
        .disposed(by: disposeBag)
         */

        return Observable.never()
        /*
        return Observable.merge(viewDismissed, signIn)
            .take(1)
            .do(onNext: { [weak self] result in
                switch result {
                case .dismiss(let animated):
                    self?.navigationController.popViewController(animated: animated)

                case .signIn:
                    break
                }
            })
 */
    }
}

extension SignInCoordinator {
    private func showForgotPassword(on viewController: UIViewController, animated: Bool) -> Observable<ModalCoordinationResult<Void>> {
        //let coordinator = LostPasswordCoordinator(rootViewController: viewController, dependencies: dependencies, animated: animated)
        //return coordinate(to: coordinator)
        return Observable.never()
    }
}
