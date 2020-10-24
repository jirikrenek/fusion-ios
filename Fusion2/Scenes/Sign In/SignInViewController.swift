
import UIKit
import RxSwift
import RxCocoa
import JVFloatLabeledTextField

final class SignInViewController: RxViewController, ViewModelAttaching {

    var viewModel: SignInViewModel!
    var bindings: SignInViewModel.Bindings {
        let nextButtonOnPasswordTap = passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver()

        return SignInViewModel.Bindings(
            backTap: backBarButtonItem.rx.tap.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            signInTap: Driver.merge(signInButton.rx.tap.asDriver(), nextButtonOnPasswordTap),
            forgotPasswordButtonTap: forgotPasswordButton.rx.tap.asDriver()
        )
    }

    // MARK: - UI

    //private let backBarButtonItem = UIBarButtonItem(image: Constants.Icons.arrowBack, style: .plain, target: nil, action: nil)
    private let backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    internal let scrollView = UIScrollView()
    private let contentView = UIView()
    private let logoImageView = UIImageView()
    private let emailTextField = InputTextField()
    private let passwordTextField = InputTextField(type: .password)
    private let forgotPasswordButton = UIButton()
    private let signInButton = PrimaryActionButton()

    // MARK: - Properties

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        emailTextField.text = "mobile-test@example.com"
        passwordTextField.text = "123456"
        emailTextField.sendActions(for: .valueChanged)
        passwordTextField.sendActions(for: .valueChanged)
        #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailTextField.becomeFirstResponder()
    }

    func setupUI() {
        view.backgroundColor = Appearance.Colors.whiteBackground
        //logoImageView.image = R.image.logo()
//        emailTextField.setPlaceholder(tr(L.signEmailPlaceholder), floatingTitle: tr(L.signEmailPlaceholder).uppercased())

  //      passwordTextField.setPlaceholder(tr(L.signPasswordPlaceholder), floatingTitle: tr(L.signPasswordPlaceholder).uppercased())
    //    signInButton.setTitle(tr(L.signInButton), for: .normal)

      //  forgotPasswordButton.setTitle(tr(L.introForgotPassword), for: .normal)

        Styles.logoImage.apply(to: logoImageView)
        Styles.emailTextField.apply(to: emailTextField)
        Styles.passwordTextField.apply(to: passwordTextField)
        Styles.forgotPasswordButton.apply(to: forgotPasswordButton)
    }

    override func setupNavigationBar() {
//        navigationItem.title = tr(L.introLogin)
    }

    func arrangeSubviews() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(signInButton)

        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }

    func layout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
            make.leading.equalTo(view.safeArea.leading)
            make.trailing.equalTo(view.safeArea.trailing)
        }

        contentView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().priority(250)
        }

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(98)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeArea.top).offset(24)
        }

        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalTo(view.safeArea.leading).offset(16)
            make.trailing.equalTo(view.safeArea.trailing).offset(-16)
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(16)
        }
    }

    override func setupVisibleBindings(for visibleDisposeBag: DisposeBag) {
        super.setupVisibleBindings(for: visibleDisposeBag)

        viewModel.signInEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: visibleDisposeBag)

        viewModel.loading
            .drive(self.rx.activityIndicator)
            .disposed(by: visibleDisposeBag)

        viewModel.errors
            .drive(self.rx.errors)
            .disposed(by: visibleDisposeBag)

        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: visibleDisposeBag)
    }

}

// MARK: - Styles

extension SignInViewController {
    struct Styles {
        static let logoImage = UIViewStyle<UIImageView> {
            $0.contentMode = .scaleAspectFit
        }

        static let emailTextField = UIViewStyle<JVFloatLabeledTextField> {
            $0.keyboardType = .emailAddress
            $0.returnKeyType = .next
            $0.autocapitalizationType = .none
        }

        static let passwordTextField = UIViewStyle<JVFloatLabeledTextField> {
            $0.returnKeyType = .done
        }

        static let forgotPasswordButton = UIViewStyle<UIButton> {
            $0.setTitleColor(Appearance.Colors.buttonFont, for: .normal)
            $0.titleLabel?.font = Appearance.font(ofSize: 13, weight: .bold)
        }

        static let stackView = UIViewStyle<UIStackView> {
            $0.axis = .vertical
            $0.spacing = 8.0
        }
    }
}

// MARK: - Create

extension SignInViewController {
    static func create() -> SignInViewController {
        return SignInViewController()
    }
}
