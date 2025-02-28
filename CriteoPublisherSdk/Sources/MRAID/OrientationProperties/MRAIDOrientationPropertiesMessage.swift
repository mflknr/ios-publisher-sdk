//
//  MRAIDOrientationPropertiesMessage.swift
//  CriteoPublisherSdk
//
//  Copyright © 2018-2023 Criteo. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

public struct MRAIDOrientationPropertiesMessage: Decodable {
    let action: Action
    let allowOrientationChange: Bool
    let forceOrientation: MRAIDDeviceOrientation
}

public struct MRAIDOrientationProperties {
    let allowOrientationChange: Bool
    let orientationMask: UIInterfaceOrientationMask
    let supportedOrietationMask: UIInterfaceOrientationMask

    public init(allowOrientationChange: Bool, forceOrientation: MRAIDDeviceOrientation) {
        self.allowOrientationChange = allowOrientationChange
        self.orientationMask = MRAIDOrientationProperties.orientationMask(for: forceOrientation)
        self.supportedOrietationMask = allowOrientationChange ? [.all] : MRAIDOrientationProperties.orientationMask(for: forceOrientation)
    }

    public init(allowOrientationChange: Bool, orientationMask: UIInterfaceOrientationMask) {
        self.allowOrientationChange = allowOrientationChange
        self.orientationMask = orientationMask
        self.supportedOrietationMask = orientationMask

    }

    public static func orientationMask(for orientation: MRAIDDeviceOrientation) -> UIInterfaceOrientationMask {
        switch orientation {
        case .portrait: return [.portrait]
        case .landscape: return [.landscape]
        case .none: return [.all]
        }
    }
}
