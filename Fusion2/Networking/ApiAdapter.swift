//
//  ApiAdapter.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

final class ApiAdapter: RequestAdapter {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void)
    {
        
    }
}
