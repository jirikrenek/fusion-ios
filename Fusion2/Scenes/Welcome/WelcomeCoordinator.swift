
import UIKit
import RxSwift

final class WelcomeCoordinator: BaseCoordinator<Void> {

    typealias Dependencies = AllDependencies

    private let window: UIWindow
    private let dependencies: Dependencies

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    // swiftlint:disable function_body_length
    override func start() -> Observable<CoordinationResult> {
        let viewController = WelcomeViewController.create()
        let navigationController = SwipeNavigationController(rootViewController: viewController)
        let viewModel = viewController.attach(wrapper: ViewModelWrapper<WelcomeViewModel>(dependencies))
        
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let signInResult = viewModel
            .signInButtonTapped
            .asObservable()
            .flatMap { [weak self, weak navigationController] _ -> Observable<SignInCoordinatorResult> in
                guard let self = self, let navigationController = navigationController else {
                    return .empty()
                }
                
                print(1)

                return self.showSignIn(on: navigationController, animated: true)
            }
            .filter({
                if case .signIn = $0 {
                    return true
                } else {
                    return false
                }
            })
            .asVoid
        
        /*
        window.tap {
            $0.rootViewController = navigationController
            $0.makeKeyAndVisible()
        }
 */
  
        return Observable.merge(signInResult)
            .take(1)
    }

    
    private func showSignIn(on navigationController: UINavigationController, animated: Bool) -> Observable<SignInCoordinatorResult> {
        let coordinator = SignInCoordinator(navigationController: navigationController, dependencies: dependencies, animated: animated)
        return coordinate(to: coordinator)
    }
}
