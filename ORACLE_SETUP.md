# 🎮 GMod DarkRP Server - Oracle Cloud Free Tier Setup

**100% БЕСПЛАТНАЯ** настройка вашего Garry's Mod DarkRP сервера на Oracle Cloud с автоматическим деплоем через GitHub!

---

## 📋 Что вы получите

✅ **Бесплатный сервер навсегда** (Oracle Free Tier)  
✅ **Автоматический деплой** при push в GitHub  
✅ **Полная поддержка UDP** для GMod  
✅ **Публичный IP адрес**  
✅ **До 24 GB RAM** (на Free Tier)  

---

## 🚀 Быстрый старт (5 шагов)

### Шаг 1: Создайте виртуальную машину в Oracle Cloud

1. Войдите в [Oracle Cloud Console](https://cloud.oracle.com/)
2. Перейдите: **Compute** → **Instances** → **Create Instance**

**Настройки VM (ВАЖНО для бесплатного уровня!):**

| Параметр | Значение |
|----------|----------|
| **Name** | `gmod-server` |
| **Image** | `Ubuntu 22.04` (или 20.04) |
| **Shape** | `VM.Standard.E2.1.Micro` ⚠️ **Always Free eligible** |
| **CPU** | 1 OCPU |
| **RAM** | 1 GB (или используйте ARM shape для 24 GB!) |

**⚠️ КРИТИЧЕСКИ ВАЖНО:** Выбирайте только **"Always Free-eligible"** shape, иначе будут списываться деньги!

**Рекомендация для лучшей производительности:**
- Shape: `VM.Standard.A1.Flex` (ARM)
- OCPU: 4
- RAM: 24 GB
- ✅ Это тоже **Always Free**!

3. **SSH Keys**: 
   - Выберите "Generate SSH key pair"
   - **Скачайте приватный ключ** (понадобится позже!)
   - Или используйте существующий SSH ключ

4. **Networking**:
   - Оставьте по умолчанию (создаст новую VCN)
   - ✅ Убедитесь что "Assign a public IPv4 address" включено

5. Нажмите **Create**

6. **Сохраните Public IP** вашей VM (например: `132.145.xxx.xxx`)

---

### Шаг 2: Откройте порты в Oracle Cloud

**В Oracle Cloud Console:**

1. Перейдите: **Networking** → **Virtual Cloud Networks**
2. Выберите вашу VCN (например: `vcn-xxxxx`)
3. Нажмите на **Security Lists** → **Default Security List**
4. Нажмите **Add Ingress Rules**

**Добавьте 2 правила:**

**Правило 1 (UDP):**
- Source CIDR: `0.0.0.0/0`
- IP Protocol: `UDP`
- Destination Port Range: `27015`
- Description: `GMod Server UDP`

**Правило 2 (TCP):**
- Source CIDR: `0.0.0.0/0`
- IP Protocol: `TCP`
- Destination Port Range: `27015`
- Description: `GMod Server TCP`

---

### Шаг 3: Подключитесь к VM и запустите setup

**На вашем компьютере:**

```bash
# Подключитесь к VM (замените на ваш IP и путь к ключу)
ssh -i /path/to/your-private-key ubuntu@YOUR_ORACLE_IP

# После подключения запустите setup скрипт:
curl -fsSL https://raw.githubusercontent.com/zpx9ybf6hg-lang/gmodserver/main/setup-oracle.sh | bash

# Перезагрузите сессию для применения Docker прав
exit
ssh -i /path/to/your-private-key ubuntu@YOUR_ORACLE_IP
```

**Скрипт автоматически:**
- ✅ Установит Docker и Docker Compose
- ✅ Установит Git
- ✅ Склонирует ваш репозиторий
- ✅ Настроит firewall

---

### Шаг 4: Настройте сервер

**На VM:**

```bash
cd ~/gmodserver

# Создайте .env файл
cp .env.oracle .env

# Отредактируйте настройки (опционально)
nano .env
```

**Измените настройки по желанию:**
```bash
GMOD_HOSTNAME=Мой Крутой DarkRP Сервер
GMOD_MAP=rp_downtown_v4c_v2
GMOD_MAXPLAYERS=16
```

**Сохраните:** `Ctrl+O`, `Enter`, `Ctrl+X`

---

### Шаг 5: Запустите сервер!

```bash
cd ~/gmodserver

# Запустите сервер
docker-compose up -d

# Посмотрите логи
docker-compose logs -f
```

**Дождитесь сообщения:**
```
✅ DarkRP installed successfully!
🟢 Starting Garry's Mod Server...
```

**Готово!** Ваш сервер запущен на: `YOUR_ORACLE_IP:27015`

---

## 🤖 Настройка автоматического деплоя через GitHub

### Шаг 1: Настройте SSH ключ для GitHub Actions

**На VM:**

```bash
# Создайте SSH ключ для GitHub Actions
ssh-keygen -t ed25519 -f ~/.ssh/github_actions -N ""

# Добавьте публичный ключ в authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys

# Покажите приватный ключ (скопируйте его!)
cat ~/.ssh/github_actions
```

**Скопируйте весь вывод** (от `-----BEGIN` до `-----END`)

---

### Шаг 2: Добавьте секреты в GitHub

1. Откройте: https://github.com/zpx9ybf6hg-lang/gmodserver/settings/secrets/actions
2. Нажмите **"New repository secret"**

**Добавьте 3 секрета:**

| Name | Value |
|------|-------|
| `ORACLE_HOST` | Ваш Oracle Public IP (например: `132.145.xxx.xxx`) |
| `ORACLE_USERNAME` | `ubuntu` |
| `ORACLE_SSH_KEY` | Приватный ключ из предыдущего шага |

---

### Шаг 3: Готово! Теперь автодеплой работает

**Теперь при каждом push в GitHub:**
1. GitHub Actions автоматически подключится к вашей VM
2. Скачает последние изменения
3. Перезапустит сервер с новыми настройками

**Проверьте:**
```bash
# На вашем компьютере
cd "/Users/cldstprd/gmod server"

# Измените что-нибудь (например, hostname в .env.oracle)
git add .
git commit -m "Test auto-deploy"
git push origin main
```

Зайдите на https://github.com/zpx9ybf6hg-lang/gmodserver/actions и увидите деплой в действии! 🚀

---

## 🎮 Подключение к серверу

### Из Garry's Mod:

1. Откройте консоль (клавиша `` ` ``)
2. Введите:
```
connect YOUR_ORACLE_IP:27015
```

### Или через Server Browser:

1. **Favorites** → **Add Server**
2. Введите: `YOUR_ORACLE_IP:27015`

---

## ⚙️ Управление сервером

### Полезные команды на VM:

```bash
# Посмотреть статус
docker-compose ps

# Посмотреть логи
docker-compose logs -f

# Перезапустить сервер
docker-compose restart

# Остановить сервер
docker-compose down

# Запустить сервер
docker-compose up -d

# Обновить сервер (pull latest code)
git pull origin main
docker-compose down
docker-compose up -d --build
```

---

## 🔧 Настройка сервера

### Изменить настройки сервера:

**На VM:**
```bash
cd ~/gmodserver
nano .env
```

Измените переменные, затем:
```bash
docker-compose restart
```

### Изменить server.cfg:

```bash
nano server.cfg
```

**⚠️ ВАЖНО:** Измените RCON пароль!
```
rcon_password "ваш_новый_пароль"
```

Затем:
```bash
git add server.cfg
git commit -m "Update server.cfg"
git push origin main
```

GitHub Actions автоматически обновит сервер!

---

## 📦 Добавление Workshop контента

### Шаг 1: Получите Steam API ключ

1. Перейдите: https://steamcommunity.com/dev/apikey
2. Введите любой домен (например: `localhost`)
3. Скопируйте ключ

### Шаг 2: Создайте Workshop коллекцию

1. Откройте Steam Workshop для GMod
2. Создайте новую коллекцию
3. Добавьте нужные аддоны (DarkRP jobs, оружие, карты и т.д.)
4. Сделайте коллекцию **публичной**
5. Скопируйте ID коллекции из URL

### Шаг 3: Добавьте в .env

**На VM:**
```bash
cd ~/gmodserver
nano .env
```

Добавьте:
```bash
GMOD_WORKSHOP_API_KEY=ваш_steam_api_ключ
GMOD_WORKSHOP_COLLECTION=id_коллекции
```

Перезапустите:
```bash
docker-compose restart
```

---

## 💰 Как НЕ потратить деньги

### ✅ Что БЕСПЛАТНО навсегда:

- 2x VM.Standard.E2.1.Micro (1 GB RAM каждая)
- 4x ARM-based Ampere A1 cores (до 24 GB RAM!)
- 200 GB Block Volume
- 10 GB Object Storage
- Outbound Data Transfer (10 TB/месяц)

### ⚠️ Как НЕ потратить деньги:

1. **Используйте только Always Free shapes:**
   - `VM.Standard.E2.1.Micro` (x86)
   - `VM.Standard.A1.Flex` (ARM, до 4 OCPU + 24 GB RAM)

2. **НЕ создавайте:**
   - Load Balancers (платные)
   - Дополнительные Block Volumes больше 200 GB
   - Платные shapes (Standard, Optimized и т.д.)

3. **Проверяйте Cost Analysis:**
   - Oracle Console → **Billing & Cost Management**
   - Убедитесь что всё показывает $0.00

---

## 🐛 Troubleshooting

### Сервер не запускается

```bash
# Проверьте логи
docker-compose logs

# Проверьте ресурсы
docker stats

# Перезапустите
docker-compose down
docker-compose up -d
```

### Не могу подключиться

1. **Проверьте порты в Oracle Security List** (Шаг 2)
2. **Проверьте firewall на VM:**
```bash
sudo iptables -L -n | grep 27015
```

3. **Проверьте что сервер запущен:**
```bash
docker-compose ps
```

### GitHub Actions не работает

1. Проверьте секреты в GitHub
2. Проверьте SSH ключ на VM:
```bash
cat ~/.ssh/authorized_keys | grep github_actions
```

3. Проверьте логи Actions на GitHub

### Сервер лагает

**Для ARM shape (24 GB RAM):**
```bash
# Остановите текущий сервер
docker-compose down

# Измените лимиты в docker-compose.yml
nano docker-compose.yml

# Увеличьте memory limits до 4G или больше
# Перезапустите
docker-compose up -d
```

---

## 📊 Мониторинг

### Проверка ресурсов:

```bash
# CPU и RAM
htop

# Docker контейнеры
docker stats

# Диск
df -h
```

---

## 🔒 Безопасность

### Обязательно сделайте:

1. **Измените RCON пароль** в `server.cfg`
2. **Настройте автоматические обновления:**
```bash
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

3. **Настройте firewall:**
```bash
sudo apt-get install ufw
sudo ufw allow 22/tcp
sudo ufw allow 27015/tcp
sudo ufw allow 27015/udp
sudo ufw enable
```

---

## 📚 Полезные ссылки

- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [DarkRP Documentation](https://darkrp.miraheze.org/wiki/Main_Page)
- [GMod Server Setup](https://wiki.facepunch.com/gmod/Creating_A_Server)
- [Docker Documentation](https://docs.docker.com/)

---

## 🎉 Готово!

Ваш GMod DarkRP сервер теперь:
- ✅ Работает **бесплатно** на Oracle Cloud
- ✅ Автоматически обновляется при push в GitHub
- ✅ Имеет полную поддержку UDP
- ✅ Доступен 24/7

**Адрес вашего сервера:** `YOUR_ORACLE_IP:27015`

Приятной игры! 🎮
