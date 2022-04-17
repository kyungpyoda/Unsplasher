//
//  Project.swift
//  Manifests
//
//  Created by 홍경표 on 2022/03/18.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "ThirdPartyManager",
    product: .framework,
    packages: [
        .RxSwift,
        .ReactorKit,
        .RealmSwift,
        .Then,
    ],
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.RxBlocking,
        .SPM.ReactorKit,
        .SPM.Then,
    ]
)
