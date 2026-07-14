//
//  Protocol.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/14.
//

import Foundation

public protocol WWSimpleVideoPlayerDataSource: Identifiable, Hashable {
    var url: URL { get }
}
