<img width="2681" height="714" alt="Group 13" src="https://github.com/user-attachments/assets/2bb9758a-b497-44e1-a20f-8da1494a8f13" />

#### Event Management and QR Ticket Verification System developed with Flutter, Node.js and Docker.

## Tech Stack

### Mobile & Frontend
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-State_Management-7952B3?style=for-the-badge&logo=flutter&logoColor=white)

### Backend & Database
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)
![Sequelize](https://img.shields.io/badge/Sequelize-52B0E7?style=for-the-badge&logo=Sequelize&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)

### DevOps & Tools
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-black?style=for-the-badge&logo=JSON%20web%20tokens)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

## System Architecture

```mermaid
graph LR
    %% --- NODES & SHAPES ---
    subgraph Client [Mobile Device]
        Flutter[Flutter App]
    end

    subgraph Backend [Docker Environment]
        direction TB
        Node[Node.js API]
        Postgres[(PostgreSQL)]
    end

    %% --- CONNECTIONS ---
    Flutter -- "REST API / JSON" --> Node
    Node -- "Sequelize ORM" --> Postgres

    %% --- MINIMAL STYLING ---
    style Backend fill:#f9f9f9,stroke:#333,stroke-width:2px,stroke-dasharray: 5 5
    style Postgres fill:#e1f5fe,stroke:#01579b
