//
//  MockError.swift
//  RxSwiftExpRetryTests
//
//  Created by Krystian Bujak on 20/11/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//

import Foundation

enum MockError: Error{
    case mockSimpleError
    case mockTextError(String)
}
