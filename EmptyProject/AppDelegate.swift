//
//  AppDelegate.swift
//  EmptyProject
//
//  Created by fin on 2017/6/1.
//  Copyright © 2017年 fin. All rights reserved.
//

import Cocoa

struct ACLPerm {
    let perm: acl_perm_t
    let name: String
    let flags: Int
//    acl_perm_t  perm;
//    char        *name;
//    int     flags;
//    #define ACL_PERM_DIR    (1<<0)
//    #define ACL_PERM_FILE   (1<<1)
}

let ACL_PERM_DIR = 1 << 0
let ACL_PERM_FILE = 1 << 1

let aclPerms = [
    ACLPerm(perm: ACL_READ_DATA, name: "read", flags: ACL_PERM_FILE),
    ACLPerm(perm: ACL_LIST_DIRECTORY, name: "list", flags: ACL_PERM_DIR),
    ACLPerm(perm: ACL_WRITE_DATA, name: "write", flags: ACL_PERM_FILE),
    ACLPerm(perm: ACL_ADD_FILE, name: "add_file", flags: ACL_PERM_DIR),
    ACLPerm(perm: ACL_EXECUTE, name: "execute", flags: ACL_PERM_FILE),
    ACLPerm(perm: ACL_SEARCH, name: "search", flags: ACL_PERM_DIR),
    ACLPerm(perm: ACL_DELETE, name: "delete", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_APPEND_DATA, name: "append", flags: ACL_PERM_FILE),
    ACLPerm(perm: ACL_ADD_SUBDIRECTORY, name: "add_subdirectory", flags: ACL_PERM_DIR),
    ACLPerm(perm: ACL_DELETE_CHILD, name: "delete_child", flags: ACL_PERM_DIR),
    ACLPerm(perm: ACL_READ_ATTRIBUTES, name: "readattr", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_WRITE_ATTRIBUTES, name: "writeattr", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_READ_EXTATTRIBUTES, name: "readextattr", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_WRITE_EXTATTRIBUTES, name: "writeextattr", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_READ_SECURITY, name: "readsecurity", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_WRITE_SECURITY, name: "writesecurity", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLPerm(perm: ACL_CHANGE_OWNER, name: "chown", flags: ACL_PERM_FILE | ACL_PERM_DIR)
]

struct ACLFlag {
    let flag: acl_flag_t
    let name: String
    let flags: Int
}

let aclFlags = [
    ACLFlag(flag: ACL_ENTRY_FILE_INHERIT, name: "file_inherit", flags: ACL_PERM_DIR),
    ACLFlag(flag: ACL_ENTRY_DIRECTORY_INHERIT, name: "directory_inherit", flags: ACL_PERM_DIR),
    ACLFlag(flag: ACL_ENTRY_LIMIT_INHERIT, name: "limit_inherit", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLFlag(flag: ACL_ENTRY_ONLY_INHERIT, name: "only_inherit", flags: ACL_PERM_DIR),

    ACLFlag(flag: ACL_FLAG_NO_INHERIT, name: "??", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLFlag(flag: ACL_ENTRY_INHERITED, name: "??", flags: ACL_PERM_FILE | ACL_PERM_DIR),
    ACLFlag(flag: ACL_FLAG_DEFER_INHERIT, name: "??", flags: ACL_PERM_FILE | ACL_PERM_DIR)
]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let windowSize = NSMakeSize(800, 500)
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = TextWindow(contentRect: NSRect.zero,
                            styleMask: [.closable, .resizable, .miniaturizable, .titled],
                            backing: .buffered,
                            defer: false)
        window.center()
        window.makeKeyAndOrderFront(self)
    }
}
