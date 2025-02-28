//
//  AdNetwork.swift
//  CriteoAdViewer
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
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

struct AdNetwork: Equatable {
  typealias AdUnitPair = (criteoId: String, externalId: String)
  let name: String
  let supportedFormats: [AdFormat]
  let defaultAdUnits: [AdFormat: String]
  let specificAdUnits: [AdFormat: AdUnitPair]
  let adViewBuilder: AdViewBuilder

  init(
    name: String,
    supportedFormats: [AdFormat],
    defaultAdUnits: [AdFormat: String],
    specificAdUnits: [AdFormat: AdUnitPair] = [:],
    adViewBuilder: AdViewBuilder
  ) {
    self.name = name
    self.supportedFormats = supportedFormats
    self.defaultAdUnits = defaultAdUnits
    self.specificAdUnits = specificAdUnits
    self.adViewBuilder = adViewBuilder
  }

  var types: [AdType] {
    Array(
      Set(
        supportedFormats.map {
          switch $0 {
          case .sized(let type, _): return type
          case .flexible(let type): return type
          }
        })
    ).sorted {
      $0.rawValue < $1.rawValue
    }
  }

  func sizes(type: AdType) -> [AdSize] {
    self.supportedFormats.compactMap {
      switch $0 {
      case .sized(type, let size): return .some(size)
      case _: return .none
      }
    }
  }

  static func == (lhs: AdNetwork, rhs: AdNetwork) -> Bool {
    lhs.name == rhs.name
  }
}

struct AdNetworks {
  let mediation: AdNetwork
  let google: AdNetwork
  let standalone: AdNetwork
  let inHouse: AdNetwork
  let mraid: AdNetwork
  let skadNetworkStoreKitRedered: AdNetwork
  let skadNetworkViewthrough: AdNetwork
  let all: [AdNetwork]
  static let defaultPublisherId = "B-056946"

  init(controller: AdViewController) {
    self.google = googleNetwork(controller)
    self.standalone = standaloneNetwork(controller)
    self.inHouse = inHouseNetwork(controller: controller)
    self.mediation = googleMediationNetwork(controller)
    self.mraid = standaloneMRAIDNetwork(controller)
    self.skadNetworkStoreKitRedered = standaloneWithSKAdStoreKitRenderedAd(controller)
    self.skadNetworkViewthrough = standaloneWithSKAdViewThroughAd(controller)
    self.all = [mediation, google, standalone, inHouse, mraid, skadNetworkStoreKitRedered, skadNetworkViewthrough]
  }
}

private func googleMediationNetwork(_ controller: AdViewController) -> AdNetwork {
  AdNetwork(
    name: "Mediation",
    supportedFormats: [
      AdFormat.banner320x50,
      AdFormat.banner300x250,
      AdFormat.interstitial
    ],
    defaultAdUnits: [
      AdFormat.banner320x50: "ca-app-pub-3940256099942544/2934735716",
      AdFormat.banner300x250: "ca-app-pub-3940256099942544/2934735716",
      AdFormat.interstitial: "ca-app-pub-3940256099942544/4411468910"
    ],
    specificAdUnits: [:],
    adViewBuilder: GAMAdViewBuilder(controller: controller))
}

private func googleNetwork(_ controller: AdViewController) -> AdNetwork {
  AdNetwork(
    name: "Google",
    supportedFormats: [
      AdFormat.banner320x50,
      AdFormat.banner300x250,
      AdFormat.native,
      AdFormat.interstitial,
      AdFormat.video,
      AdFormat.rewarded
    ],
    defaultAdUnits: [
      AdFormat.banner320x50: "/6499/example/banner",
      AdFormat.banner300x250: "/6499/example/banner",
      AdFormat.native: "/6499/example/native",
      AdFormat.interstitial: "/6499/example/interstitial",
      AdFormat.video: "/6499/example/interstitial"
    ],
    specificAdUnits: [
      AdFormat.rewarded: (
        criteoId: "/6499/example/rewarded",
        externalId: "/21775744923/example/rewarded_interstitial"
      )
    ],
    adViewBuilder: GoogleAdViewBuilder(controller: controller))
}

private func standaloneNetwork(_ controller: AdViewController) -> AdNetwork {
  AdNetwork(
    name: "Standalone",
    supportedFormats: [
      AdFormat.banner320x50,
      AdFormat.interstitial,
      AdFormat.native
    ],
    defaultAdUnits: [
      AdFormat.banner320x50: "30s6zt3ayypfyemwjvmp",
      AdFormat.interstitial: "6yws53jyfjgoq1ghnuqb",
      AdFormat.native: "190tsfngohsvfkh3hmkm"
    ], adViewBuilder: CriteoAdViewBuilder(controller: controller, type: .standalone))
}

private func standaloneMRAIDNetwork(_ controller: AdViewController) -> AdNetwork {
  AdNetwork(
    name: "MRAID",
    supportedFormats: [
      AdFormat.banner300x250,
      AdFormat.interstitial
    ],
    defaultAdUnits: [
      AdFormat.banner300x250: "7fspp28x445grwm378ck",
      AdFormat.interstitial: "7fspp28x445grwm378ck"
    ], adViewBuilder: CriteoAdViewBuilder(controller: controller, type: .standalone))
}

private func inHouseNetwork(controller: AdViewController) -> AdNetwork {
  AdNetwork(
    name: "InHouse",
    supportedFormats: [
      AdFormat.banner320x50,
      AdFormat.interstitial
    ],
    defaultAdUnits: [
      AdFormat.banner320x50: "30s6zt3ayypfyemwjvmp",
      AdFormat.interstitial: "6yws53jyfjgoq1ghnuqb"
    ], adViewBuilder: CriteoAdViewBuilder(controller: controller, type: .inHouse))
}

private func standaloneWithSKAdStoreKitRenderedAd(_ controller: AdViewController) -> AdNetwork {
    AdNetwork(
      name: "Standalone - SKAd - Store Kit redered ad",
      supportedFormats: [
        AdFormat.banner320x50
      ],
      defaultAdUnits: [
        AdFormat.banner320x50: "31589da9edb442329e17"
      ], adViewBuilder: CriteoAdViewBuilder(controller: controller, type: .standalone))
  }

private func standaloneWithSKAdViewThroughAd(_ controller: AdViewController) -> AdNetwork {
    AdNetwork(
      name: "Standalone - SKAd - View Through ad",
      supportedFormats: [
        AdFormat.banner320x50
      ],
      defaultAdUnits: [
        AdFormat.banner320x50: "cea76256124bbdcd61e8"
      ], adViewBuilder: CriteoAdViewBuilder(controller: controller, type: .standalone))
  }
