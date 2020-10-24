//
//  String+Extensions.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import UIKit

extension String {

    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    var flagFromCode: String {
        let base : UInt32 = 127397
        var flag = ""

        unicodeScalars.forEach { scalar in
            flag.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }

        return String(flag)
    }

    func setAsLink(textToFind: String, linkURL: String, underline: Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let foundRange = attributedString.mutableString.range(of: textToFind)

        if foundRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: linkURL, range: foundRange)
            if underline == true {
                attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue], range: foundRange)
            }
        }

        return attributedString
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                        options: .usesLineFragmentOrigin,
                                        attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSMutableAttributedString {
    func setAsLink(textToFind: String, linkURL: String, underline: Bool = false) {
        let foundRange = self.mutableString.range(of: textToFind)

        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            if underline == true {
                self.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue], range: foundRange)
            }
        }
    }
}

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

