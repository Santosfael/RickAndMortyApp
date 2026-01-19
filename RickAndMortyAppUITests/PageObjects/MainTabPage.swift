//
//  MainTabPage.swift
//  RickAndMortyApp
//
//  Created by Rafael on 19/01/26.
//

import XCTest

// Page Object Pattern organiza elementos da UI em classes
// Facilita manutenção - se a UI muda, atualiza apenas aqui
struct MainTabPage {
    let app: XCUIApplication

    // Identifica as tabls pelas label que definimos no código
    var characterTab: XCUIElement {
        app.tabBars.buttons["Character"]
    }

    var locationTab: XCUIElement {
        app.tabBars.buttons["Locations"]
    }

    var episodeTabs: XCUIElement {
        app.tabBars.buttons["Episodes"]
    }

    // Ações que o usuário pode fazer
    func tapCharacterTab() {
        characterTab.tap()
    }

    func tapLocationTab() {
        locationTab.tap()
    }

    func tapEpisodeTab() {
        episodeTabs.tap()
    }

    // Verificações de estado
    func isCharacterTabSelected() -> Bool {
        return characterTab.isSelected
    }

    func isLocationTabSelected() -> Bool {
        return locationTab.isSelected
    }

    func isEpisodeTabSelected() -> Bool {
        return episodeTabs.isSelected
    }
}
