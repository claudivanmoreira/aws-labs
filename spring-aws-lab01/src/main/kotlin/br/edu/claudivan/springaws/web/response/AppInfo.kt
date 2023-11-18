package br.edu.claudivan.springaws.web.response

data class AppInfo(
    val pid: Long,
    val serverPort: Int,
    val threadName: String
)