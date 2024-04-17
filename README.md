# 使用 Ansible 部署 LNMP + Laravel 環境

這個倉庫包含了一套 Ansible 腳本，用於在遠程服務器上設置 LNMP (Linux, Nginx, MariaDB, PHP) 堆疊以及 Laravel 應用。這套腳本旨在提供一個快速且一致的方法來部署 Laravel 應用於不同的環境中。

## 概覽

這個 Ansible 專案將安裝以下組件：
- **Nginx** 作為網頁伺服器
- **MariaDB** 作為資料庫伺服器
- **PHP 8.2** 作為腳本語言
- **Laravel** 作為網頁開發的 PHP 框架

這個設置在 Debian 12 上進行過測試

## 先決條件

- 一台運行 Debian 12 務器。
- 能夠使用 SSH 存取服務器。
- 在 `inventory/hosts.ini` 檔案中添加服務器的 IP 地址或域名。
- 在您的本機或控制節點上安裝 Ansible。


## 安裝指南


### 步驟 1: 配置 Ansible 控制機
1. 安裝 Ansible:

    確保您的控制機（通常是您的本地開發機或一台管理伺服器）已安裝 Ansible。在 Ubuntu 上可以使用以下命令安裝 Ansible：

    ```bash
    sudo apt update
    sudo apt install ansible -y
    ```
2. 安裝必要的依賴:

    有些 Ansible 模組可能需要額外的 Python 庫，確保這些都已安裝：

    ```bash
    sudo apt install python3-pip -y
    pip3 install pywinrm
    ```
    pywinrm 是用於 Windows 遠端管理的 Python 库，根據需要安裝。

3. 配置 SSH 金鑰:

    Ansible 通常使用 SSH 金鑰來與目標服務器通信。確保您已經生成了 SSH 金鑰，並且已將公鑰添加到所有目標服務器的 ~/.ssh/authorized_keys 文件中。


    ```bash
    # 生成 SSH 金鑰的指令
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

### 步驟 2: 準備 Ansible 環境
1. 克隆或創建專案目錄:

    如果已經有了上述腳本生成的目錄和文件，確保它們的結構正確。如果是從版本控制（如 Git）克隆的，確保所有文件都已經克隆到本地。

2. 檢查和修改配置文件:

    根據您的環境修改 inventory/hosts.ini 文件以反映您的伺服器IP和用戶名。

    ```ini
    [debian]
    192.168.100.10 ansible_user=your_username ansible_ssh_private_key_file=/path/to/private/key
    ```
    並確認 group_vars/all.yml 文件中的 PHP 版本等配置信息正確。

    ```yaml
    php_version: "8.2"
    ```

### 步驟 3: 執行 Ansible Playbook
1. 執行 Playbook:

    在控制機上執行以下命令來部署 LNMP 環境和 Laravel：

    ```bash
    cd lnmp_laravel_setup
    ansible-playbook -i inventory/hosts.ini site.yml
    ```
    這個命令將連接到您在 hosts.ini 中指定的所有服務器，並執行指定的角色和任務來安裝 Nginx, MariaDB, PHP, 以及 Laravel。

### 步驟 4: 驗證安裝
1. 檢查服務器:

    登入到您的服務器上，檢查 Nginx, MariaDB, PHP 以及 Laravel 是否已正確安裝並運行。

    ```bash
    systemctl status nginx
    systemctl status mariadb
    systemctl status php8.2-fpm
    ```
    確認網站根目錄 /var/www/laravel/public 是否包含 Laravel 的文件。

2. 瀏覽 Laravel 應用:

    在瀏覽器中輸入您服務器的 IP 或域名，檢查 Laravel 歡迎頁面是否可以正確顯示。

### 錯誤排查

如果在執行過程中遇到錯誤，檢查以下幾個常見問題點：

- SSH 連接問題：確保所有機器的 ~/.ssh/authorized_keys 包含了您的公鑰。
- 权限问题：確保執行 Ansible 的用戶有足夠的權限來安裝軟件包和修改系統配置。
- 網絡問題：確保所有機器都能夠連接到互聯網，特別是需要安裝外部軟件包時。

這樣，您就可以使用 Ansible 自動化地部署一個完整的 LNMP 環境和 Laravel 框架了。这个过程标准化了部署操作，确保了环境的一致性，极大地简化了管理和后续的维护工作。

## 檔案結構

```python
lnmp_laravel_setup/
│
├── inventory
│   └── hosts.ini        # 庫存檔，包含所有目標主機的信息
│
├── group_vars/
│   └── all.yml          # 用於定義對所有主機有效的變數
│
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   └── main.yml # 包含常見任務，例如系統更新
│   │   └── handlers/
│   │       └── main.yml # 包含 handlers，例如重新啟動服務
│   │
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yml # 安裝和配置 Nginx 的任務
│   │   ├── templates/
│   │   │   └── nginx.conf.j2  # Nginx 配置文件的 Jinja2 模板
│   │   └── handlers/
│   │       └── main.yml # 包含 Nginx 的 handlers
│   │
│   ├── mariadb/
│   │   ├── tasks/
│   │   │   └── main.yml # 安裝和配置 MariaDB 的任務
│   │   └── handlers/
│   │       └── main.yml # 包含 MariaDB 的 handlers
│   │
│   ├── php/
│   │   ├── tasks/
│   │   │   └── main.yml # 安裝和配置 PHP 的任務
│   │   └── handlers/
│   │       └── main.yml # 包含 PHP 的 handlers
│   │
│   └── laravel/
│       ├── tasks/
│       │   └── main.yml # 安裝 Laravel 的任務
│       ├── templates/
│       │   └── laravel.conf.j2  # Laravel Nginx 站點配置模板
│       └── handlers/
│           └── main.yml # 包含 Laravel 的 handlers，例如配置重載
│
├── site.yml             # 主 playbook，引入上述的 roles
└── README.md            # 項目說明文件
```