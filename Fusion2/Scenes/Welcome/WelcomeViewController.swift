//
//  HomepageViewController.swift
//  Fusion2
//
//  Created by Jiří Křenek on 21/10/2020.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class WelcomeViewController: RxViewController, ViewModelAttaching {
    

    //var bindings: WelcomeViewModel.Bin
    var viewModel: WelcomeViewModel!
    var bindings: WelcomeViewModel.Bindings {
        return WelcomeViewModel.Bindings(
            signInButtonTap: signInButton.rx.tap.asDriver(),
            signUpButtonTap: signUpButton.rx.tap.asDriver()
        )
    }
    
    private var titleLabel = UILabel()
    private let logoImageView = UIImageView()
    private let signInButton = PrimaryActionButton()
    private let signUpButton = PrimaryActionButton()
    //private let signInbuttonsStackView = UIStackView()
    
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setupUI()
        //arrangeSubviews()
        //layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    func setupUI()
    {
        print("setup ui")
        view.backgroundColor = .white
        
        titleLabel.text = "label test"
        titleLabel.textColor = .red

        logoImageView.image = UIImage(named: "blackLogo")
       
        signInButton.setTitle("Sign in with email", for: .normal)
        signInButton.tag = 1
        signUpButton.setTitle("Create a new account", for: .normal)
        signUpButton.tag = 2
        
        //Styles.horizontalStackView.apply(to: buttonsStackView)
    }
    
    func arrangeSubviews() {
        print("arange subviews")
        //buttonsStackView.addArrangedSubview(signInButton)
        //buttonsStackView.addArrangedSubview(signUpButton)
        
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        //ew.addSubview(buttonsStackView)
    }
    
    func layout() {
        print("layout")
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(29)
        }
        
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            
            make.bottom.equalTo(logoImageView.snp.bottom).offset(150)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            
            make.bottom.equalTo(signInButton.snp.bottom).offset(75)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        
        }
    }
    
    override func setupVisibleBindings(for visibleDisposeBag: DisposeBag) {
        super.setupVisibleBindings(for: visibleDisposeBag)

        /*
        viewModel.loading
            .drive(self.rx.activityIndicator)
            .disposed(by: visibleDisposeBag)

        viewModel.errors
            .drive(self.rx.errors)
            .disposed(by: visibleDisposeBag)
 */
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Styles

extension WelcomeViewController {
    struct Styles {

        static let titleText = UIViewStyle<UILabel> {
            $0.textAlignment = .center
            //$0.font = Appearance.font(ofSize: 20, weight: .bold)
            $0.numberOfLines = 3
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.7
        }

        static let horizontalStackView = UIViewStyle<UIStackView> {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 4.0
        }

        static let verticalStackView = UIViewStyle<UIStackView> {
            $0.axis = .vertical
            $0.spacing = 8.0
        }
    }

}

// MARK: - Create

extension WelcomeViewController {
    static func create() -> WelcomeViewController {
        return WelcomeViewController()
    }
}


