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

//        var dict: NSDictionary?
////        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script \"sudo /bin/chmod +a \\\"user:fin:allow write\\\" /etc/host1\"\nend tell")
////        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script\nend tell")
//        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\nactivate\nend tell")
//        appleScript?.executeAndReturnError(&dict)
//        NSLog("\(String(describing: dict))")

        let url = URL.init(fileURLWithPath: NSOpenStepRootDirectory() + "etc/hosts")


//                let isWritable = FileManager.default.fileExists(atPath: url.path)
//                let dict = try! FileManager.default.attributesOfItem(atPath: url.path)
//                let dic = try! FileManager.default.attributesOfFileSystem(forPath: url.path)
//                let aaa = FileManager.default.enumerator(atPath: url.path)
//
//        NSLog(url.path)
//
//        NSLog("\(access(url.path, R_OK))")
//        NSLog("\(access(url.path, W_OK))")
//
//
//        var names = [Int8]()
//
//        let b = listxattr(url.path, &names, 0, 0)
//NSLog("\(b)")
//
//        var acl : acl_perm_t
        let result = acl_get_file(url.path, ACL_TYPE_EXTENDED)

        var entry: acl_entry_t?
        var id = ACL_FIRST_ENTRY

        // acl https://github.com/jvscode/getfacl/blob/master/getfacl.c
        // mbr https://github.com/practicalswift/osx/blob/master/src/libinfo/membership.subproj/membership.c
        // sizeof https://stackoverflow.com/questions/24662864/swift-how-to-use-sizeof
        while acl_get_entry(result, id.rawValue, &entry) == 0 {
            id = ACL_NEXT_ENTRY
            var set: acl_permset_t?
            if acl_get_permset(entry, &set) != 0 {
                continue
            }

            var tag: acl_tag_t = ACL_UNDEFINED_TAG
            if acl_get_tag_type(entry, &tag) != 0 {
                continue
            }
            var tagType = ""
            switch tag {
            case ACL_EXTENDED_ALLOW:
                tagType = "allow"
            case ACL_EXTENDED_DENY:
                tagType = "deny"
            default:
                tagType = "unknow"
            }

            var permset: acl_permset_t?
            if acl_get_permset(entry, &permset) != 0 {
                continue
            }
            aclPerms.forEach({ (aclPerm) in
                if acl_get_perm_np(permset, aclPerm.perm) == 0 {
                    return
                }
                if ((aclPerm.flags == 0 ? 1 : 0) & ACL_PERM_FILE) == 1 {
                    return
                }
                NSLog(aclPerm.name)
            })

            guard let qualifier = acl_get_qualifier(entry) else {
                continue
            }
            let udid = qualifier.assumingMemoryBound(to: guid_t.self).pointee
            let uuid = UUID.init(uuid: qualifier.assumingMemoryBound(to: uuid_t.self).pointee)


            var _user_compat_prefix: uuid_t = (0xff, 0xff, 0xee, 0xee, 0xdd, 0xdd, 0xcc, 0xcc, 0xbb, 0xbb, 0xaa, 0xaa, 0x00, 0x00, 0x00, 0x00)
            var _group_compat_prefix: uuid_t = (0xab, 0xcd, 0xef, 0xab, 0xcd, 0xef, 0xab, 0xcd, 0xef, 0xab, 0xcd, 0xef, 0x00, 0x00, 0x00, 0x00)

            if memcmp(qualifier, &_user_compat_prefix, MemoryLayout<uuid_t>.size - MemoryLayout<id_t>.size) == 0 {
                NSLog("uid")
            } else if memcmp(qualifier, &_group_compat_prefix, MemoryLayout<uuid_t>.size - MemoryLayout<id_t>.size) == 0 {
                NSLog("gid")
            }

            NSLog("\(tagType) \(uuid)")

//            getpwuid()
//getgrgid()
        }


        NSLog("\(result)")
//
//        let aclList = SecACLReF
//
//
//        SecACLRef aclList;
//        SecAccessRef itemAccessRef;
//        uid_t userid = 0;
//        gid_t groupid;
//        CFArrayRef aclListArr;
//        SecACLRef newAcl;
//        SecAccessRef
//
//        var itemAccessRef: SecAccess
//        let osstatus = SecAccessCopyOwnerAndACL(SecAccess, nil, nil, nil, nil)
//
//        public func SecAccessCopyOwnerAndACL(_ accessRef: SecAccess, _ userId: UnsafeMutablePointer<uid_t>?, _ groupId: UnsafeMutablePointer<gid_t>?, _ ownerType: UnsafeMutablePointer<SecAccessOwnerType>?, _ aclList: UnsafeMutablePointer<CFArray?>?) -> OSStatus
//
//
//        SecKeychainItemCopyAccess(someItem, &itemAccessRef);
//        SecAccessCopyOwnerAndACL(itemAccessRef, &userid, &groupid, (UInt32*)kSecUseOnlyUID, &aclListArr);
    }
}
