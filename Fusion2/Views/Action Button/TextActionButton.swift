//
//  TextActionButton.swift
//  Tipli
//
//  Created by Petr Skornok on 10/02/2020.
//  Copyright © 2020 CLEEVIO s.r.o. All rights reserved.
//

import UIKit

final class TextActionButton: UIButton {

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

    required init(titleFont: UIFont = Appearance.font(ofSize: 15, weight: .bold),
                  image: UIImage? = R.image.icArrowRightOrange()) {
        super.init(frame: .zero)

        titleLabel?.font = titleFont
        setImage(image, for: .normal)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    private func setupUI() {
        Styles.normalbutton.apply(to: self)
    }
}

// MARK: - Styles

extension TextActionButton {
    struct Styles {
        static let normalbutton = Appearance.Styles.roundedButton.composing {
            $0.titleLabel?.font = Appearance.font(ofSize: 17, weight: .regular)
            $0.setTitleColor(Appearance.Colors.gray, for: .normal)
            $0.setImage(nil, for: .normal)
        }

        static let selectedButton = Styles.normalbutton.composing {
            $0.setTitleColor(Appearance.Colors.gray4, for: .normal)
        }

        static let disabledButton = Styles.normalbutton.composing {
            $0.setTitleColor(Appearance.Colors.gray4, for: .normal)
        }
    }
}
