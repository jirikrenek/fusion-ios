//
//  ViewModelType.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Bindings

    init(dependency: Dependency, bindings: Bindings)
}

struct ViewModelWrapper<VM: ViewModelType> {
    let dependencies: VM.Dependency

    init(_ dependencies: VM.Dependency) {
        self.dependencies = dependencies
    }

    func bind(_ bindings: VM.Bindings) -> VM {
        return VM(dependency: dependencies, bindings: bindings)
    }
}
