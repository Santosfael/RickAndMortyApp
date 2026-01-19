//
//  EpisodeListPage.swift
//  RickAndMortyApp
//
//  Created by Rafael on 19/01/26.
//

import XCTest

// Representa a tela de listagem de personagens
// Tem como objsrivo encapsular todos os elementos e ações dessa tela
struct EpisodeListPage {
    let app: XCUIApplication

    // Elementos de UI que queremos testar
    var navigationBar: XCUIElement {
        app.navigationBars["Episodes"]
    }

    var scrollView: XCUIElement {
        app.scrollViews.firstMatch
    }

    var loadingIndicator: XCUIElement {
        app.activityIndicators.firstMatch
    }

    // Busca células de personagens pelo identificador de acessibilidade
    // Usamos staticTexts porque o nome do personagem é um Text()
    func episodeCell(withName name: String) -> XCUIElement {
        return app.staticTexts[name]
    }

    // Verifica se uma célula de personagem existe
    
    func hasEpisode(named name: String) -> Bool {
        return episodeCell(withName: name).exists
    }

    // Simula o scroll para baixo, para carregar mais dados
    func scrollDown() {
        scrollView.swipeUp()
    }

    // Simula o pull to refresh
    func pullToRefresh() {
        let firstCell = scrollView.children(matching: .any).element(boundBy: 0)
        firstCell.swipeDown()
    }

    // Espera até que o loading desapareça
    func waitForLoadingToComplete(timeout: TimeInterval = 10) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: loadingIndicator)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, "Loading should complete within \(timeout) seconds")
    }
}
