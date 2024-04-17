Ansible LNMP + Laravel Setup Project


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