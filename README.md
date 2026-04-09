<!-- ===================================================== -->
<!--   DropSpot — README.md (Premium Interactive)          -->
<!--   Classy • Visual • Interactive • Recruiter-Ready     -->
<!-- ===================================================== -->

<div align="center">

<p align="center">
  <img width="100%" alt="DropSpot premium header"
  src="https://capsule-render.vercel.app/api?type=waving&height=220&color=gradient&text=DropSpot&fontSize=54&fontColor=FFFFFF&fontAlignY=40&desc=Location-Based%20AR%20Social%20Platform%20%7C%20PhotoCards%20%7C%20Map%20Discovery%20%7C%20SwiftUI%20%2B%20RealityKit&descAlignY=67&descSize=16&animation=fadeIn" />
</p>

<br/>

<img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-111827?style=for-the-badge&logo=swift&logoColor=F97316"/>
<img alt="ARKit" src="https://img.shields.io/badge/ARKit-111827?style=for-the-badge&logo=apple&logoColor=white"/>
<img alt="RealityKit" src="https://img.shields.io/badge/RealityKit-111827?style=for-the-badge&logo=apple&logoColor=white"/>
<img alt="SwiftData" src="https://img.shields.io/badge/SwiftData-111827?style=for-the-badge&logo=swift&logoColor=white"/>
<img alt="MapKit" src="https://img.shields.io/badge/MapKit-111827?style=for-the-badge&logo=applemaps&logoColor=white"/>
<img alt="CoreLocation" src="https://img.shields.io/badge/CoreLocation-111827?style=for-the-badge&logo=apple&logoColor=white"/>
<img alt="Spatial Computing" src="https://img.shields.io/badge/Theme-Spatial%20Computing-111827?style=for-the-badge"/>
<img alt="AR Social" src="https://img.shields.io/badge/Domain-AR%20Social%20Experience-111827?style=for-the-badge"/>

<br/><br/>

<a href="#-project-overview"><b>Overview</b></a> •
<a href="#-problem-space"><b>Problem</b></a> •
<a href="#-experience-architecture"><b>Architecture</b></a> •
<a href="#-dropspot-experience-universe"><b>Experience Universe</b></a> •
<a href="#-technical-highlights"><b>Tech</b></a> •
<a href="#-why-this-project-matters"><b>Impact</b></a> •
<a href="#-contact"><b>Contact</b></a>

</div>

---

## 🌍 Project Overview

**DropSpot** is a **location-based AR social platform** that lets users create, save, discover, and relive memories through **PhotoCards** connected to real-world places.

Instead of storing media as flat content inside a traditional gallery, DropSpot transforms photos into **location-aware digital experiences** that can be explored through:

- 📸 PhotoCard creation  
- 📍 Place-linked memories  
- 🗺 Map-based discovery  
- 🧠 Augmented reality visualization  
- 🖼 Personal gallery recall  

It is a project built at the intersection of **social experience design**, **spatial computing**, and **immersive storytelling**.

---

## 🧩 Problem Space

Most photo-sharing products separate **media** from **place**.

That means:
- memories are stored, but not spatially experienced
- photos lose their physical context
- discovery becomes feed-based instead of environment-based
- emotional recall is weaker because the “where” disappears

**DropSpot** addresses this by binding digital memories to the physical world.

This enables:
- 📍 place-aware memory recall  
- 🧠 stronger emotional context  
- 🌐 spatial storytelling  
- ✨ a more immersive social interaction model  

---

## 🧠 Experience Architecture

<details open>
<summary><b>🛰 From Capture to Spatial Experience (click to collapse)</b></summary>
<br/>

```mermaid
graph LR

    CAPTURE["📸 Capture PhotoCard"] --> STORE["💾 Save with SwiftData"]
    STORE --> MAP["🗺 Attach to Map"]
    MAP --> DISCOVER["📍 Discover by Location"]
    DISCOVER --> AR["🧠 Launch AR Experience"]
    AR --> MEMORY["✨ Spatial Memory Recall"]

    style CAPTURE fill:#0B1220,stroke:#60A5FA,color:#E5E7EB
    style STORE fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style MAP fill:#111827,stroke:#F472B6,color:#E5E7EB
    style AR fill:#102a43,stroke:#22D3EE,color:#E5E7EB
    style MEMORY fill:#062a1d,stroke:#16A34A,color:#E5E7EB
```

</details>

---

## 🌌 DropSpot Experience Universe

<details open>
<summary><b>✨ Explore the product as an experience system (click to collapse)</b></summary>
<br/>

```mermaid
graph LR

    USER["👤 Explorer"] --> CREATE["📸 Create a PhotoCard"]
    USER --> BROWSE["🗺 Browse the Map"]
    USER --> COLLECT["🖼 Revisit Personal Gallery"]

    CREATE --> PLACE["📍 Bind Memory to Place"]
    BROWSE --> DISCOVER["🌍 Discover Memories by Location"]
    COLLECT --> RELIVE["💫 Relive Saved Moments"]

    PLACE --> AR["🧠 View in AR"]
    DISCOVER --> AR
    RELIVE --> AR

    AR --> STORY["📖 Spatial Storytelling"]
    STORY --> EMOTION["💙 Context + Emotion + Presence"]

    style USER fill:#0B1220,stroke:#60A5FA,stroke-width:3px,color:#E5E7EB
    style CREATE fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style BROWSE fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style COLLECT fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style AR fill:#102a43,stroke:#22D3EE,color:#E5E7EB
    style EMOTION fill:#062a1d,stroke:#16A34A,color:#E5E7EB
```

