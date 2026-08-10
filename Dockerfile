FROM eclipse-temurin:21-jre

RUN apt-get update && apt-get install -y curl jq

RUN useradd -m -d /server minecraft
WORKDIR /server
USER minecraft

ARG PAPER_VERSION=1.21.11
ARG PAPER_BUILD=69
RUN DOWNLOAD_URL=$(curl -s -H "User-Agent: msud-workshop-student (https://github.com/msu-denver)" \
      "https://fill.papermc.io/v3/projects/paper/versions/${PAPER_VERSION}/builds" \
      | jq -r --argjson build "${PAPER_BUILD}" 'first(.[] | select(.id == $build)) | .downloads."server:default".url') \
    && echo "Downloading: ${DOWNLOAD_URL}" \
    && curl -fo paper.jar -H "User-Agent: msud-workshop-student (https://github.com/msu-denver)" "${DOWNLOAD_URL}"

RUN echo "eula=true" > eula.txt

RUN mkdir -p plugins \
    && curl -fLo plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot \
    && curl -fLo plugins/Floodgate-Spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

EXPOSE 25565
EXPOSE 19132/udp
CMD ["java", "-Xms1G", "-Xmx2G", "-jar", "paper.jar", "--nogui"]