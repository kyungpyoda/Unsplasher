//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍경표 on 2022/03/18.
//

import ProjectDescription

extension TargetDependency {
//    public static let presentationModule: TargetDependency = .project(
//        target: "PresentationModule",
//        path: .relativeToRoot("Projects/PresentationModule")
//    )
//
//    public static let domainModule: TargetDependency = .project(
//        target: "DomainModule",
//        path: .relativeToRoot("Projects/Modules/DomainModule")
//    )
//
//    public static let dataModule: TargetDependency = .project(
//        target: "DataModule",
//        path: .relativeToRoot("Projects/Modules/DataModule")
//    )
//
//    public static let thirdPartyManager: TargetDependency = .project(
//        target: "ThirdPartyManager",
//        path: .relativeToRoot("Projects/Modules/ThirdPartyManager")
//    )
//
//    public static let networkModule: TargetDependency = .project(
//        target: "NetworkModule",
//        path: .relativeToRoot("Projects/Modules/NetworkModule")
//    )
//
//    public static let injectionManager: TargetDependency = .project(
//        target: "InjectionManager",
//        path: .relativeToRoot("Projects/Modules/InjectionManager")
//    )
}

extension TargetDependency {
    public struct SPM {
        public static let RxSwift = TargetDependency.package(product: "RxSwift")
        public static let RxCocoa = TargetDependency.package(product: "RxCocoa")
        public static let RxRelay = TargetDependency.package(product: "RxRelay")
        public static let RxBlocking = TargetDependency.package(product: "RxBlocking")
        public static let ReactorKit = TargetDependency.package(product: "ReactorKit")
        public static let Realm = TargetDependency.package(product: "Realm")
        public static let RealmSwift = TargetDependency.package(product: "RealmSwift")
        public static let Swinject = TargetDependency.package(product: "Swinject")
        public static let SnapKit = TargetDependency.package(product: "SnapKit")
        public static let Then = TargetDependency.package(product: "Then")
    }
}

public extension Package {
    static let RxSwift = Package.remote(
        url: "https://github.com/ReactiveX/RxSwift",
        requirement: .exact("6.5.0")
    )
    static let ReactorKit = Package.remote(
        url: "https://github.com/ReactorKit/ReactorKit",
        requirement: .exact("3.2.0")
    )
    static let RealmSwift = Package.remote(
        url: "https://github.com/realm/realm-swift",
        requirement: .exact("10.12.0")
    )
    static let Swinject = Package.remote(
        url: "https://github.com/Swinject/Swinject",
        requirement: .exact("2.8.1")
    )
    static let SnapKit = Package.remote(
        url: "https://github.com/SnapKit/SnapKit",
        requirement: .exact("5.0.1")
    )
    static let Then = Package.remote(
        url: "https://github.com/devxoul/Then",
        requirement: .exact("2.7.0")
    )
}

public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let tests: SourceFilesList = "Tests/**"
}

public enum ResourceType: String {
    case xibs = "Sources/**/*.xib"
    case storyboards = "Resources/**/*.storyboard"
    case assets = "Resources/**"
}

public extension ResourceFileElements {
    static func resources(with resources: [ResourceType]) -> ResourceFileElements {
        return .init(
            resources: resources.map({ ResourceFileElement(stringLiteral: $0.rawValue) })
        )
    }
}
