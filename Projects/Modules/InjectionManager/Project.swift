//
//  Project.swift
//  Manifests
//
//  Created by 홍경표 on 2022/03/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "InjectionManager",
    product: .staticFramework,
    packages: [
        .Swinject,
    ],
    dependencies: [
        .SPM.Swinject,
    ]
)
