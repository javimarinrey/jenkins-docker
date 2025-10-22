# Usa una imagen base oficial de Jenkins con Java 21
FROM jenkins/jenkins:lts-jdk21

USER root

# Instala dependencias básicas + herramientas de desarrollo
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    maven \
    ant \
    curl \
    gnupg \
    ca-certificates \
    apt-transport-https \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala Docker CLI y Compose Plugin (sin lsb_release ni software-properties-common)
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
      > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*


# Variables de entorno
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH
ENV JENKINS_HOME=/var/jenkins_home

# Verifica las versiones instaladas (opcional)
RUN java -version && \
    mvn -version && \
    ant -version && \
    git --version && \
    node -v && \
    npm -v && \
    docker --version && \
    docker compose version

# Jenkins corre como usuario 'jenkins' por defecto
USER jenkins

# Expone el puerto del servidor Jenkins
EXPOSE 8080

# El punto de entrada ya lo maneja la imagen base de Jenkins