</details>

<div align="center">

<table>
<tr>
<td width="33%" align="center" valign="top">

### 📸 Create
Users capture or build a PhotoCard, turning a moment into a shareable memory artifact.

<img src="https://img.shields.io/badge/Layer-Memory%20Creation-0EA5E9?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 📍 Place
Each memory is tied to physical location, giving the content spatial relevance and context.

<img src="https://img.shields.io/badge/Layer-Spatial%20Context-7C3AED?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 🧠 Relive
The experience can be rediscovered through maps, galleries, and AR-based spatial recall.

<img src="https://img.shields.io/badge/Layer-Immersive%20Recall-16A34A?style=for-the-badge"/>

</td>
</tr>
</table>

</div>

---

## 🎭 Interactive Product Modes

<details>
<summary><b>📲 DropSpot is not one interface — it is three connected modes (click to expand)</b></summary>
<br/>

### 🗺 Map Mode
- Discover memories through geographic context
- Navigate through pinned content
- Experience place as an entry point

### 📸 Creation Mode
- Capture a moment
- Turn it into a PhotoCard
- Attach metadata and location

### 🧠 AR Mode
- Project digital content into physical space
- Revisit saved placements
- Experience memory through immersion rather than scrolling

</details>

---

## 🔬 Product Interaction Framework

<details open>
<summary><b>📲 User interaction journey (click to collapse)</b></summary>
<br/>

```mermaid
graph LR

    TAB["📱 Tab Navigation"] --> MAPTAB["🗺 Map"]
    TAB --> CAMTAB["📸 Create"]
    TAB --> GALLERYTAB["🖼 Gallery"]

    CAMTAB --> CARD["✨ PhotoCard Creation"]
    CARD --> SAVE["💾 Save Content + Metadata"]
    SAVE --> LOC["📍 Attach Location"]

    MAPTAB --> DISCOVER["📌 Explore Pins"]
    DISCOVER --> DETAIL["🖼 Card Detail"]

    GALLERYTAB --> DETAIL
    DETAIL --> AR["🧠 AR View"]
    AR --> REVISIT["🔁 Persistent Recall"]

    style TAB fill:#0B1220,stroke:#60A5FA,color:#E5E7EB
    style CARD fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style DETAIL fill:#111827,stroke:#F472B6,color:#E5E7EB
    style AR fill:#102a43,stroke:#22D3EE,color:#E5E7EB
    style REVISIT fill:#062a1d,stroke:#16A34A,color:#E5E7EB
```

</details>

---

## 🎯 Premium Feature Themes

<div align="center">

<table>
<tr>
<td width="33%" align="center" valign="top">

### 📸 PhotoCard Creation
- Capture visual moments  
- Create memory artifacts  
- Store rich visual context  

<img src="https://img.shields.io/badge/Feature-PhotoCards-0EA5E9?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 🗺 Location Discovery
- Pin content to coordinates  
- Explore by geography  
- Turn the map into an interface  

<img src="https://img.shields.io/badge/Feature-Map%20Discovery-7C3AED?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 🧠 Persistent AR
- Place cards in space  
- Reload saved positions  
- Connect digital memory with physical presence  

<img src="https://img.shields.io/badge/Feature-Persistent%20AR-16A34A?style=for-the-badge"/>

</td>
</tr>
</table>

</div>

---

## 🧠 Architecture Intelligence Model

<details open>
<summary><b>⚙️ System design thinking (click to collapse)</b></summary>
<br/>

```mermaid
graph LR

    CAMERA["📸 Camera / Input"] --> CARD["🖼 PhotoCard Model"]
    CARD --> DATA["💾 SwiftData Storage"]
    DATA --> MAP["🗺 Map Rendering"]
    DATA --> GALLERY["🗂 Gallery View"]
    GALLERY --> DETAIL["🖼 Card Detail View"]
    DETAIL --> AR["🧠 AR Presentation"]

    LOCATION["📍 CoreLocation"] --> MAP
    LOCATION --> CARD

    AR --> PERSIST["💾 AR Position Persistence"]
    PERSIST --> RELOAD["🔁 Rehydrated AR Gallery"]

    style CAMERA fill:#0B1220,stroke:#60A5FA,color:#E5E7EB
    style DATA fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style MAP fill:#111827,stroke:#F472B6,color:#E5E7EB
    style AR fill:#102a43,stroke:#22D3EE,color:#E5E7EB
    style RELOAD fill:#062a1d,stroke:#16A34A,color:#E5E7EB
```

</details>

---

## 🏗 Architecture Decisions

<div align="center">

<table>
<tr>
<td width="33%" align="center" valign="top">

