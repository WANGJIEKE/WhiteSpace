//
//  SettingViewController.swift
//  WhiteSpace
//

import UIKit

class SettingViewController: UITableViewController {
    var keyboardSetting: WhiteSpaceSetting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetting = WhiteSpaceSetting.getFromUserDefaults()
    }
    
    // MARK: - UITableView
    
    func saveKeyboardSetting() {
        WhiteSpaceSetting.storeToUserDefaults(keyboardSetting)
        keyboardSetting = WhiteSpaceSetting.getFromUserDefaults()
    }
    
    func updateCheckMarkForTableView(_ tableView: UITableView) {
        switch keyboardSetting.character {
        case .normalWhiteSpace:
            tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.accessoryType = .none
        case .fullWidthWhiteSpace:
            tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.accessoryType = .none
            tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.accessoryType = .checkmark
        }

        for item in 0...3 {
            tableView.cellForRow(at: IndexPath(item: item, section: 1))?.accessoryType = item == keyboardSetting.count - 1 ? .checkmark : .none
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (indexPath.item == 0 && keyboardSetting.character == .normalWhiteSpace) ||
                (indexPath.item == 1 && keyboardSetting.character == .fullWidthWhiteSpace)
            {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else if indexPath.section == 1 {
            if indexPath.item == keyboardSetting.count - 1 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:  // Change whitespace character
            switch indexPath.item {
            case 0:
                keyboardSetting.character = .normalWhiteSpace
            case 1:
                keyboardSetting.character = .fullWidthWhiteSpace
            default:
                fatalError("invalid indexPath.item \"\(indexPath.item)\" when indexPath.section is 0")
            }
        case 1:  // Change whitespace count
            switch indexPath.item {
            case 0...3:
                keyboardSetting.count = indexPath.item + 1
            default:
                fatalError("invalid indexPath.item \"\(indexPath.item)\" when indexPath.section is 1")
            }
        case 3:  // Clear pasteboard
            let alert = UIAlertController(
                title: NSLocalizedString("Clear Pasteboard", comment: ""),
                message: NSLocalizedString("Do you want to clear all pasteboard content?", comment: ""),
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive, handler: { _ in
                UIPasteboard.general.items = []
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            return
        }
        saveKeyboardSetting()
        updateCheckMarkForTableView(tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
