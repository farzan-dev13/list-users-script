# list_users.sh

A simple yet powerful Bash script to display a clean and detailed list of system users.

## 🧩 Features

- Lists real users (ignores system users without valid shells)
- Shows:
  - Username
  - UID
  - User type (System / Normal)
  - Last login (via `lastlog`)
  - Default shell
  - Account status (Active / Locked)
- Clean tabular output
- Fast and portable

## 🚀 Usage

```bash
chmod +x list_users.sh
./list_users.sh
```

Works on most Linux distributions, including Ubuntu, Debian, and Alpine.

## 📁 Output Example

```text
Username             UID        Type     Last Login               Shell                Status
-------------------------------------------------------------------------------------------------------------
root                 0          System   Jul 9  2025              /bin/bash            Active
john                 1001       Normal   Jul 10 2025              /bin/bash            Active
...
```

---


## 👤 Author

**Created by:** Farzan Afringan  
**GitHub:** [farzan-dev13](https://github.com/farzan-dev13)  
**Date:** July 11, 2025


---


