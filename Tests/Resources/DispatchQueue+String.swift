//
//  DispatchQueue+String.swift
//  RxSwiftAutoRetryTests
//
//  Created by Krystian Bujak on 21/11/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static var CurrentQueueLabelName: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
