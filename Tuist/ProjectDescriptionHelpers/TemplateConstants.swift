//
//  TemplateConstants.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍경표 on 2022/03/24.
//

import ProjectDescription

public enum TemplateConstants {
    public static let defaultDeploymentTarget = DeploymentTarget.iOS(targetVersion: "13.0", devices: .iphone)
    public static let organizationName: String = "pio"
    public static let bundlePrefix: String = "kr.pio"
    
    public static let unsplashAPIBaseURLKey: String = "UNSPLASH_BASE_URL"
    public static let unsplashAPIBaseURLValue: String = "https://api.unsplash.com"
    public static let unsplashAccessTokenKey: String = "UNSPLASH_ACCESS_KEY"
    public static let unsplashAccessTokenValue: String = ""
}
