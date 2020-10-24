//
//  Appearance.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import UIKit

struct Appearance {

    // MARK: - Global

    static let barButtonAttributes = [
        NSAttributedString.Key.font: Appearance.font(ofSize: 17, weight: .semibold),
    ]

    // MARK: - Fonts

    static func font(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    // MARK: - Colors

    struct Colors {
        static let mainTint = UIColor(hexString: "#FE8A00")
        static let blue = UIColor.blue

        static let whiteBackground = UIColor(hexString: "#FFFFFF")
        static let accentBackground = UIColor(hexString: "#E0189C")
        static let darkTint = UIColor(hexString: "#E49407")
        static let lightText = UIColor(hexString: "#A0A0A0")

        static let button = UIColor(hexString: "#FFF5F0")
        static let buttonFont = UIColor(hexString: "#FE8A00")
        
        static let blackLabel = UIColor(hexString: "#000000")
        static let subtitleGrey = UIColor(hexString: "#848484")

        static let disabledLabelText = UIColor(named: "#000000")?.withAlphaComponent(0.5)

        static let borderBackground = UIColor(named: "#D2D2D2")
       
    }

    // MARK: - Styles

    struct Styles {
        static let mainView = UIViewStyle<UIView> {
            $0.backgroundColor = Colors.whiteBackground
        }

        
        static let collectionView = UIViewStyle<UICollectionView> {
            $0.backgroundColor = Appearance.Colors.whiteBackground
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }

        static let oneLineAdjustableLabel = UIViewStyle<UILabel> {
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.7
        }

        static let infinityLinesAdjustableLabel = UIViewStyle<UILabel> {
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.7
        }

        static let activeSeparatorView = UIViewStyle<UIView> {
            $0.backgroundColor = Colors.mainTint
        }

  

        static let roundedButton = UIViewStyle<UIButton> {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }

        static let leftSideImageButton = Appearance.Styles.roundedButton.composing {
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }

        static let rightSideImageButton = Appearance.Styles.roundedButton.composing {
            $0.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            $0.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            $0.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 15)
            $0.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15 + 8, bottom: 9, right: 15)
        }


     
    }
}
