//
//  Project+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍경표 on 2022/03/18.
//

import ProjectDescription

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList? = ["Sources/**"],
        resources: ResourceFileElements? = nil
    ) -> Self {
        return project(
            name: name,
            platform: platform,
            product: product,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources
        )
    }
}

public extension Project {
    static func project(
        name: String,
        organizationName: String = TemplateConstants.organizationName,
        platform: Platform = .iOS,
        product: Product,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = TemplateConstants.defaultDeploymentTarget,
        entitlements: Path? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        settings: Settings? = nil,
        schemes: [Scheme] = []
    ) -> Self {
        let mainTarget: Target = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(TemplateConstants.bundlePrefix).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings
        )
        
        let testTarget: Target = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(TemplateConstants.bundlePrefix).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: name)
            ]
        )
        
        let targets: [Target] = [
            mainTarget,
            testTarget
        ]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}
