
import UIKit

protocol ViewModelAttaching: class {
    associatedtype ViewModel: ViewModelType

    var bindings: ViewModel.Bindings { get }
    var viewModel: ViewModel! { get set }

    func attach(wrapper: ViewModelWrapper<ViewModel>) -> ViewModel
    func setupUI()
    func arrangeSubviews()
    func layout()
    func setupBindings(viewModel: ViewModel)

    static func create() -> Self
}

extension ViewModelAttaching where Self: UIViewController {

    @discardableResult
    func attach(wrapper: ViewModelWrapper<ViewModel>) -> ViewModel {
        print("attach")
        viewModel = wrapper.bind(bindings)
        loadViewIfNeeded()
        setupUI()
        arrangeSubviews()
        layout()
        setupBindings(viewModel: viewModel)
        return viewModel
    }

    func arrangeSubviews() {}

    func layout() {}

    func setupBindings(viewModel: ViewModel) {}

    static func create() -> Self {
        return self.init()
    }
}
