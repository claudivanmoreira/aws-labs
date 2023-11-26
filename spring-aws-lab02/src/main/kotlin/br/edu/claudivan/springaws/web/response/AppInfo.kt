package br.edu.claudivan.springaws.web.response

data class AppInfo(
    val pid: Long,
    val instanceName: String,
    val threadName: String
)