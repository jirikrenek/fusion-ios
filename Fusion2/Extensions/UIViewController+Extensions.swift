import UIKit

// MARK: - Activity indicator

enum ActivityIndicatorTheme {
    case dark
    case light
}

extension UIViewController {
    var activityIndicatorTag: Int { return 999_999 }
    var activityBackgroundViewTag: Int { return 999_995 }

    func startActivity(aboveNavigationController: Bool = false, theme: ActivityIndicatorTheme = .light) {
        var view: UIView = self.view
        view.endEditing(true)

        if aboveNavigationController, let navigationView = self.navigationController?.view {
            view = navigationView
        }

        if self.navigationController?.view.viewWithTag(activityBackgroundViewTag) != nil {
            self.stopActivity()
        }

        if self.view.viewWithTag(activityBackgroundViewTag) != nil {
            self.stopActivity()
        }

        DispatchQueue.main.async(execute: {
            // Transparent black view cover
            let activityBackgroundView = UIView(frame: CGRect.zero)
            let activityIndicator = UIActivityIndicatorView()

            activityBackgroundView.tag = self.activityBackgroundViewTag

            switch theme {
            case .light:
                activityBackgroundView.backgroundColor = UIColor.clear
                activityIndicator.style = .gray
            case .dark:
                activityBackgroundView.alpha = 0.75
                activityBackgroundView.backgroundColor = UIColor.black
                activityIndicator.style = .whiteLarge
            }
            view.addSubview(activityBackgroundView)

            activityBackgroundView.snp.makeConstraints { make in
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.top.equalTo(view)
                make.bottom.equalTo(view)
            }

            // Loading spinner
            activityIndicator.startAnimating()
            activityIndicator.tag = self.activityIndicatorTag
            activityBackgroundView.addSubview(activityIndicator)

            activityIndicator.snp.makeConstraints { make in
                make.center.equalTo(activityBackgroundView.snp.center)
            }
        })
    }

    func stopActivity(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async(execute: {
            if let activityBackgroundView = self.view.subviews.first(where: { $0.tag == self.activityBackgroundViewTag }) {
                UIView.animate(withDuration: 0.2, animations: {
                    activityBackgroundView.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        activityBackgroundView.removeFromSuperview()
                    }
                })
            }
        })

        DispatchQueue.main.async(execute: {
            if let activityBackgroundView = self.navigationController?.view.subviews.first(where: { $0.tag == self.activityBackgroundViewTag }) {
                UIView.animate(withDuration: 0.2, animations: {
                    activityBackgroundView.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        activityBackgroundView.removeFromSuperview()
                    }
                })
            }
        })

        DispatchQueue.main.async(execute: {
            if let loadingImageView = self.view.subviews.first(where: { $0.tag == self.activityIndicatorTag }) as? UIImageView {
                UIView.animate(withDuration: 0.2, animations: {
                    loadingImageView.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        loadingImageView.removeFromSuperview()
                        if let completion = completion {
                            completion()
                        }
                    }
                })
            }

            if let loadingImageView = self.navigationController?.view.subviews.first(where: { $0.tag == self.activityIndicatorTag }) as? UIImageView {
                UIView.animate(withDuration: 0.2, animations: {
                    loadingImageView.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        loadingImageView.removeFromSuperview()
                        if let completion = completion {
                            completion()
                        }
                    }
                })
            }
        })
    }
}

// MARK: - TabBar

extension UIViewController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: { [weak self] in
                    self?.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                }, completion: nil)
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
}
