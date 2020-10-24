
import UIKit

final class PrimaryActionButton: UIButton {

   
    // MARK: - Initialization

    required init(titleFont: UIFont? = Appearance.font(ofSize: 15, weight: .bold)) {
        super.init(frame: .zero)

        titleLabel?.font = titleFont
    

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

extension PrimaryActionButton {
    struct Styles {
        static let normalbutton = Appearance.Styles.rightSideImageButton.composing {
            $0.backgroundColor = Appearance.Colors.accentBackground
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.layer.shadowColor = $0.backgroundColor?.cgColor
            $0.adjustsImageWhenHighlighted = false
            $0.adjustsImageWhenDisabled = false
            $0.contentEdgeInsets.left = 15
            $0.contentEdgeInsets.right = 15
        }

        static let selectedButton = Styles.normalbutton.composing {
            $0.backgroundColor = .blue
        }

        static let disabledButton = Styles.normalbutton.composing {
            $0.backgroundColor = .red
            $0.setTitleColor(Appearance.Colors.whiteBackground, for: .normal)
        }
    }
}
