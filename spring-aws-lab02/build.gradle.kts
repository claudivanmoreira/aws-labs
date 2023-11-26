import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.springframework.boot.gradle.tasks.bundling.BootJar
import java.util.*

plugins {
    id("org.springframework.boot") version "2.7.17"
    id("io.spring.dependency-management") version "1.0.15.RELEASE"
    kotlin("jvm") version "1.6.21"
    kotlin("plugin.spring") version "1.6.21"
}

group = "br.edu.claudivan"
version = "0.0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_11
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += "-Xjsr305=strict"
        jvmTarget = "11"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.withType<BootJar> {
    archiveFileName = "spring-aws.jar"
}

fun getCommandLineArgs(): Pair<String, String> {
    val osName = System.getProperty("os.name").lowercase(Locale.ROOT)
    return when (osName.contains("windows")) {
        true -> "cmd" to "/c"
        else -> "sh" to "-c"
    }
}

tasks.register<Exec>("docker-prune") {
    group = "docker"
    val dockerTasksDir = file("docker/tasks")

    val (osPrompt, execArg) = getCommandLineArgs()

    val dockerPruneCmd = "${dockerTasksDir.path}${File.separator}docker-prune.$osPrompt"

    commandLine(osPrompt, execArg, dockerPruneCmd)
}

tasks.register<Exec>("docker-certificates") {
    group = "docker"

    dependsOn("build")

    val dockerTasksDir = file("docker/tasks")
    val dockerAppDir = file("docker/app")
    val dockerNginxDir = file("docker/nginx")

    val pathBuildDir = file("build")
    val pathCertificatesDir = file("build/certificates")
    val pathKeystoreDir = file("src/main/resources/keystore")
    val pathJarFile = file("build/libs/spring-aws.jar")

    val (osPrompt, execArg) = getCommandLineArgs()

    val certificatesNotExists = !pathCertificatesDir.exists() || !pathKeystoreDir.exists()

    if (certificatesNotExists) {

        val createCertificatesCmd = "${dockerTasksDir.path}${File.separator}docker-certificate.$osPrompt"

        commandLine(
                osPrompt,
                execArg,
                createCertificatesCmd,
                dockerAppDir,
                dockerNginxDir,
                pathBuildDir,
                pathCertificatesDir,
                pathKeystoreDir,
                pathJarFile
        )
    } else {
        file("${dockerAppDir.path}${File.separator}/spring-aws.jar").apply {
            pathJarFile.copyTo(this, true)
        }
        commandLine(osPrompt, execArg)
    }
}

tasks.register<Exec>("docker-build") {
    group = "docker"

    dependsOn("docker-certificates")

    tasks.findByName("docker-certificates")?.mustRunAfter("docker-stop")

    val dockerTasksDir = file("docker/tasks")

    val (osPrompt, execArg) = getCommandLineArgs()

    val dockerBuildCmd = "${dockerTasksDir.path}${File.separator}docker-build.$osPrompt"

    commandLine(osPrompt, execArg, dockerBuildCmd)
}

tasks.register<Exec>("docker-run") {
    group = "docker"

    dependsOn("docker-stop")

    val dockerTasksDir = file("docker/tasks")

    val (osPrompt, execArg) = getCommandLineArgs()

    val dockerRunCmd = "${dockerTasksDir.path}${File.separator}docker-run.$osPrompt"

    commandLine(osPrompt, execArg, dockerRunCmd)
}

tasks.register<Exec>("docker-stop") {
    group = "docker"

    val dockerTasksDir = file("docker/tasks")

    val (osPrompt, execArg) = getCommandLineArgs()

    val dockerStopCmd = "${dockerTasksDir.path}${File.separator}docker-stop.$osPrompt"

    commandLine(osPrompt, execArg, dockerStopCmd)
}

tasks.register("docker-certificatesBuildAndRun") {
    group = "docker"
    dependsOn("docker-stop")
    dependsOn("docker-build")
    dependsOn("docker-run")

    tasks.findByName("docker-build")?.mustRunAfter("docker-stop")
    tasks.findByName("docker-run")?.mustRunAfter("docker-run")
}

