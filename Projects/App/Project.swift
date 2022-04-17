//
//  Project.swift
//  Manifests
//
//  Created by 홍경표 on 2022/03/18.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "Unsplasher"

let project = Project.project(
    name: projectName,
    product: .app,
    packages: [
        .RxSwift,
        .ReactorKit,
        .RealmSwift,
        .Swinject,
        .SnapKit,
        .Then,
    ],
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.RxBlocking,
        .SPM.ReactorKit,
        .SPM.Realm,
        .SPM.RealmSwift,
        .SPM.Swinject,
        .SPM.SnapKit,
        .SPM.Then,
    ],
    infoPlist: "Supporting/Info.plist",
    sources: [
        "Sources/**"
    ],
    resources: [
        "Resources/**"
    ],
    settings: .settings(base: [
        TemplateConstants.unsplashAPIBaseURLKey: .string(TemplateConstants.unsplashAPIBaseURLValue),
        TemplateConstants.unsplashAccessTokenKey: .string(TemplateConstants.unsplashAccessTokenValue),
    ]),
    schemes: []
)

