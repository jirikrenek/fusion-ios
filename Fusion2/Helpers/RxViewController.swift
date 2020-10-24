//
//  RxViewController.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxViewController: UIViewController {

    let disposeBag = DisposeBag()
    private(set) var visibleDisposeBag: DisposeBag!

    override func viewWillAppear(_ animated: Bool) {
        visibleDisposeBag = DisposeBag()
        setupVisibleBindings(for: visibleDisposeBag!)

        super.viewWillAppear(animated)

        setupNavigationBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        visibleDisposeBag = nil
    }

    func setupVisibleBindings(for visibleDisposeBag: DisposeBag) { }

    func setupNavigationBar() {}
}
