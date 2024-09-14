import Foundation
import StreamChat
import StreamChatUI
import UIKit

final class ChatManager {
    static let shared = ChatManager()
    
    private var client: ChatClient!
    
    private let tokens = [
        "bob": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYm9iIn0.VQ462XDRemTAbORACfU4e8L_6AzcMJ58yOs7kfApv18",
        "alice": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2UifQ.yy3eE-t0G0yOhMFWCZgoQwnJRUNY_8mX9nlvkIS2Zz8"
    ]
    
    func setUp() {
        let client = ChatClient(config: .init(apiKey: .init("r9nuf7v6dyns")))
        self.client = client
    }
    
    // Authentication
    func signIn(with username: String, completion: @escaping (Bool) -> Void) {
        guard !username.isEmpty else {
            completion(false)
            return
        }
        
        guard let token = tokens[username.lowercased()] else {
            completion(false)
            return
        }
        
        client.connectUser(userInfo: UserInfo(id: username, name: username), token: Token(stringLiteral: token)) { error in
            completion(error == nil)
        }
    }
    
    func signOut() {
        client.disconnect()
        client.logout()
    }
    
    var isSignedIn: Bool {
        return client.currentUserId != nil
    }
    
    var currentUser: String? {
        return client.currentUserId
    }
    
    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else { return nil }
        let list = client.channelListController(query: .init(filter: .containMembers(userIds: [id])))
        
        let vc = ChatChannelListVC()
        vc.content = list
        list.synchronize()
        return vc
    }
    
    // Channel List + Creation
    public func createNewChannel(name: String) {
        guard let current = currentUser else {
            print("No current user.")
            return
        }
        
        guard client != nil, isSignedIn else {
            print("Client not set up or user not signed in.")
            return
        }

        let keys: [String] = tokens.keys.filter({ $0 != current }).map { $0 }
        
        do {
            let result = try client.channelController(
                createChannelWithId: .init(type: .messaging, id: UUID().uuidString),
                name: name,
                members: Set(keys),
                isCurrentUserMember: true
            )
            result.synchronize()
        } catch let error as ClientError {
            print("Error creating channel: \(error.localizedDescription)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
