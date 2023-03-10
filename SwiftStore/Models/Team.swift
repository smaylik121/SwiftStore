//
//  Team.swift
//  SwiftStore
//
//  Created by Aleksey Efimov on 05.02.2023.
//

struct Developer {
    
    let name: String
    let image: String
    let charpter: String
    let githubLink: String
    
    static func getTeam() -> [Developer] {
        [
            Developer(name: "Vitaly",
                      image: "dev1",
                      charpter: "Team lead, Главный Экран",
                      githubLink: "vitaly-grinchik"),
            Developer(name: "Dmitry",
                      image: "dev2",
                      charpter: "DataStore, Карточка товара",
                      githubLink: "dypolyakov"),
            Developer(name: "Kirill",
                      image: "dev3",
                      charpter: "Каталог, Список товаров",
                      githubLink: "Kirilloao"),
            Developer(name: "Aleksey",
                      image: "dev4",
                      charpter: "Корзина, Профиль",
                      githubLink: "smaylik121")
        ]
    }
}


