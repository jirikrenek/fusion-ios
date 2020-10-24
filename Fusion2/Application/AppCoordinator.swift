
import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {

    
    private let navigationController: UINavigationController
    private let dependencies: AppDependency
    private let window: UIWindow

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        self.dependencies = AppDependency()
    }

    override func start() -> Observable<Void> {
        let coordinator = WelcomeCoordinator(window: window, dependencies: dependencies)
        navigationController.pushViewController(WelcomeViewController(), animated: false)
        self.navigationController.navigationBar.isHidden = true
        coordinate(to: coordinator)
        return Observable.never()
    }


}
