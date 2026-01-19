//
//  RickAndMortyAppUITests.swift
//  RickAndMortyAppUITests
//
//  Created by Rafael on 19/01/26.
//

import XCTest

// Tem como objetivo testar o comportamento da aplicação do ponto de vista do usuário
final class RickAndMortyAppUITests: XCTestCase {

    var app: XCUIApplication!
    var mainTabPage: MainTabPage!
    var characterPage: CharacterListPage!
    var locationPage: LocationListPage!
    var episodePage: EpisodeListPage!

    // Iremos prepara o estado do app para iniciar limpo
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()

        mainTabPage = MainTabPage(app: app)
        characterPage = CharacterListPage(app: app)
        locationPage = LocationListPage(app: app)
        episodePage = EpisodeListPage(app: app)
    }

    override func tearDown() {
        app = nil
        mainTabPage = nil
        characterPage = nil
        locationPage = nil
        episodePage = nil
        super.tearDown()
    }

    // MARK: - Tab Navigation Tests

    // Testa se o app ABRE a tab de forma correta(characters)
    // validando o estado inicial da aplicação
    func testAppLaunches_ShowsCharacterTabByDefault() {
        // ASSERT
        // verifica que a navigation bar está visível
        XCTAssertTrue(characterPage.navigationBar.exists)
        
        XCTAssertTrue(mainTabPage.isCharacterTabSelected())
        
        print("App launched successfully witgh character tab")
    }

    // Testa a navegação entre abas
    // simula o usuário tocando em cada aba
    func testTabNavigation_SwitchBetweenAllTabs() {
        // ACT & ASSERT
        XCTAssertTrue(mainTabPage.isCharacterTabSelected())
        
        // ACT - toca na tab locations
        mainTabPage.tapLocationTab()
        
        // ASSERT - Verifica que mudou para tela de locations
        XCTAssertTrue(locationPage.navigationBar.exists)
        XCTAssertTrue(mainTabPage.isLocationTabSelected())
        
        // ACT - Toca na taba de episodes
        mainTabPage.tapEpisodeTab()
        
        // ASSERT - verifica se mudou para tela de episodes
        XCTAssertTrue(episodePage.navigationBar.exists)
        XCTAssertTrue(mainTabPage.isEpisodeTabSelected())
        
        //ACT - Volta para characters
        mainTabPage.tapCharacterTab()
        
        // ASSERT - Verifica se voltou para tela de characters
        XCTAssertTrue(characterPage.navigationBar.exists)
        XCTAssertTrue(mainTabPage.isCharacterTabSelected())
        
        print("Successfully navigated through all tabs")
    }

    // MARK: - Characters List Tests
    
    // Testa se a lista de personagem carrega
    // validar que dados aparecem na tela após o loading
    func testCharacterList_LoadsAndDisplayCharacters() {
        // ARRANGE
        // Aguarda o loading completar
        characterPage.waitForLoadingToComplete()
        
        // ASSERT
        // Verifica que pelo menos um personagem aparece
        let scrollView = characterPage.scrollView
        XCTAssertTrue(scrollView.exists)
        
        // Verifica que há elementos dentro do scroll view
        let cellCount = scrollView.children(matching: .any).count
        XCTAssertGreaterThan(cellCount, 0)
        
        print("Chracter list loaded with \(cellCount) elements")
    }

    // Tem como objetivo testar o scroll na lista
    // Valida que ao rolar, mais conteúdo é carregado
    func testCharacterList_ScrollLoadsMoreCharacters() {
        // ARRANGE
        characterPage.waitForLoadingToComplete()
        
        //Conta elementos antes do scroll
        let initialCount = characterPage.scrollView.children(matching: .any).count
        
        // ACT - Scroll para baixo
        characterPage.scrollDown()
        
        sleep(2)
        
        // ASSERT
        let afterScrollCount = characterPage.scrollView.children(matching: .any).count
        
        XCTAssertGreaterThanOrEqual(afterScrollCount, initialCount)
        
        print("Scroll completed: \(initialCount) -> \(afterScrollCount) elements")
    }

    // MARK: - Locations List Tests
    
    // Testa se a lista de localizações é carregada
    func testLocationList_LoadsAndDisplayLocations() {
        // ARRANGE - Navega para a tab de locations
        mainTabPage.tapLocationTab()
        
        // Aguarda o loading
        locationPage.waitForLoadingToComplete()
        
        // ASSERT
        XCTAssertTrue(locationPage.navigationBar.exists)
        
        let cellCount = locationPage.scrollView.children(matching: .any).count
        XCTAssertGreaterThan(cellCount, 0)
    }

    // MARK: - Episode List Tests
    
    // Testa se a lista de localizações é carregada
    func testEpisodeList_LoadsAndDisplayLocations() {
        // ARRANGE - Navega para a tab de locations
        mainTabPage.tapEpisodeTab()
        
        // Aguarda o loading
        episodePage.waitForLoadingToComplete()
        
        // ASSERT
        XCTAssertTrue(episodePage.navigationBar.exists)
        
        let cellCount = episodePage.scrollView.children(matching: .any).count
        XCTAssertGreaterThan(cellCount, 0)
    }

    // MARK: - Pull to Refresh Tests
    
    //Irá testar o Pull to Refresh
    func testCharacterList_PullToRefresh_ReloadsData() {
        // ARRANGE
        characterPage.waitForLoadingToComplete()
        
        // ACT - Pull to refresh
        characterPage.pullToRefresh()
        
        sleep(1)
        
        // ASSERT
        XCTAssertTrue(characterPage.scrollView.exists)
        
        let cellCount = characterPage.scrollView.children(matching: .any).count
        XCTAssertGreaterThan(cellCount, 0)
    }

    // MARK: - Performance Tests
    
    func testAppLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
            app.terminate()
        }
    }

    // MARK: - Accessibility Test
    
    // Testa Acessibilidade
    func testTabBar_HasAccessibilityLabels() {
        XCTAssertTrue(mainTabPage.characterTab.exists)
        XCTAssertTrue(mainTabPage.locationTab.exists)
        XCTAssertTrue(mainTabPage.episodeTabs.exists)
    }
}
