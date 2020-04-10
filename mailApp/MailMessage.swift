//
//  MailMessage.swift
//  mailApp
//
//  Created by Антон Ларченко on 09.09.2019.
//  Copyright © 2019 Anton Larchenko. All rights reserved.
//

import Foundation

struct Message {
    var name: String
    var subject: String
    var email: String
    var date: Date
    var text: String
}

class MailModel {
    var messages = [Message]()
    var filteredMessages = [Message]()
    
    init() {
        setup()
    }
    
    func addNewMessage() {
        let message = Message(name: "Имя", subject: "Тема", email: "new@new.ru", date: Date(), text: "Текст")
        messages.insert(message, at: 0)
    }
    
    func removeMessage(indexPath: IndexPath) {
        messages.remove(at: indexPath.row)
    }
    
    func messagesFilter(text: String) {
        filteredMessages.removeAll()
        
        filteredMessages = messages.filter({ (message) -> Bool in
            return message.name.lowercased().contains(text.lowercased())
        })
    }
    
    func setup() {
        let names = ["Антон", "Сергей", "Никита", "Павел", "Александр", "Дмитрий", "Кирилл", "Олег"]
        let email = ["anton@email.ru", "sergey@email.ru", "nikita@email.ru", "pavel@email.ru", "alex@email.ru", "dima@email.ru", "kirill@email.ru", "oleg@email.ru"]
        let subjects = ["Тема1", "Тема2", "Тема3", "Тема4", "Тема5", "Тема6", "Тема7", "Тема8"]
        let text = ["Обман века: Эскобар выдал Samsung в фольге за новый смартфон", "Обратно в браузер: как коронавирус изменил интернет", "Доступный интернет: какие сайты стали бесплатными для россиян", "Сообщения неличного характера: WhatsApp ограничил пересылку", "Нагрузка растет: сайты попросили снизить качество видео", "Базовая потребность: россияне получат бесплатный Рунет", "Презентация близко: Apple выбрала название дешевого iPhone", "Новая уязвимость: как Zoom крадет пароли Windows"]
        
        for _ in 0..<10 {
            let number = Int.random(in: 0..<names.count)
            
            let today = Date()
            let dateMessage = Calendar.current.date(byAdding: .minute, value: number * 100, to: today)
            
            let message = Message(name: names[number], subject: subjects[number], email: email[number], date: dateMessage!, text: text[number])
            messages.append(message)
        }
    }
}