### 📱 SwiftUI-First UI
- Declarative interface  
- Clean navigation patterns  
- Fast product iteration  

<img src="https://img.shields.io/badge/Decision-Modern%20iOS%20UI-0EA5E9?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 💾 Local-First Persistence
- SwiftData-backed storage  
- Fast local access  
- Strong offline-friendly behavior  

<img src="https://img.shields.io/badge/Decision-Local%20Persistence-7C3AED?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 🌐 Spatial Experience Layer
- ARKit + RealityKit integration  
- Real-world anchor thinking  
- Digital content with physical context  

<img src="https://img.shields.io/badge/Decision-Spatial%20Computing-16A34A?style=for-the-badge"/>

</td>
</tr>
</table>

</div>

---

## 📦 Technical Highlights

- Built with **SwiftUI** for modern declarative UI
- Uses **SwiftData** for local PhotoCard persistence
- Integrates **MapKit** for map-based memory discovery
- Uses **CoreLocation** to bind content to real-world coordinates
- Supports **ARKit + RealityKit** for immersive card visualization
- Includes **AR position persistence** to reload spatial placements
- Multi-view experience across:
  - map exploration
  - card creation
  - detail interaction
  - AR presentation
  - gallery browsing

---

## 📂 Project Structure

```bash
DropSpot/
├── dropspot_/
│   ├── ContentView.swift            # Main tab-based shell
│   ├── MapTabView.swift             # Map discovery experience
│   ├── Addcards.swift               # PhotoCard creation flow
│   ├── CameraView.swift             # Camera integration
│   ├── modelsphotocard.swift        # Core PhotoCard model
│   ├── carddetailview.swift         # Detailed card interface
│   ├── ArCardView.swift             # AR single-card experience
│   ├── ARGalleryView.swift          # Restored AR gallery view
│   ├── ARCardPersistence.swift      # Spatial transform persistence
│   ├── LocationManager.swift        # GPS / location logic
│   ├── PolaroidBuilder.swift        # Card styling and composition
│   ├── Extensions.swift             # Utility extensions
│   └── babyApp.swift                # App entry point
├── Assets/                          # Characters and image assets
├── PRIVACY_POLICY.md
└── LICENSE
```

---

## 🚀 Future Expansion Path

<details open>
<summary><b>🔮 From memory app to spatial social platform (click to collapse)</b></summary>
<br/>

```mermaid
graph LR

    CURRENT["📱 Current App"] --> CLOUD["☁️ Cloud Sync"]
    CLOUD --> SHARED["👥 Shared Memory Spaces"]
    SHARED --> SOCIAL["🌐 Social Discovery Layer"]
    SOCIAL --> RECS["🎯 Place-Aware Recommendations"]
    RECS --> PLATFORM["🧠 Intelligent Spatial Platform"]

    style CURRENT fill:#0B1220,stroke:#60A5FA,color:#E5E7EB
    style CLOUD fill:#0F172A,stroke:#A78BFA,color:#E5E7EB
    style SOCIAL fill:#102a43,stroke:#22D3EE,color:#E5E7EB
    style PLATFORM fill:#062a1d,stroke:#16A34A,color:#E5E7EB
```

</details>

---

## 🌟 Why This Project Matters

<div align="center">

<table>
<tr>
<td width="33%" align="center" valign="top">

### 🧠 Product Thinking
- Turns media into experience  
- Builds emotional + spatial value  
- Strong user-story foundation  

<img src="https://img.shields.io/badge/Signal-Product%20Depth-0EA5E9?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### ⚙️ Engineering Depth
- Cross-framework integration  
- UI + data + maps + AR coordination  
- Rich interaction complexity  

<img src="https://img.shields.io/badge/Signal-Engineering%20Depth-7C3AED?style=for-the-badge"/>

</td>

<td width="33%" align="center" valign="top">

### 🚀 Future Relevance
- Strong Apple ecosystem alignment  
- Spatial computing foundation  
- Expandable into social + AI systems  

<img src="https://img.shields.io/badge/Signal-Future%20Ready-16A34A?style=for-the-badge"/>

</td>
</tr>
</table>

</div>

---

## 🧪 Core Concepts Demonstrated

- spatial UX design  
- location-aware content systems  
- persistent augmented reality  
- declarative iOS architecture  
- real-world memory mapping  
- immersive interaction design  

---

## 🤝 Contact

<div align="center">

<a href="https://www.linkedin.com/in/navyashree-byregowda-472821196/">
  <img src="https://img.shields.io/badge/LinkedIn-Connect-1E40AF?style=for-the-badge&logo=linkedin&logoColor=white"/>
</a>

<a href="https://github.com/Navyagowda2714">
  <img src="https://img.shields.io/badge/GitHub-Portfolio-111827?style=for-the-badge&logo=github&logoColor=white"/>
</a>

<a href="mailto:navyashreebyregowda@gmail.com">
  <img src="https://img.shields.io/badge/Email-Let's%20Talk-DC2626?style=for-the-badge&logo=gmail&logoColor=white"/>
</a>

<br/><br/>
<sub>DropSpot — where places become living digital memory spaces.</sub>

</div>
