# Directory Structure for Keycloak Customizing

keycloak/
├── providers/
│   └── keycloak-company-provisioner-1.0.0.jar    ← Your custom JAR here
├── themes/
│   └── smetools/                                 ← Your custom theme here
│       └── login/
│           ├── theme.properties
│           ├── template.ftl
│           ├── login.ftl
│           ├── register.ftl
│           ├── resources/
│           │   ├── css/login.css
│           │   └── img/logo.svg
│           └── messages/
│               ├── messages_de.properties
│               └── messages_en.properties
└ docker-compose.yml