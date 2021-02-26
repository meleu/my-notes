# SonarQube

## SAST - Static Application Security Testing

SonarQube is an open source SAST tool. It scans the codebase for bugs, vulnerabilities, code smells, etc. It's useful to avoid Technical Debt.

## Video: Integração Contínua (CI) do ZERO com Sonarqube

- link: <https://youtu.be/oObcolQppS8>

- 00:00 - 11:50: Intro
- 11:55: Starts the practical part

Installation instructions: <https://docs.sonarqube.org/latest/setup/install-server/>
```sh
docker run --rm \
    -p 9000:9000 \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    <image_name>
# example for image_name: sonarqube:7.9.3-community

# check if it's running
docker logs sonarqube
```

Access http://localhost:9000

> credentials: admin/admin

Note: in production it's important to have the database in a different container than the one running sonarqube.

- 19:10 - Creating a new project
    - project key
    - project token
    - install SonarScanner
    - `sonar-project.properties`
        - rename: 21:55
        - edit: 26:40

