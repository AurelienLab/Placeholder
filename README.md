# Placeholder & Avatar Image Downloader

This project includes two scripts (`download.sh` and `download.ps1`) to help you download:

- High-resolution **placeholder images** from [Picsum Photos](https://picsum.photos)
- Realistic **profile avatars** from [Pravatar.cc](https://pravatar.cc)

Downloads are organized into folders by format and orientation.

---

## 📦 Features

- 📐 Choose image formats via predefined **profiles**:
  - Web (landscape)
  - Mobile (portrait)
  - Square
  - All
  - Manual selection
- 🧑‍💼 Download avatar images in square sizes from 64px to 800px
- 📁 Files are organized into folders like:
  - `placeholders/1920x1080_landscape/`
  - `avatars/256x256/`
- 🏷️ Supports flags:
  - `--avatar-only`
  - `--placeholder-only`

---

## 🛠️ Usage

### 🔧 Requirements

- **Bash + curl** (Linux/macOS)
- **PowerShell + Invoke-WebRequest** (Windows)

---

### 🚀 Bash script (`download.sh`)

#### 1. Make it executable:
```bash
chmod +x download.sh
```

#### 2. Run interactively:
```bash
./download.sh
```

#### 3. Run with options:
- Only avatars:
  ```bash
  ./download.sh --avatar-only
  ```
- Only placeholders:
  ```bash
  ./download.sh --placeholder-only
  ```

---

### 💻 PowerShell script (`download.ps1`)

#### 1. Run with PowerShell:
```powershell
.\download.ps1
```

You will be prompted to choose a format profile.

#### 2. Optional flags:
- Only avatars:
  ```powershell
  .\download.ps1 -AvatarOnly
  ```
- Only placeholders:
  ```powershell
  .\download.ps1 -PlaceholderOnly
  ```

---

## 📂 Folder Structure

```
placeholders/
  1280x720_landscape/
  1080x1920_portrait/
avatars/
  256x256/
  800x800/
```

---

## 📄 License

Free to use for testing, design, development, or education.