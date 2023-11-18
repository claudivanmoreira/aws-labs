package br.edu.claudivan.springaws.web

import br.edu.claudivan.springaws.web.response.AppInfo
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class EchoController {

    @Value("\${server.port}")
    private val serverPort = 0

    @GetMapping("/echo")
    fun echo(): AppInfo {
        return AppInfo(
                pid = ProcessHandle.current().pid(),
                serverPort = serverPort,
                threadName = Thread.currentThread().name
        )
    }
}