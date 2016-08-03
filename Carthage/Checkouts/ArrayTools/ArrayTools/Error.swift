//
//  Error.swift
//  ArrayTools
//
//  Created by James Bean on 2/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

/**
 Errors thrown when trying to do bad things to an `Array`
 */
public enum ArrayError: ErrorType {
    
    /// Error thrown when trying to remove an `Element` that is not there.
    case RemovalError
}