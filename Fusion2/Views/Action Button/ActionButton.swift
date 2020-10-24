//
//  ActionButton.swift
//  GulfBrokers
//
//  Created by Jan Švancer on 19/02/2019.
//  Copyright © 2019 CLEEVIO s.r.o. All rights reserved.
//

import UIKit

final class ActionButton: UIButton {

    // MARK: - Properties

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                Styles.normalbutton.apply(to: self)
            } else {
                Styles.disabledButton.apply(to: self)
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted && isEnabled {
                Styles.selectedButton.apply(to: self)
            } else if isEnabled {
                Styles.normalbutton.apply(to: self)
            } else {
                Styles.disabledButton.apply(to: self)
            }
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    private func setupUI() {
        Styles.normalbutton.apply(to: self)
    }

    func setArrowOnRight() {
            setImage(R.image.icArrowRightOrange(), for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            contentMode = .scaleAspectFit
            semanticContentAttribute = .forceRightToLeft
    }
}

// MARK: - Styles

extension ActionButton {
    struct Styles {
        static let normalbutton = UIViewStyle<UIButton> {
            $0.setTitleColor(Appearance.Colors.buttonFont, for: .normal)
            $0.titleLabel?.font = Appearance.font(ofSize: 16, weight: .bold)
            $0.backgroundColor = Appearance.Colors.button
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }

        static let selectedButton = Styles.normalbutton.composing {
            $0.backgroundColor = Appearance.Colors.button
            $0.layer.shadowColor = Appearance.Colors.button.cgColor
        }

        static let disabledButton = UIViewStyle<UIButton> {
            $0.setTitleColor(Appearance.Colors.whiteBackground, for: .normal)
            $0.titleLabel?.font = Appearance.font(ofSize: 16, weight: .bold)
            $0.backgroundColor = Appearance.Colors.buttonFont.withAlphaComponent(0.3)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
    }
}
