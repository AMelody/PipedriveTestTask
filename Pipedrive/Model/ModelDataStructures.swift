//
//  Person.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/21/23.
//

import Foundation

// MARK: -

struct Person: Codable, PropertyLoopable {

    let id: Int
    let phone: [Contact]?
    let email: [Contact]?
    let ownerId: Owner?
    let orgId: Organisation?
    let pictureId: Picture?
    let companyId: Int?
    let name: String?
    let firstName: String?
    let lastName: String?
    let openDealsCount: Int?
    let relatedOpenDealsCount: Int?
    let closedDealsCount: Int?
    let relatedClosedDealsCount: Int?
    let participantOpenDealsCount: Int?
    let participantClosedDealsCount: Int?
    let emailMessagesCount: Int?
    let activitiesCount: Int?
    let doneActivitiesCount: Int?
    let undoneActivitiesCount: Int?
    let filesCount: Int?
    let notesCount: Int?
    let followersCount: Int?
    let wonDealsCount: Int?
    let relatedWonDealsCount: Int?
    let lostDealsCount: Int?
    let relatedLostDealsCount: Int?
    let activeFlag: Bool?
    let primaryEmail: String?
    let firstChar: String?
    let updateTime: String?
    let addTime: String?
    let visibleTo: String?
    let marketingStatus: String?
    let nextActivityDate: String?
    let nextActivityTime: String?
    let nextActivityId: Int?
    let lastActivityId: Int?
    let lastActivityDate: String?
    let lastIncomingMailTime: String?
    let lastOutgoingMailTime: String?
    let label: Int?
    let orgName: String?
    let ownerName: String?
    let ccEmail: String?
}

// MARK: -

struct Contact: Codable, PropertyLoopable {

    let value: String
    let primary: Bool?
    let label: String?
}

// MARK: -

struct Owner: Codable, PropertyLoopable {

    let id: Int
    let name: String?
    let email: String?
    let hasPic: Int?
    let picHash: String?
    let activeFlag: Bool?
    let value: Int?
}

// MARK: -

struct Organisation: Codable, PropertyLoopable {

    let name: String
    let peopleCount: Int?
    let ownerId: Int?
    let address: String?
    let activeFlag: Bool?
    let ccFmail: String?
    let value: Int?
}

// MARK: -

struct Picture: Codable, PropertyLoopable {

    let itemType: String?
    let itemId: Int
    let activeFlag: Bool?
    let addTime: String?
    let updateTime: String?
    let addedByUserId: Int?
    let pictures: [String: String]?
    let value: Int?
}
